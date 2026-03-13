package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.dao.AccountDAO;
import vn.edu.hcmuaf.fit.model.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            Account account = new Account();
            account.setId(id);
            account.setUsername(username);
            account.setEmail(email);
            account.setRole(role);
            account.setStatus(status);
            account.setPasswordHash(password);

            AccountDAO dao = new AccountDAO();
            dao.update(account);

            response.sendRedirect("accounts");
        } else {
            doGet(request, response);
        }
    }
}
