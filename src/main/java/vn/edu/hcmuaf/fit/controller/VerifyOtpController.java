package vn.edu.hcmuaf.fit.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "VerifyOtpController", value = "/verify-otp")
public class VerifyOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("Login/verify_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userOtp = request.getParameter("otp");
        HttpSession session = request.getSession();

        String systemOtp = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("email_forgot");

        if (systemOtp == null || email == null) {
            request.setAttribute("error", "error7");
            request.getRequestDispatcher("Login/forgot_password.jsp").forward(request, response);
            return;
        }

        if (userOtp != null && userOtp.equals(systemOtp)) {
            session.setAttribute("otp_verified", true);

            response.sendRedirect(request.getContextPath() + "/new-password");

        } else {
            request.setAttribute("error", "error8");
            request.getRequestDispatcher("Login/verify_otp.jsp").forward(request, response);
        }
    }
}