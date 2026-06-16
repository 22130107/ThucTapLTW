package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.InventoryTransaction;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.InventoryService;
import vn.edu.hcmuaf.fit.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminInventoryController", value = "/admin/inventory")
public class AdminInventoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/Login/login.jsp");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null) tab = "dashboard";

        InventoryService is = InventoryService.getInstance();
        vn.edu.hcmuaf.fit.service.CategoryService cs = vn.edu.hcmuaf.fit.service.CategoryService.getInstance();

        List<Product> allProducts = ProductService.getInstance()
                .getAdminProducts(null, null, null, null, 0, 99999);
        List<vn.edu.hcmuaf.fit.model.Category> categories = cs.getAll();

        int totalVariants = allProducts.size();
        int totalStock = 0;
        int outOfStock = 0;
        int lowStock = 0;
        double inventoryValue = 0;

        for (Product p : allProducts) {
            totalStock += p.getStock();
            inventoryValue += (p.getStock() * p.getPrice());
            if (p.getStock() == 0) {
                outOfStock++;
            } else if (p.getStock() <= 5) {
                lowStock++;
            }
        }

        request.setAttribute("products", allProducts);
        request.setAttribute("categories", categories);
        request.setAttribute("transactions", is.getAllTransactions());
        request.setAttribute("currentTab", tab);
        
        request.setAttribute("statTotalVariants", totalVariants);
        request.setAttribute("statTotalStock", totalStock);
        request.setAttribute("statOutOfStock", outOfStock);
        request.setAttribute("statLowStock", lowStock);
        request.setAttribute("statInventoryValue", inventoryValue);

        if ("detail".equals(tab)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    InventoryTransaction t = is.getTransactionById(id);
                    request.setAttribute("transaction", t);
                } catch (NumberFormatException e) {}
            }
        }

        request.getRequestDispatcher("/Admin/inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/Login/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("import".equals(action)) {
            handleImport(request, session);
        } else if ("export".equals(action)) {
            handleExport(request, session);
        } else if ("adjust".equals(action)) {
            handleAdjust(request, session);
        }

        response.sendRedirect("inventory?tab=list");
    }

    private void handleImport(HttpServletRequest request, HttpSession session) {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String note = request.getParameter("note");
        int createdBy = getUserId(session);

        if (productIds == null || quantities == null || productIds.length != quantities.length) {
            session.setAttribute("errorMsg", "Dữ liệu nhập kho không hợp lệ.");
            return;
        }

        List<InventoryService.ImportItem> items = new ArrayList<>();
        for (int i = 0; i < productIds.length; i++) {
            try {
                int pid = Integer.parseInt(productIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                if (qty <= 0) continue;
                items.add(new InventoryService.ImportItem(pid, qty, null));
            } catch (NumberFormatException e) {}
        }

        if (items.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập ít nhất một sản phẩm.");
            return;
        }

        boolean success = InventoryService.getInstance().importStock(items, note, createdBy);
        session.setAttribute(success ? "successMsg" : "errorMsg",
                success ? "Nhập kho thành công!" : "Nhập kho thất bại.");
    }

    private void handleExport(HttpServletRequest request, HttpSession session) {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String note = request.getParameter("note");
        int createdBy = getUserId(session);

        if (productIds == null || quantities == null || productIds.length != quantities.length) {
            session.setAttribute("errorMsg", "Dữ liệu xuất kho không hợp lệ.");
            return;
        }

        List<InventoryService.ExportItem> items = new ArrayList<>();
        for (int i = 0; i < productIds.length; i++) {
            try {
                int pid = Integer.parseInt(productIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                if (qty <= 0) continue;
                items.add(new InventoryService.ExportItem(pid, qty, null));
            } catch (NumberFormatException e) {}
        }

        if (items.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập ít nhất một sản phẩm.");
            return;
        }

        boolean success = InventoryService.getInstance().exportStock(items, note, createdBy);
        session.setAttribute(success ? "successMsg" : "errorMsg",
                success ? "Xuất kho thành công!" : "Xuất kho thất bại (kiểm tra tồn kho).");
    }

    private void handleAdjust(HttpServletRequest request, HttpSession session) {
        String[] productIds = request.getParameterValues("productId");
        String[] newStocks = request.getParameterValues("newStock");
        String note = request.getParameter("note");
        int createdBy = getUserId(session);

        if (productIds == null || newStocks == null || productIds.length != newStocks.length) {
            session.setAttribute("errorMsg", "Dữ liệu kiểm kê không hợp lệ.");
            return;
        }

        List<InventoryService.AdjustItem> items = new ArrayList<>();
        for (int i = 0; i < productIds.length; i++) {
            try {
                int pid = Integer.parseInt(productIds[i]);
                int qty = Integer.parseInt(newStocks[i]);
                if (qty < 0) continue;
                items.add(new InventoryService.AdjustItem(pid, qty, null));
            } catch (NumberFormatException e) {}
        }

        if (items.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập ít nhất một sản phẩm.");
            return;
        }

        boolean success = InventoryService.getInstance().adjustStock(items, note, createdBy);
        session.setAttribute(success ? "successMsg" : "errorMsg",
                success ? "Kiểm kê thành công!" : "Kiểm kê thất bại.");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User auth = (User) session.getAttribute("auth");
        return auth != null;
    }

    private int getUserId(HttpSession session) {
        User auth = (User) session.getAttribute("auth");
        return auth != null ? auth.getAccountID() : 0;
    }
}
