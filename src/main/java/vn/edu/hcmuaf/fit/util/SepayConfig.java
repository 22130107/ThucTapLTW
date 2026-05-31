package vn.edu.hcmuaf.fit.util;

public final class SepayConfig {
    private SepayConfig() {}

    private static String get(String key, String defaultValue) {
        String v = EnvLoader.get(key);
        return (v != null && !v.isBlank()) ? v.trim() : defaultValue;
    }

    public static String API_KEY() {
        return get("SEPAY_API_KEY", "");
    }

    public static String WEBHOOK_SECRET() {
        return get("SEPAY_WEBHOOK_SECRET", "");
    }

    public static String BANK_ACCOUNT() {
        return get("SEPAY_BANK_ACCOUNT", "");
    }

    public static String BANK_CODE() {
        return get("SEPAY_BANK_CODE", "");
    }

    public static String ACCOUNT_NAME() {
        return get("SEPAY_ACCOUNT_NAME", "");
    }

    public static String API_BASE_URL() {
        return get("SEPAY_API_BASE_URL", "https://my.sepay.vn/userapi");
    }

    public static int QR_EXPIRY_MINUTES() {
        try {
            return Integer.parseInt(get("SEPAY_QR_EXPIRY_MINUTES", "15"));
        } catch (NumberFormatException e) {
            return 15;
        }
    }

    public static void validate() {
        if (API_KEY().isEmpty()) throw new IllegalStateException("SEPAY_API_KEY is not configured in .env");
        if (BANK_ACCOUNT().isEmpty()) throw new IllegalStateException("SEPAY_BANK_ACCOUNT is not configured in .env");
        if (BANK_CODE().isEmpty()) throw new IllegalStateException("SEPAY_BANK_CODE is not configured in .env");
    }
}