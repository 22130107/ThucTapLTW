package vn.edu.hcmuaf.fit.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.CartItem;

import java.util.Base64;

public class CartCookieUtil {
    private static final String COOKIE_NAME = "cart_items";
    private static final int MAX_AGE = 30 * 24 * 60 * 60;

    public static void saveCartToCookie(HttpServletResponse response, Cart cart) {
        if (cart == null || cart.getData().isEmpty()) {
            clearCartCookie(response);
            return;
        }

        StringBuilder sb = new StringBuilder();
        for (CartItem item : cart.getData().values()) {
            if (sb.length() > 0) sb.append("|");
            sb.append(item.getProduct().getId()).append(":").append(item.getQuantity());
        }

        String value = Base64.getEncoder().encodeToString(sb.toString().getBytes());
        Cookie cookie = new Cookie(COOKIE_NAME, value);
        cookie.setMaxAge(MAX_AGE);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    public static Cart getCartFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (COOKIE_NAME.equals(cookie.getName())) {
                    try {
                        String value = new String(Base64.getDecoder().decode(cookie.getValue()));
                        Cart cart = new Cart();
                        String[] items = value.split("\\|");
                        for (String item : items) {
                            String[] parts = item.split(":");
                            if (parts.length == 2) {
                                int productId = Integer.parseInt(parts[0]);
                                int quantity = Integer.parseInt(parts[1]);
                                cart.add(productId, quantity);
                            }
                        }
                        return cart;
                    } catch (Exception e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    public static void clearCartCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
