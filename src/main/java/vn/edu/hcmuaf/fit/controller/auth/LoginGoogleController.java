package vn.edu.hcmuaf.fit.controller.auth;

import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.CartItem;
import vn.edu.hcmuaf.fit.model.Customer;
import vn.edu.hcmuaf.fit.model.GooglePojo;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.CartService;
import vn.edu.hcmuaf.fit.service.CustomerService;
import vn.edu.hcmuaf.fit.util.GoogleUtils;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "LoginGoogleController", value = "/login-google")
public class LoginGoogleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu Google trả về lỗi (ví dụ user từ chối cấp quyền)
        String error = request.getParameter("error");
        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/login?error="
                    + URLEncoder.encode("Bạn đã từ chối đăng nhập bằng Google.", StandardCharsets.UTF_8));
            return;
        }

        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Đổi code lấy access token
            String accessToken = GoogleUtils.getToken(code);

            // 2. Lấy thông tin user từ Google
            GooglePojo googlePojo = GoogleUtils.getUserInfo(accessToken);
            String email = googlePojo.getEmail();

            if (email == null || email.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/login?error="
                        + URLEncoder.encode("Không lấy được email từ Google.", StandardCharsets.UTF_8));
                return;
            }

            // 3. Tự động đăng ký nếu email chưa tồn tại
            UserDAO userDAO = new UserDAO();
            if (!userDAO.checkEmailExist(email)) {
                userDAO.registerGoogle(email, googlePojo.getName(), googlePojo.getPicture());
            }

            // 4. Lấy user và tạo session
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login?error="
                        + URLEncoder.encode("Đăng nhập Google thất bại, vui lòng thử lại.", StandardCharsets.UTF_8));
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("auth", user);

            Customer customer = CustomerService.getInstance().getCustomerByAccountId(user.getAccountID());
            session.setAttribute("customer", customer);

            // 5. Merge giỏ hàng từ cookie/session vào DB
            Cart sessionCart = (Cart) session.getAttribute("cart");
            if (sessionCart != null && !sessionCart.getData().isEmpty()) {
                int customerId = userDAO.getCustomerIdByAccountId(user.getAccountID());
                if (customerId != -1) {
                    for (CartItem item : sessionCart.getData().values()) {
                        CartService.getInstance().addToCart(customerId,
                                item.getProduct().getId(), item.getQuantity());
                    }
                    Cart dbCart = CartService.getInstance().getCart(customerId);
                    session.setAttribute("cart", dbCart);
                    vn.edu.hcmuaf.fit.util.CartCookieUtil.clearCartCookie(response);
                }
            }

            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            System.err.println("[LoginGoogle] Lỗi đăng nhập Google: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error="
                    + URLEncoder.encode("Lỗi hệ thống, vui lòng thử lại.", StandardCharsets.UTF_8));
        }
    }
}
