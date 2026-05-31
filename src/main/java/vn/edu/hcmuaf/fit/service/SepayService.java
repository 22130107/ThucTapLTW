package vn.edu.hcmuaf.fit.service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.PaymentTransactionDAO;
import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.PaymentTransaction;
import vn.edu.hcmuaf.fit.util.SepayConfig;
import vn.edu.hcmuaf.fit.util.SepayUtil;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.logging.Logger;

public class SepayService {
    private static final Logger LOGGER = Logger.getLogger(SepayService.class.getName());
    private static final SepayService INSTANCE = new SepayService();
    private final OrderDAO orderDAO = OrderDAO.getInstance();
    private final PaymentTransactionDAO txnDAO = PaymentTransactionDAO.getInstance();

    private SepayService() {}

    public static SepayService getInstance() { return INSTANCE; }

    public QrPaymentData createQrPayment(int orderId) {
        Order order = orderDAO.getById(orderId);
        if (order == null)
            throw new IllegalArgumentException("[SepayService] Order not found: " + orderId);

        long amount = (long) order.getTotalAmount();
        String content = SepayUtil.buildTransferContent(orderId);
        String qrImageUrl = SepayUtil.buildQrImageUrl(amount, content);
        int expiryMinutes = SepayConfig.QR_EXPIRY_MINUTES();

        LOGGER.info("[SepayService] QR created orderId=" + orderId
                + " amount=" + amount + " content=" + content);

        return new QrPaymentData(orderId, amount, content, qrImageUrl,
                SepayConfig.BANK_CODE(), SepayConfig.BANK_ACCOUNT(),
                SepayConfig.ACCOUNT_NAME(), expiryMinutes);
    }

    public WebhookResult handleWebhook(String rawBody) {
        LOGGER.info("[SepayService] Webhook body: " + rawBody);

        JsonObject json;
        try {
            json = JsonParser.parseString(rawBody).getAsJsonObject();
        } catch (Exception e) {
            LOGGER.warning("[SepayService] Cannot parse JSON: " + e.getMessage());
            return WebhookResult.failure("Invalid JSON: " + e.getMessage());
        }

        String secret = SepayConfig.WEBHOOK_SECRET();
        if (secret != null && !secret.isEmpty()) {
            String checksum = getStr(json, "checksum");
            if (!SepayUtil.verifyWebhookSignature(rawBody, checksum, secret)) {
                LOGGER.warning("[SepayService] Checksum mismatch – rejecting");
                return WebhookResult.failure("Invalid checksum");
            }
            LOGGER.info("[SepayService] Checksum OK");
        } else {
            LOGGER.warning("[SepayService] SEPAY_WEBHOOK_SECRET not set – skipping checksum verification");
        }

        String transferType = getStr(json, "transferType");
        if (!"in".equalsIgnoreCase(transferType)) {
            LOGGER.info("[SepayService] Ignoring non-incoming transfer: " + transferType);
            return WebhookResult.ignored("Not incoming");
        }

        String code = getStr(json, "code");
        String content = getStr(json, "content");
        LOGGER.info("[SepayService] code=" + code + " content=" + content);

        int orderId = parseOrderId(code);
        if (orderId == -1) {
            LOGGER.info("[SepayService] code field empty/unparseable – trying content field");
            orderId = parseOrderId(content);
        }
        if (orderId == -1) {
            LOGGER.warning("[SepayService] Cannot find orderId in code='" + code
                    + "' content='" + content + "'");
            return WebhookResult.failure("Cannot identify order from code/content");
        }
        LOGGER.info("[SepayService] Resolved orderId=" + orderId);

        Order order = orderDAO.getById(orderId);
        if (order == null) {
            LOGGER.warning("[SepayService] Order not found: " + orderId);
            return WebhookResult.failure("Order not found: " + orderId);
        }

        PaymentTransaction existing = txnDAO.findSuccessByOrderId(orderId);
        if (existing != null) {
            LOGGER.info("[SepayService] Duplicate – orderId=" + orderId + " already paid");
            return WebhookResult.ignored("Already paid");
        }

        long receivedAmount = getLong(json, "transferAmount");
        long expectedAmount = (long) order.getTotalAmount();
        boolean amountOk = receivedAmount >= expectedAmount;
        LOGGER.info("[SepayService] Amount expected=" + expectedAmount
                + " received=" + receivedAmount + " ok=" + amountOk);

        String sepayTxnId = getStr(json, "id");
        String gateway = getStr(json, "gateway");
        String txnDate = getStr(json, "transactionDate");
        String orderInfo = content != null ? content : (code != null ? code : "");
        String status = amountOk ? "SUCCESS" : "AMOUNT_MISMATCH";

        PaymentTransaction tx = new PaymentTransaction();
        tx.setOrderId(orderId);
        tx.setTxnRef("SEPAY_" + orderId + "_" + System.currentTimeMillis());
        tx.setVnpTransactionNo(sepayTxnId);
        tx.setAmount(receivedAmount);
        tx.setBankCode(gateway);
        tx.setPayDate(txnDate);
        tx.setResponseCode(amountOk ? "00" : "99");
        tx.setTransactionStatus(amountOk ? "00" : "99");
        tx.setOrderInfo(orderInfo);
        tx.setStatus(status);
        tx.setCreatedAt(new Timestamp(Instant.now().toEpochMilli()));

        int txId = txnDAO.save(tx);
        LOGGER.info("[SepayService] Transaction saved id=" + txId
                + " status=" + status + " orderId=" + orderId);

        if (amountOk) {
            orderDAO.updateStatus(orderId, "Processing");
            LOGGER.info("[SepayService] Order " + orderId + " → Processing");
            return WebhookResult.success(orderId, sepayTxnId, receivedAmount);
        } else {
            orderDAO.updateStatus(orderId, "PaymentMismatch");
            return WebhookResult.failure("Amount mismatch: expected " + expectedAmount
                    + " got " + receivedAmount);
        }
    }

    public PaymentStatus checkPaymentStatus(int orderId) {
        Order order = orderDAO.getById(orderId);
        if (order == null) return PaymentStatus.NOT_FOUND;

        PaymentTransaction tx = txnDAO.findSuccessByOrderId(orderId);
        if (tx != null) return PaymentStatus.SUCCESS;

        String s = order.getStatus();
        if ("Cancelled".equalsIgnoreCase(s)) return PaymentStatus.CANCELLED;

        return PaymentStatus.PENDING;
    }

    private static String getStr(JsonObject json, String key) {
        try {
            return json.has(key) && !json.get(key).isJsonNull() ? json.get(key).getAsString().trim() : null;
        } catch (Exception e) { return null; }
    }

    private static long getLong(JsonObject json, String key) {
        try {
            return json.has(key) && !json.get(key).isJsonNull()
                    ? json.get(key).getAsLong() : 0L;
        } catch (Exception e) { return 0L; }
    }

    static int parseOrderId(String s) {
        if (s == null || s.isBlank()) return -1;
        java.util.regex.Matcher m =
                java.util.regex.Pattern.compile("(?i)DH\\s*(\\d+)").matcher(s);
        if (m.find()) {
            try { return Integer.parseInt(m.group(1)); } catch (NumberFormatException ignored) {}
        }
        String trimmed = s.trim();
        if (trimmed.matches("\\d+")) {
            try { return Integer.parseInt(trimmed); } catch (NumberFormatException ignored) {}
        }
        return -1;
    }

    public enum PaymentStatus { PENDING, SUCCESS, CANCELLED, NOT_FOUND }

    public static final class QrPaymentData {
        private final int orderId;
        private final long amount;
        private final String transferContent;
        private final String qrImageUrl;
        private final String bankCode;
        private final String bankAccount;
        private final String accountName;
        private final int expiryMinutes;

        public QrPaymentData(int orderId, long amount, String transferContent,
                             String qrImageUrl, String bankCode, String bankAccount,
                             String accountName, int expiryMinutes) {
            this.orderId = orderId;
            this.transferContent = transferContent;
            this.qrImageUrl = qrImageUrl;
            this.bankCode = bankCode;
            this.bankAccount = bankAccount;
            this.accountName = accountName;
            this.amount = amount;
            this.expiryMinutes = expiryMinutes;
        }

        public int getOrderId() { return orderId; }
        public long getAmount() { return amount; }
        public String getTransferContent() { return transferContent; }
        public String getQrImageUrl() { return qrImageUrl; }
        public String getBankCode() { return bankCode; }
        public String getBankAccount() { return bankAccount; }
        public String getAccountName() { return accountName; }
        public int getExpiryMinutes() { return expiryMinutes; }
    }

    public static final class WebhookResult {
        public enum Type { SUCCESS, FAILURE, IGNORED }
        private final Type type;
        private final int orderId;
        private final String sepayTxnId;
        private final long amount;
        private final String message;

        private WebhookResult(Type t, int id, String txnId, long amt, String msg) {
            this.type = t; this.orderId = id; this.sepayTxnId = txnId;
            this.amount = amt; this.message = msg;
        }

        public static WebhookResult success(int id, String txnId, long amt) {
            return new WebhookResult(Type.SUCCESS, id, txnId, amt, null);
        }
        public static WebhookResult failure(String msg) {
            return new WebhookResult(Type.FAILURE, -1, null, 0, msg);
        }
        public static WebhookResult ignored(String msg) {
            return new WebhookResult(Type.IGNORED, -1, null, 0, msg);
        }

        public boolean isSuccess() { return type == Type.SUCCESS; }
        public boolean isFailure() { return type == Type.FAILURE; }
        public int getOrderId() { return orderId; }
        public String getSepayTxnId() { return sepayTxnId; }
        public long getAmount() { return amount; }
        public String getMessage() { return message; }
    }
}