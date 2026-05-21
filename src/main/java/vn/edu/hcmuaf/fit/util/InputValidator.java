package vn.edu.hcmuaf.fit.util;

import java.net.MalformedURLException;
import java.net.URL;

public class InputValidator {

    public static boolean isNonEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }

    public static boolean isNonNegativeDouble(String s) {
        if (s == null) return false;
        try {
            double v = Double.parseDouble(s);
            return v >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isNonNegativeInt(String s) {
        if (s == null) return false;
        try {
            int v = Integer.parseInt(s);
            return v >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isEmail(String s) {
        if (s == null) return false;
        return s.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public static boolean isValidUrl(String s) {
        if (s == null || s.trim().isEmpty()) return false;
        try {
            new URL(s);
            return true;
        } catch (MalformedURLException e) {
            return false;
        }
    }
}
