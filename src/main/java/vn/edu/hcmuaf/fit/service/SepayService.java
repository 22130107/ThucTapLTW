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