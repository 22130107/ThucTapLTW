package vn.edu.hcmuaf.fit.controller.custome;

import vn.edu.hcmuaf.fit.model.Customer;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.CustomerService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "CustomerController", value = "/update-profile")
public class CustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/Customer/Profile/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {

            request.setAttribute("error", "Vui lÃ²ng Ä‘iá»�n Ä‘áº§y Ä‘á»§ thÃ´ng tin!");
            request.getRequestDispatcher("/Customer/Profile/profile.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("\\d{10,11}")) {
            request.setAttribute("error", "Sá»‘ Ä‘iá»‡n thoáº¡i khÃ´ng há»£p lá»‡ (pháº£i lÃ  10-11 sá»‘)!");
            request.getRequestDispatcher("/Customer/Profile/profile.jsp").forward(request, response);
            return;
        }

        boolean isUpdated = CustomerService.getInstance().updateCustomerInfo(
                user.getAccountID(),
                fullName,
                phone,
                address
        );

        if (isUpdated) {

            Customer newInfo = CustomerService.getInstance().getCustomerByAccountId(user.getAccountID());
            session.setAttribute("customer", newInfo);

            request.setAttribute("message", "Cáº­p nháº­t thÃ´ng tin thÃ nh cÃ´ng!");
        } else {
            request.setAttribute("error", "Cáº­p nháº­t tháº¥t báº¡i. Vui lÃ²ng thá»­ láº¡i!");
        }

        request.getRequestDispatcher("Customer/Profile/profile.jsp").forward(request, response);
    }
}