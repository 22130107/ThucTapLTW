package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderController", value = "/admin/orders")
public class AdminOrderController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String priceMin = request.getParameter("priceMin");
        String priceMax = request.getParameter("priceMax");

        OrderDAO dao = OrderDAO.getInstance();
        List<Order> list;

        if ((q != null && !q.isEmpty()) ||
                (status != null && !status.isEmpty()) ||
                (dateFrom != null && !dateFrom.isEmpty()) ||
                (dateTo != null && !dateTo.isEmpty()) ||
                (priceMin != null && !priceMin.isEmpty()) ||
                (priceMax != null && !priceMax.isEmpty())) {
            list = dao.filter(q, status, dateFrom, dateTo, priceMin, priceMax);
        } else {
            list = dao.getAll();
        }

        request.setAttribute("listO", list);
        request.setAttribute("msgName", q);
        request.setAttribute("msgStatus", status);
        request.setAttribute("msgDateFrom", dateFrom);
        request.setAttribute("msgDateTo", dateTo);
        request.setAttribute("msgPriceMin", priceMin);
        request.setAttribute("msgPriceMax", priceMax);

        request.getRequestDispatcher("/Admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            OrderDAO.getInstance().updateStatus(id, status);
            response.sendRedirect("orders");
        } else {
            doGet(request, response);
        }
    }
}
