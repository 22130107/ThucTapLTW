package vn.edu.hcmuaf.fit.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.service.SepayService;
import vn.edu.hcmuaf.fit.service.SepayService.WebhookResult;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

@WebServlet(name = "SepayWebhookServlet", value = "/payment/sepay/webhook")
public class SepayWebhookServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SepayWebhookServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);

        String rawBody = readBody(request);
        LOGGER.info("[SepayWebhook] Received body: " + rawBody);

        PrintWriter out = response.getWriter();

        if (rawBody.isEmpty()) {
            LOGGER.warning("[SepayWebhook] Empty body received");
            out.write("{\"success\":false,\"message\":\"empty body\"}");
            out.flush();
            return;
        }
        WebhookResult result = SepayService.getInstance().handleWebhook(rawBody);

        if (result.isSuccess()) {
            LOGGER.info("[SepayWebhook] SUCCESS orderId=" + result.getOrderId()
                    + " amount=" + result.getAmount());
            out.write("{\"success\":true,\"orderId\":" + result.getOrderId() + "}");

        } else if (result.isFailure()) {
            String msg = result.getMessage() != null ? result.getMessage() : "error";
            LOGGER.warning("[SepayWebhook] FAILURE (HTTP 200): " + msg);
            out.write("{\"success\":false,\"message\":\"" + escapeJson(msg) + "\"}");

        } else {
            LOGGER.info("[SepayWebhook] IGNORED: " + result.getMessage());
            out.write("{\"success\":true,\"message\":\"ignored\"}");
        }
        out.flush();
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line).append('\n');
        }
        return sb.toString().trim();
    }

    private String escapeJson(String s) {
        return s == null ? "" : s.replace("\"", "\\\"").replace("\n", "\\n");
    }
}