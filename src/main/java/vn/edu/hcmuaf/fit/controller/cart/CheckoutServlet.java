package vn.edu.hcmuaf.fit.controller.cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.service.CartService;
import vn.edu.hcmuaf.fit.service.OrderService;

import java.io.IOException;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int customerId = new vn.edu.hcmuaf.fit.dao.UserDAO().getCustomerIdByAccountId(user.getAccountID());
        if (customerId == -1) {
            response.sendRedirect("login");
            return;
        }

        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/Checkout/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String recipientName = request.getParameter("recipientName");
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        int customerId = new vn.edu.hcmuaf.fit.dao.UserDAO().getCustomerIdByAccountId(user.getAccountID());

        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        boolean success = OrderService.getInstance().placeOrder(customerId, recipientName, shippingAddress,
                paymentMethod);

        if (success) {

            session.removeAttribute("cart");
            response.sendRedirect("Checkout/order_success.jsp");
        } else {
            request.setAttribute("error", "Ä�áº·t hÃ ng tháº¥t báº¡i. Vui lÃ²ng thá»­ láº¡i.");
            doGet(request, response);
        }
    }
}
