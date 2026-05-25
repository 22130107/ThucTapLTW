package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.dao.AccountDAO;
import vn.edu.hcmuaf.fit.dao.DashboardDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.service.InventoryService;
import vn.edu.hcmuaf.fit.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardController", value = "/admin/overview")
public class AdminDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalProducts = ProductService.getInstance().countTotalProducts();
        int totalOrders = OrderDAO.getInstance().countTotalOrders();
        int totalAccounts = new AccountDAO().countTotalAccounts();

        // Get aggregated stats for charts
        List<String[]> revenueData = DashboardDAO.getInstance().getMonthlyRevenueLast6Months();
        List<String[]> categoryData = DashboardDAO.getInstance().getProductsCountByCategory();

        int lowStockCount = InventoryService.getInstance().countLowStockProducts();

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalAccounts", totalAccounts);
        request.setAttribute("lowStockCount", lowStockCount);

        request.setAttribute("revenueData", revenueData);
        request.setAttribute("categoryData", categoryData);

        request.getRequestDispatcher("/Admin/overview.jsp").forward(request, response);
    }
}
