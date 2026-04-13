package vn.edu.hcmuaf.fit.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.CartService;
import vn.edu.hcmuaf.fit.service.OrderService;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SepayPaymentServlet", value = "/payment/sepay")
public class SepayPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SepayPaymentServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
        if (customerId == -1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }