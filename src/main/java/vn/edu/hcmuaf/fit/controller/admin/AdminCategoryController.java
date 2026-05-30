package vn.edu.hcmuaf.fit.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryController", value = "/admin/categories")
public class AdminCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = CategoryService.getInstance().getAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/Admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("add".equals(action)) {
            Category c = buildFromRequest(request);
            boolean ok = CategoryService.getInstance().add(c);
            session.setAttribute(ok ? "successMsg" : "errorMsg",
                    ok ? "Thêm danh mục thành công." : "Không thể thêm danh mục. Tên có thể đã tồn tại.");

        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Category c = buildFromRequest(request);
                c.setCategoryID(id);
                boolean ok = CategoryService.getInstance().update(c);
                session.setAttribute(ok ? "successMsg" : "errorMsg",
                        ok ? "Cập nhật danh mục thành công." : "Không thể cập nhật danh mục.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "ID danh mục không hợp lệ.");
            }

        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = CategoryService.getInstance().delete(id);
                session.setAttribute(ok ? "successMsg" : "errorMsg",
                        ok ? "Đã xóa danh mục." : "Không thể xóa. Danh mục có thể đang được sử dụng.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "ID danh mục không hợp lệ.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private Category buildFromRequest(HttpServletRequest req) {
        Category c = new Category();
        c.setCategoryName(req.getParameter("name"));
        c.setDescription(req.getParameter("description"));
        c.setImage(req.getParameter("image"));
        try { c.setDisplayOrder(Integer.parseInt(req.getParameter("displayOrder"))); }
        catch (Exception e) { c.setDisplayOrder(0); }
        return c;
    }
}
