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