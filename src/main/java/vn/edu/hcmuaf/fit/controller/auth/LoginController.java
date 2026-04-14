package vn.edu.hcmuaf.fit.controller.auth;

import vn.edu.hcmuaf.fit.model.Customer;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.CartItem;
import vn.edu.hcmuaf.fit.service.UserService;
import vn.edu.hcmuaf.fit.service.CartService;
import vn.edu.hcmuaf.fit.service.CustomerService;
import vn.edu.hcmuaf.fit.dao.UserDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Login/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = UserService.getInstance().checkLogin(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", user);

            Customer customer = CustomerService.getInstance().getCustomerByAccountId(user.getAccountID());
            session.setAttribute("customer", customer);

            Cart sessionCart = (Cart) session.getAttribute("cart");
            if (sessionCart != null && !sessionCart.getData().isEmpty()) {
                int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
                if (customerId != -1) {
                    for (CartItem item : sessionCart.getData().values()) {
                        CartService.getInstance().addToCart(customerId, item.getProduct().getId(), item.getQuantity());
                    }

                    Cart dbCart = CartService.getInstance().getCart(customerId);
                    session.setAttribute("cart", dbCart);

                    vn.edu.hcmuaf.fit.util.CartCookieUtil.clearCartCookie(response);
                }
            }

            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("Login/login.jsp").forward(request, response);
        }
    }
}
