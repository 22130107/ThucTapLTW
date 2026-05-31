package vn.edu.hcmuaf.fit.filter;

import vn.edu.hcmuaf.fit.util.CsrfUtil;
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

@WebFilter(urlPatterns = {"/admin/*"})
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(true);
        String method = req.getMethod();

        // Ensure token exists and expose to views
        String token = CsrfUtil.getToken(session);
        req.setAttribute("csrfToken", token);

        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
            String param = req.getParameter("csrf_token");
            String header = req.getHeader("X-CSRF-Token");
            if ((param != null && param.equals(token)) || (header != null && header.equals(token))) {
                chain.doFilter(request, response);
            } else {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // no-op
    }
}
