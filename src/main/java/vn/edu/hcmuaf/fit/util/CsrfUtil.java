package vn.edu.hcmuaf.fit.util;

import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfUtil {
    public static final String CSRF_SESSION_ATTR = "csrfToken";

    public static String getToken(HttpSession session) {
        if (session == null) return null;
        Object t = session.getAttribute(CSRF_SESSION_ATTR);
        if (t instanceof String) return (String) t;
        String token = generateToken();
        session.setAttribute(CSRF_SESSION_ATTR, token);
        return token;
    }

    private static String generateToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
