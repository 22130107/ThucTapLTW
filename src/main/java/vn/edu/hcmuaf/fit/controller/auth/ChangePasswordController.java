package vn.edu.hcmuaf.fit.controller.auth;

import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.UserService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "ChangePasswordController", value = "/change-password")
public class ChangePasswordController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("/Customer/Profile/profile.jsp").forward(request, response);
            return;
        }

        boolean isChanged = UserService.getInstance().changePassword(user.getAccountID(), oldPass, newPass);

        if (isChanged) {
            request.setAttribute("message", "Đổi mật khẩu thành công");
        } else {
            request.setAttribute("error", "Đổi mật khẩu thất bại");
        }

        request.getRequestDispatcher("/Customer/Profile/profile.jsp").forward(request, response);
    }
}