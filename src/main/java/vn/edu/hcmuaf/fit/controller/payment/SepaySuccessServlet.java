package vn.edu.hcmuaf.fit.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SepaySuccessServlet", value = "/payment/sepay/success")
public class SepaySuccessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isBlank()) {
            try {
                int orderId = Integer.parseInt(orderIdStr.trim());
                request.setAttribute("orderId", orderId);
                request.setAttribute("displayOrderId", String.valueOf(orderId));
            } catch (NumberFormatException ignored) {}
        }

        request.getRequestDispatcher("/Checkout/payment_success.jsp")
                .forward(request, response);
    }
}