package vn.edu.hcmuaf.fit.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

public final class SepayUtil {
    private static final Logger LOGGER = Logger.getLogger(SepayUtil.class.getName());
    private SepayUtil() {}

    public static String buildQrImageUrl(long amount, String content) {
        String bankCode = SepayConfig.BANK_CODE();
        String bankAccount = SepayConfig.BANK_ACCOUNT();
        String accountName = SepayConfig.ACCOUNT_NAME();

        if (bankCode.isEmpty() || bankAccount.isEmpty()) {
            throw new IllegalStateException("[SepayUtil] SEPAY_BANK_CODE / SEPAY_BANK_ACCOUNT not configured");
        }

        StringBuilder url = new StringBuilder("https://qr.sepay.vn/img");
        url.append("?bank=").append(encode(bankCode));
        url.append("&acc=").append(encode(bankAccount));
        url.append("&template=compact");
        url.append("&amount=").append(amount);
        url.append("&des=").append(encode(content));
        if (!accountName.isEmpty()) {
            url.append("&holder=").append(encode(accountName));
        }

        return url.toString();
    }

    public static String buildTransferContent(int orderId) {
        return "DH" + orderId;
    }

    public static boolean verifyWebhookSignature(String rawBody, String signature, String secret) {
        if (signature == null || signature.isEmpty() || secret == null || secret.isEmpty()) {
            LOGGER.warning("[SepayUtil] Missing signature or secret – rejecting webhook");
            return false;
        }
        try {
            String computed = hmacSha256(rawBody, secret);
            boolean match = computed.equalsIgnoreCase(signature);
            if (!match) {
                LOGGER.warning("[SepayUtil] Signature mismatch. expected=" + computed + " got=" + signature);
            }
            return match;
        } catch (Exception e) {
            LOGGER.severe("[SepayUtil] Signature verification error: " + e.getMessage());
            return false;
        }
    }

    public static String hmacSha256(String data, String secret) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }
    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}