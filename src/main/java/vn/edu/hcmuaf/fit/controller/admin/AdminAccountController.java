package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.dao.AccountDAO;
import vn.edu.hcmuaf.fit.model.Account;
import vn.edu.hcmuaf.fit.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAccountController", value = "/admin/accounts")
public class AdminAccountController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        AccountDAO dao = new AccountDAO();
        List<Account> list;

        if ((q != null && !q.isEmpty()) || (role != null && !role.isEmpty()) || (status != null && !status.isEmpty())) {
            list = dao.filter(q, role, status);
        } else {
            list = dao.getAll();
        }

        request.setAttribute("listA", list);
        request.setAttribute("msgName", q);
        request.setAttribute("msgRole", role);
        request.setAttribute("msgStatus", status);

        request.getRequestDispatcher("/Admin/accounts.jsp").forward(request, response);
    }

    private String validateAccountInput(String username, String email, String role, String status) {
        if (!InputValidator.isNonEmpty(username) || username.trim().length() < 3) {
            return "Username is required and must be at least 3 characters.";
        }
        if (!InputValidator.isEmail(email)) {
            return "Email is invalid.";
        }
        if (!"Admin".equals(role) && !"Customer".equals(role)) {
            return "Role must be Admin or Customer.";
        }
        if (!"Active".equals(status) && !"Locked".equals(status) && !"Inactive".equals(status)) {
            return "Status must be Active, Locked, or Inactive.";
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("update".equals(action)) {
            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Invalid account ID.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            String error = validateAccountInput(username, email, role, status);
            if (error != null) {
                session.setAttribute("errorMsg", error);
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            Account account = new Account();
            account.setId(id);
            account.setUsername(username);
            account.setEmail(email);
            account.setRole(role);
            account.setStatus(status);
            account.setPasswordHash(password);

            AccountDAO dao = new AccountDAO();
            dao.update(account);

            session.setAttribute("successMsg", "Account updated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        } else {
            doGet(request, response);
        }
    }
}
