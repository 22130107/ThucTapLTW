package vn.edu.hcmuaf.fit.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import vn.edu.hcmuaf.fit.model.User;

@WebFilter(urlPatterns = {"/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object auth = (session != null) ? session.getAttribute("auth") : null;

        if (auth instanceof User) {
            User user = (User) auth;
            String role = user.getRole();
            if (role != null && ("admin".equalsIgnoreCase(role) || "administrator".equalsIgnoreCase(role))) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Not authenticated or not admin — redirect to login
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    public void destroy() {
        // no-op
    }
}
