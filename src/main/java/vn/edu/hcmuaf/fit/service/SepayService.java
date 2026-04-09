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