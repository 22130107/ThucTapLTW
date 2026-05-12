package vn.edu.hcmuaf.fit.util;

import jakarta.servlet.ServletContext;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.File;
import java.io.FileReader;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Đọc file .env và lưu vào map tĩnh nội bộ.
 * GhnConfig đọc từ EnvLoader.get() thay vì System.getenv().
 *
 * Ưu tiên tìm theo thứ tự:
 *   1. WEB-INF/.env  (qua ServletContext — chắc chắn nhất khi chạy trong Tomcat)
 *   2. Thư mục gốc project (leo lên từ user.dir — dùng khi chạy test/local)
 */
public class EnvLoader {

    private static final Map<String, String> ENV = new HashMap<>();

    private EnvLoader() {}

    /** Lấy giá trị biến môi trường — ưu tiên System.getenv, fallback map nội bộ */
    public static String get(String key) {
        String v = System.getenv(key);
        if (v != null && !v.isEmpty()) return v;
        v = System.getProperty(key);
        if (v != null && !v.isEmpty()) return v;
        return ENV.getOrDefault(key, "");
    }

    /** Gọi từ AppContextListener — ưu tiên đọc từ WEB-INF/.env */
    public static void load(ServletContext ctx) {
        try (InputStream is = ctx.getResourceAsStream("/WEB-INF/.env")) {
            if (is != null) {
                Map<String, String> vars = parse(new BufferedReader(
                        new InputStreamReader(is, StandardCharsets.UTF_8)));
                ENV.putAll(vars);
                System.out.println("[EnvLoader] Loaded " + vars.size()
                        + " variables from WEB-INF/.env into internal map");
                // In ra để xác nhận token được load
                System.out.println("[EnvLoader] GHN_TOKEN present: "
                        + !ENV.getOrDefault("GHN_TOKEN", "").isEmpty());
                return;
            }
        } catch (Exception e) {
            System.err.println("[EnvLoader] Failed to read WEB-INF/.env: " + e.getMessage());
        }
        // Fallback: tìm file .env từ working directory
        load();
    }

    /** Fallback — tìm .env từ working directory leo lên */
    public static void load() {
        File envFile = findEnvFile();
        if (envFile == null) {
            System.out.println("[EnvLoader] .env file not found anywhere.");
            return;
        }
        try (BufferedReader reader = new BufferedReader(
                new FileReader(envFile, StandardCharsets.UTF_8))) {
            Map<String, String> vars = parse(reader);
            ENV.putAll(vars);
            System.out.println("[EnvLoader] Loaded " + vars.size()
                    + " variables from " + envFile.getAbsolutePath());
        } catch (Exception e) {
            System.err.println("[EnvLoader] Failed to load .env: " + e.getMessage());
        }
    }

    // -----------------------------------------------------------------------

    private static Map<String, String> parse(BufferedReader reader) throws Exception {
        Map<String, String> vars = new HashMap<>();
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty() || line.startsWith("#")) continue;
            int idx = line.indexOf('=');
            if (idx < 1) continue;
            String key   = line.substring(0, idx).trim();
            String value = line.substring(idx + 1).trim();
            vars.put(key, value);
        }
        return vars;
    }

    private static File findEnvFile() {
        File dir = new File(System.getProperty("user.dir"));
        for (int i = 0; i < 6; i++) {
            File candidate = new File(dir, ".env");
            if (candidate.exists()) return candidate;
            dir = dir.getParentFile();
            if (dir == null) break;
        }
        return null;
    }

    public static Map<String, String> getAll() {
        return Collections.unmodifiableMap(ENV);
    }
}
