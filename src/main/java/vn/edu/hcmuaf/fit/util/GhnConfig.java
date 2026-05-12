package vn.edu.hcmuaf.fit.util;

/**
 * Cấu hình GHN — đọc từ EnvLoader (ưu tiên System.getenv → System.getProperty → WEB-INF/.env)
 */
public class GhnConfig {

    private GhnConfig() {}

    private static String get(String key, String defaultValue) {
        String v = EnvLoader.get(key);
        return (v != null && !v.isEmpty()) ? v : defaultValue;
    }

    private static int getInt(String key, int defaultValue) {
        try {
            return Integer.parseInt(get(key, String.valueOf(defaultValue)));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static String BASE_URL()         { return get("GHN_BASE_URL",          "https://online-gateway.ghn.vn/shiip/public-api"); }
    public static String TOKEN()            { return get("GHN_TOKEN",             ""); }
    public static String SHOP_ID()          { return get("GHN_SHOP_ID",           ""); }
    public static String FROM_NAME()        { return get("GHN_FROM_NAME",         "Shop"); }
    public static String FROM_PHONE()       { return get("GHN_FROM_PHONE",        ""); }
    public static String FROM_ADDRESS()     { return get("GHN_FROM_ADDRESS",      ""); }
    public static int    FROM_DISTRICT_ID() { return getInt("GHN_FROM_DISTRICT_ID", 0); }
    public static String FROM_WARD_CODE()   { return get("GHN_FROM_WARD_CODE",    ""); }
    public static int    SERVICE_TYPE_ID()  { return getInt("GHN_SERVICE_TYPE_ID",  2); }
    public static int    PAYMENT_TYPE_ID()  { return getInt("GHN_PAYMENT_TYPE_ID",  2); }
    public static int    DEFAULT_WEIGHT()   { return getInt("GHN_WEIGHT",           500); }
    public static int    DEFAULT_LENGTH()   { return getInt("GHN_LENGTH",           20); }
    public static int    DEFAULT_WIDTH()    { return getInt("GHN_WIDTH",            15); }
    public static int    DEFAULT_HEIGHT()   { return getInt("GHN_HEIGHT",           10); }
}
