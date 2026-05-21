package vn.edu.hcmuaf.fit.controller.cart;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.PromoCode;
import vn.edu.hcmuaf.fit.service.PromoCodeService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet(name = "ValidatePromoServlet", value = "/api/validate-promo")
public class ValidatePromoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String code = request.getParameter("code");
        String totalParam = request.getParameter("total");
        
        JsonObject json = new JsonObject();
        
        if (code == null || code.trim().isEmpty()) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi không được để trống.");
            response.getWriter().write(json.toString());
            return;
        }
        
        double orderTotal;
        try {
            orderTotal = Double.parseDouble(totalParam);
        } catch (NumberFormatException e) {
            json.addProperty("success", false);
            json.addProperty("message", "Tổng tiền đơn hàng không hợp lệ.");
            response.getWriter().write(json.toString());
            return;
        }
        
        PromoCode promo = PromoCodeService.getInstance().findByCode(code.trim().toUpperCase());
        
        if (promo == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi không tồn tại.");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (!promo.isActive()) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi đã bị vô hiệu hóa.");
            response.getWriter().write(json.toString());
            return;
        }
        
        Date now = new Date();
        if (promo.getStartAt() != null && now.before(promo.getStartAt())) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi chưa có hiệu lực.");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (promo.getEndAt() != null && now.after(promo.getEndAt())) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi đã hết hạn.");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (promo.getUsageLimit() > 0 && promo.getUsedCount() >= promo.getUsageLimit()) {
            json.addProperty("success", false);
            json.addProperty("message", "Mã khuyến mãi đã hết lượt sử dụng.");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (orderTotal < promo.getMinOrderValue()) {
            json.addProperty("success", false);
            json.addProperty("message", String.format("Đơn hàng tối thiểu %,.0f₫ để sử dụng mã này.", promo.getMinOrderValue()));
            response.getWriter().write(json.toString());
            return;
        }
        
        // Tính toán giảm giá
        double discount;
        if ("percent".equals(promo.getType())) {
            discount = orderTotal * (promo.getAmount() / 100.0);
        } else {
            discount = promo.getAmount();
        }
        
        // Giảm giá không vượt quá tổng tiền
        discount = Math.min(discount, orderTotal);
        
        json.addProperty("success", true);
        json.addProperty("discount", discount);
        
        String message;
        if ("percent".equals(promo.getType())) {
            message = String.format("Giảm %.0f%%", promo.getAmount());
        } else {
            message = String.format("Giảm %,.0f₫", promo.getAmount());
        }
        json.addProperty("message", message);
        
        response.getWriter().write(json.toString());
    }
}
