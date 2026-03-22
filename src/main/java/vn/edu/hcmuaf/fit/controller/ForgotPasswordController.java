package vn.edu.hcmuaf.fit.controller;

import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.util.EmailUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordController", value = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("Login/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();

        if (!userDAO.checkEmailExist(email)) {
            request.setAttribute("error", "error1");
            request.getRequestDispatcher("Login/forgot_password.jsp").forward(request, response);
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(999999));

        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email_forgot", email);
        session.setMaxInactiveInterval(300);

        String subject = "error2";
        String body = "error3";

        new Thread(() -> EmailUtils.sendEmail(email, subject, body)).start();

        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }
}