package vn.edu.hcmuaf.fit.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.SepayService;
import vn.edu.hcmuaf.fit.service.SepayService.QrPaymentData;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "SepayQrServlet", value = "/payment/sepay/qr")
public class SepayQrServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SepayQrServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("auth") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        try {
            QrPaymentData qrData = SepayService.getInstance().createQrPayment(orderId);

            request.setAttribute("qrData", qrData);
            request.setAttribute("orderId", orderId);
            request.setAttribute("qrImageUrl", qrData.getQrImageUrl());
            request.setAttribute("amount", qrData.getAmount());
            request.setAttribute("content", qrData.getTransferContent());
            request.setAttribute("bankCode", qrData.getBankCode());
            request.setAttribute("bankAccount", qrData.getBankAccount());
            request.setAttribute("accountName", qrData.getAccountName());
            request.setAttribute("expiryMins", qrData.getExpiryMinutes()); // NOTE: "expiryMins" not "expiryMinutes"

            LOGGER.info("[SepayQrServlet] Showing QR orderId=" + orderId
                    + " amount=" + qrData.getAmount());

            request.getRequestDispatcher("/Checkout/sepay_qr.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.severe("[SepayQrServlet] Failed for orderId=" + orderId + ": " + e.getMessage());
            request.setAttribute("errorMessage", "Không thể tạo mã QR. Vui lòng liên hệ hỗ trợ.");
            request.getRequestDispatcher("/Checkout/payment_fail.jsp")
                    .forward(request, response);
        }
    }
}