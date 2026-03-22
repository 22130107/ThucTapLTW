package vn.edu.hcmuaf.fit.controller.auth;

import vn.edu.hcmuaf.fit.service.UserService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Login/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("repassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("Login/register.jsp").forward(request, response);
            return;
        }

        if (UserService.getInstance().checkUserExist(username)) {
            request.setAttribute("error", "Tài khoản đã tồn tại.");
            request.getRequestDispatcher("Login/register.jsp").forward(request, response);
            return;
        }

        if (UserService.getInstance().checkEmailExist(email)) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("Login/register.jsp").forward(request, response);
            return;
        }

        UserService.getInstance().register(username, password, email);
        response.sendRedirect("login");
    }
}
