package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.model.PromoCode;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.PromoCodeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AdminPromoController", value = "/admin/promocodes")
public class AdminPromoController extends HttpServlet {
    private static final SimpleDateFormat DF = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int size = 15;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        try { size = Integer.parseInt(request.getParameter("size")); } catch (Exception ignored) {}

        int total = PromoCodeService.getInstance().countAll();
        int offset = (page - 1) * size;
        List<PromoCode> list = PromoCodeService.getInstance().list(offset, size);

        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalItems", total);
        request.setAttribute("categories", CategoryService.getInstance().getAll());
        request.getRequestDispatcher("/Admin/promocodes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("add".equals(action)) {
            PromoCode p = readPromoFromRequest(request);
            boolean ok = PromoCodeService.getInstance().addPromo(p);
            if (ok) session.setAttribute("successMsg", "Tạo mã khuyến mãi thành công."); else session.setAttribute("errorMsg", "Không thể tạo mã.");
            response.sendRedirect(request.getContextPath() + "/admin/promocodes");
            return;
        }

        if ("update".equals(action)) {
            String sid = request.getParameter("id");
            try {
                int id = Integer.parseInt(sid);
                PromoCode p = readPromoFromRequest(request);
                p.setId(id);
                boolean ok = PromoCodeService.getInstance().updatePromo(p);
                if (ok) session.setAttribute("successMsg", "Cập nhật thành công."); else session.setAttribute("errorMsg", "Không thể cập nhật.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "ID không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/promocodes");
            return;
        }

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = PromoCodeService.getInstance().deletePromo(id);
                if (ok) session.setAttribute("successMsg", "Đã xóa."); else session.setAttribute("errorMsg", "Không thể xóa.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "ID không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/promocodes");
            return;
        }

        doGet(request, response);
    }

    private PromoCode readPromoFromRequest(HttpServletRequest request) {
        PromoCode p = new PromoCode();
        p.setCode(request.getParameter("code"));
        p.setType(request.getParameter("type"));
        try { p.setAmount(Double.parseDouble(request.getParameter("amount"))); } catch (Exception e) { p.setAmount(0); }
        try { p.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue"))); } catch (Exception e) { p.setMinOrderValue(0); }
        p.setAppliesTo(request.getParameter("appliesTo"));
        String aids = request.getParameter("appliesToId");
        if (aids != null && !aids.isEmpty()) {
            try { p.setAppliesToId(Integer.parseInt(aids)); } catch (Exception ignored) {}
        }
        p.setUsageLimit(parseInt(request.getParameter("usageLimit"), 0));
        p.setUsedCount(parseInt(request.getParameter("usedCount"), 0));
        p.setActive("on".equals(request.getParameter("active")) || "1".equals(request.getParameter("active")));
        try { String s = request.getParameter("startAt"); if (s != null && !s.isEmpty()) p.setStartAt(parseDate(s)); } catch (Exception ignored) {}
        try { String s = request.getParameter("endAt"); if (s != null && !s.isEmpty()) p.setEndAt(parseDate(s)); } catch (Exception ignored) {}
        return p;
    }

    private Date parseDate(String s) throws ParseException { return DF.parse(s); }
    private int parseInt(String s, int def) { try { return Integer.parseInt(s); } catch (Exception e) { return def; } }
}
