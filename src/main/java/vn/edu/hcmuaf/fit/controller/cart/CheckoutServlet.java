package vn.edu.hcmuaf.fit.controller.cart;

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

        int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
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

        String recipientName     = request.getParameter("recipientName");
        String recipientPhone    = request.getParameter("recipientPhone");
        String shippingAddress   = request.getParameter("shippingAddress");
        String toDistrictIdParam = request.getParameter("toDistrictId");
        String toWardCode        = request.getParameter("toWardCode");
        String paymentMethod     = request.getParameter("paymentMethod");

        System.out.println("[Checkout] recipientName="   + recipientName);
        System.out.println("[Checkout] recipientPhone="  + recipientPhone);
        System.out.println("[Checkout] shippingAddress=" + shippingAddress);
        System.out.println("[Checkout] toDistrictId="    + toDistrictIdParam);
        System.out.println("[Checkout] toWardCode="      + toWardCode);
        System.out.println("[Checkout] paymentMethod="   + paymentMethod);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
        System.out.println("[Checkout] customerId=" + customerId);

        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            System.out.println("[Checkout] Cart is null or empty, redirecting.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int toDistrictId;
        try {
            toDistrictId = Integer.parseInt(toDistrictIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Quận/Huyện không hợp lệ. Vui lòng kiểm tra lại.");
            doGet(request, response);
            return;
        }

        boolean success = OrderService.getInstance().placeOrder(
                customerId, recipientName, recipientPhone,
                shippingAddress, toDistrictId, toWardCode, paymentMethod);

        System.out.println("[Checkout] placeOrder result=" + success);

        if (success) {
            session.removeAttribute("cart");
            response.sendRedirect("Checkout/order_success.jsp");
        } else {
            request.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
