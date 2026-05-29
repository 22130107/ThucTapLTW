package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.model.ContactRequest;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.ContactService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ContactServlet", value = "/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCategories(request);
        request.getRequestDispatcher("/Contact/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullname = trim(request.getParameter("fullname"));
        String phone    = trim(request.getParameter("phone"));
        String email    = trim(request.getParameter("email"));
        String subject  = trim(request.getParameter("subject"));
        String message  = trim(request.getParameter("message"));

        // Validate bắt buộc
        if (fullname.isEmpty() || phone.isEmpty() || message.isEmpty()) {
            request.setAttribute("errorMsg",
                "Vui lòng điền đầy đủ các trường bắt buộc: Họ tên, Số điện thoại, Nội dung.");
            loadCategories(request);
            request.getRequestDispatcher("/Contact/contact.jsp").forward(request, response);
            return;
        }

        // Lưu DB + gửi email thông báo
        ContactRequest req = new ContactRequest(fullname, phone, email, subject, message);
        boolean ok = ContactService.getInstance().handle(req);

        if (ok) {
            request.setAttribute("successMsg",
                "Cảm ơn " + fullname + "! Chúng tôi sẽ liên hệ lại trong vòng 30 phút.");
        } else {
            request.setAttribute("errorMsg",
                "Có lỗi xảy ra khi gửi yêu cầu. Vui lòng gọi trực tiếp 0888.999.406.");
        }

        loadCategories(request);
        request.getRequestDispatcher("/Contact/contact.jsp").forward(request, response);
    }

    private void loadCategories(HttpServletRequest request) {
        List<Category> categories = CategoryService.getInstance().getAll();
        request.setAttribute("categories", categories);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
