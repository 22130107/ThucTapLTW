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

@WebServlet(name = "LoginGoogleController", value = "/login-google")
public class LoginGoogleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            RequestDispatcher dis = request.getRequestDispatcher("Login/login.jsp");
            dis.forward(request, response);
            return;
        }

        try {

            String accessToken = GoogleUtils.getToken(code);
            System.out.println("Token: " + accessToken);

            GooglePojo googlePojo = GoogleUtils.getUserInfo(accessToken);
            System.out.println("Email Google: " + googlePojo.getEmail());

            UserDAO userDAO = new UserDAO();

            if (!userDAO.checkEmailExist(googlePojo.getEmail())) {

                userDAO.registerGoogle(googlePojo.getEmail(), googlePojo.getName(), googlePojo.getPicture());
            }

            User user = userDAO.getUserByEmail(googlePojo.getEmail());

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("auth", user);

                Customer customer = CustomerService.getInstance().getCustomerByAccountId(user.getAccountID());
                session.setAttribute("customer", customer);

                Cart sessionCart = (Cart) session.getAttribute("cart");
                if (sessionCart != null && !sessionCart.getData().isEmpty()) {
                    int customerId = userDAO.getCustomerIdByAccountId(user.getAccountID());
                    if (customerId != -1) {
                        for (CartItem item : sessionCart.getData().values()) {
                            CartService.getInstance().addToCart(customerId, item.getProduct().getId(), item.getQuantity());
                        }
                        Cart dbCart = CartService.getInstance().getCart(customerId);
                        session.setAttribute("cart", dbCart);
                    }
                }

                response.sendRedirect("home");
            } else {
                response.sendRedirect("Login/login.jsp?error=GoogleLoginFailed");
            }

        } catch (Exception e) {
            System.out.println("Lá»–I á»ž Ä�Ã‚Y:");
            e.printStackTrace();
            response.sendRedirect("Login/login.jsp?error=SystemError");
        }
    }
}