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
            request.setAttribute("error", "Email không tồn tại trong hệ thống. Vui lòng kiểm tra lại.");
            request.getRequestDispatcher("Login/forgot_password.jsp").forward(request, response);
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(999999));

        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email_forgot", email);
        session.setMaxInactiveInterval(300);

        String subject = "Mã xác nhận đặt lại mật khẩu - HKH.vn";
        String body = "Xin chào,\n\n"
                + "Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại HKH.vn.\n\n"
                + "Mã OTP của bạn là: " + otp + "\n\n"
                + "Mã có hiệu lực trong vòng 5 phút. Vui lòng không chia sẻ mã này với bất kỳ ai.\n\n"
                + "Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này.\n\n"
                + "Trân trọng,\nĐội ngũ HKH.vn";

        new Thread(() -> EmailUtils.sendEmail(email, subject, body)).start();

        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }
}