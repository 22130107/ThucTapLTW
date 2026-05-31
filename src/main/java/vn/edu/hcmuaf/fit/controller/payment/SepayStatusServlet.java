package vn.edu.hcmuaf.fit.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.service.SepayService;
import vn.edu.hcmuaf.fit.service.SepayService.PaymentStatus;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

@WebServlet(name = "SepayStatusServlet", value = "/payment/sepay/status")
public class SepayStatusServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SepayStatusServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            write(response, "{\"status\":\"BAD_REQUEST\",\"message\":\"missing orderId\"}");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            write(response, "{\"status\":\"BAD_REQUEST\",\"message\":\"invalid orderId\"}");
            return;
        }

        PaymentStatus status = SepayService.getInstance().checkPaymentStatus(orderId);
        LOGGER.info("[SepayStatus] orderId=" + orderId + " -> " + status);
        response.setStatus(HttpServletResponse.SC_OK);
        write(response, "{\"status\":\"" + status.name() + "\"}");
    }

    private void write(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.write(json);
        out.flush();
    }
}