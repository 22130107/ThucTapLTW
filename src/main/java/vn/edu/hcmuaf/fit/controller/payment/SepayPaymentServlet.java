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

        String recipientName = request.getParameter("recipientName");
        String recipientPhone = request.getParameter("recipientPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String toDistrictIdStr = request.getParameter("toDistrictId");
        String toWardCode = request.getParameter("toWardCode");

        if (isBlank(recipientName) || isBlank(recipientPhone)
                || isBlank(shippingAddress) || isBlank(toDistrictIdStr) || isBlank(toWardCode)) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin giao hàng.");
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/Checkout/checkout.jsp").forward(request, response);
            return;
        }

        int toDistrictId;
        try {
            toDistrictId = Integer.parseInt(toDistrictIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Quận/Huyện không hợp lệ.");
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/Checkout/checkout.jsp").forward(request, response);
            return;
        }

        int orderId = OrderService.getInstance().placeOrderAndReturnId(
                customerId, recipientName, recipientPhone,
                shippingAddress, toDistrictId, toWardCode, "SEPAY");

        if (orderId == -1) {
            LOGGER.warning("[SepayPaymentServlet] placeOrderAndReturnId returned -1 for customerId=" + customerId);
            request.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/Checkout/checkout.jsp").forward(request, response);
            return;
        }

        CartService.getInstance().clearCart(customerId);
        session.removeAttribute("cart");

        LOGGER.info("[SepayPaymentServlet] Order created orderId=" + orderId + " – redirecting to QR page");

        try {
            vn.edu.hcmuaf.fit.util.SepayConfig.validate();
            response.sendRedirect(request.getContextPath() + "/payment/sepay/qr?orderId=" + orderId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SepayPaymentServlet] SePay config error", e);
            request.setAttribute("error", "Không thể tạo QR thanh toán. Vui lòng thử lại sau.");
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/Checkout/checkout.jsp").forward(request, response);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}