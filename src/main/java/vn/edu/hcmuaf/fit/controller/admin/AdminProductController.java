package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.ProductService;
import vn.edu.hcmuaf.fit.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;

@WebServlet(name = "AdminProductController", value = "/admin/products")
public class AdminProductController extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/Login/login.jsp");
            return;
        }

        String q = request.getParameter("q");
        String brand = request.getParameter("brand");
        String status = request.getParameter("status");
        String price = request.getParameter("price");

        int page = parseIntParameter(request.getParameter("page"), 1);
        int pageSize = parseIntParameter(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        if (pageSize <= 0) pageSize = DEFAULT_PAGE_SIZE;

        ProductService ps = ProductService.getInstance();
        int totalItems = ps.countProductsAdmin(q, brand, status, price);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) page = totalPages;
        int offset = (page - 1) * pageSize;

        List<Product> list = ps.getAdminProducts(q, brand, status, price, offset, pageSize);

        for (Product p : list) {
            p.setCategoryId(ps.getProductCategoryId(p.getId()));
        }

        request.setAttribute("brands", ps.getAllBrands());
        request.setAttribute("categories", CategoryService.getInstance().getAll());
        request.setAttribute("listP", list);
        request.setAttribute("msgName", q);
        request.setAttribute("msgBrand", brand);
        request.setAttribute("msgStatus", status);
        request.setAttribute("msgPrice", price);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("queryString", buildBaseQueryString(q, brand, status, price));

        request.getRequestDispatcher("/Admin/products.jsp").forward(request, response);
    }

    private String validateProductInput(HttpServletRequest request) {
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String stock = request.getParameter("stock");
        String img = request.getParameter("img");

        if (!InputValidator.isNonEmpty(name)) {
            return "Tên sản phẩm không được để trống.";
        }
        if (!InputValidator.isNonNegativeDouble(price)) {
            return "Giá phải là số >= 0.";
        }
        if (!InputValidator.isNonNegativeInt(stock)) {
            return "Tồn kho phải là số nguyên >= 0.";
        }
        if (InputValidator.isNonEmpty(img) && !InputValidator.isValidUrl(img)) {
            return "URL hình ảnh không hợp lệ.";
        }
        return null;
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
        String queryString = request.getQueryString();
        String redirectUrl = request.getContextPath() + "/admin/products" + (queryString != null && !queryString.isEmpty() ? "?" + queryString : "");

        if ("bulkDelete".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            if (ids == null || ids.length == 0) {
                session.setAttribute("errorMsg", "Vui lòng chọn ít nhất một sản phẩm.");
                response.sendRedirect(redirectUrl);
                return;
            }
            List<Integer> productIds = new ArrayList<>();
            for (String value : ids) {
                try { productIds.add(Integer.parseInt(value)); } catch (NumberFormatException ignored) {}
            }
            boolean deleted = ProductService.getInstance().bulkDeleteProducts(productIds);
            session.setAttribute(deleted ? "successMsg" : "errorMsg",
                    deleted ? "Đã xóa sản phẩm được chọn." : "Không thể xóa sản phẩm.");
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("add".equals(action) || "update".equals(action)) {
            String error = validateProductInput(request);
            if (error != null) {
                session.setAttribute("errorMsg", error);
                response.sendRedirect(redirectUrl);
                return;
            }

            int id = "update".equals(action) ? Integer.parseInt(request.getParameter("id")) : 0;
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            Product p = new Product();
            if ("update".equals(action)) p.setId(id);
            p.setName(name.trim());
            p.setBrand(brand);
            p.setImg(img);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);

            String catIdStr = request.getParameter("categoryId");
            if (catIdStr != null && !catIdStr.isEmpty()) {
                p.setCategoryId(Integer.parseInt(catIdStr));
            }

            if ("add".equals(action)) {
                ProductService.getInstance().addProduct(p);
                session.setAttribute("successMsg", "Thêm sản phẩm thành công!");
            } else {
                ProductService.getInstance().updateProduct(p);
                session.setAttribute("successMsg", "Cập nhật sản phẩm thành công!");
            }

            response.sendRedirect(redirectUrl);
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ProductService.getInstance().deleteProduct(id);
                session.setAttribute("successMsg", "Xóa sản phẩm thành công!");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "ID sản phẩm không hợp lệ.");
            }
            response.sendRedirect(redirectUrl);
        } else {
            doGet(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User auth = (User) session.getAttribute("auth");
        return auth != null;
    }

    private int parseIntParameter(String value, int defaultValue) {
        try { return Integer.parseInt(value); } catch (NumberFormatException e) { return defaultValue; }
    }

    private String buildBaseQueryString(String q, String brand, String status, String price) {
        StringJoiner joiner = new StringJoiner("&");
        if (q != null && !q.trim().isEmpty()) joiner.add("q=" + URLEncoder.encode(q, StandardCharsets.UTF_8));
        if (brand != null && !brand.trim().isEmpty()) joiner.add("brand=" + URLEncoder.encode(brand, StandardCharsets.UTF_8));
        if (status != null && !status.trim().isEmpty()) joiner.add("status=" + URLEncoder.encode(status, StandardCharsets.UTF_8));
        if (price != null && !price.trim().isEmpty()) joiner.add("price=" + URLEncoder.encode(price, StandardCharsets.UTF_8));
        return joiner.toString();
    }
}
