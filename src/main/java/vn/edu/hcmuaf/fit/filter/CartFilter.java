package vn.edu.hcmuaf.fit.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.util.CartCookieUtil;

import java.io.IOException;

@WebFilter(filterName = "CartFilter", urlPatterns = "/*")
public class CartFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        if (session.getAttribute("cart") == null) {
            Cart cart = CartCookieUtil.getCartFromCookie(req);
            if (cart != null) {
                session.setAttribute("cart", cart);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
