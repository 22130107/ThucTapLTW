package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Product;
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
        String q = request.getParameter("q");
        String brand = request.getParameter("brand");
        String status = request.getParameter("status");
        String price = request.getParameter("price");
        int page = parseIntParameter(request.getParameter("page"), 1);
        int pageSize = parseIntParameter(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        if (pageSize <= 0) {
            pageSize = DEFAULT_PAGE_SIZE;
        }

        int totalItems = ProductService.getInstance().countProductsAdmin(q, brand, status, price);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * pageSize;

        List<Product> list = ProductService.getInstance().getAdminProducts(q, brand, status, price, offset, pageSize);

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
            return "Product name is required.";
        }
        if (!InputValidator.isNonNegativeDouble(price)) {
            return "Price must be a number greater than or equal to 0.";
        }
        if (!InputValidator.isNonNegativeInt(stock)) {
            return "Stock must be an integer greater than or equal to 0.";
        }
        if (InputValidator.isNonEmpty(img) && !InputValidator.isValidUrl(img)) {
            return "Image URL is invalid.";
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String queryString = buildBaseQueryString(request.getParameter("q"), request.getParameter("brand"), request.getParameter("status"), request.getParameter("price"));
        String redirectUrl = request.getContextPath() + "/admin/products" + (queryString.isEmpty() ? "" : "?" + queryString);

        if ("bulkDelete".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            if (ids == null || ids.length == 0) {
                session.setAttribute("errorMsg", "Vui lòng chọn ít nhất một sản phẩm để xóa.");
                response.sendRedirect(redirectUrl);
                return;
            }

            List<Integer> productIds = new ArrayList<>();
            for (String value : ids) {
                try {
                    productIds.add(Integer.parseInt(value));
                } catch (NumberFormatException ignored) {
                }
            }

            boolean deleted = ProductService.getInstance().bulkDeleteProducts(productIds);
            if (deleted) {
                session.setAttribute("successMsg", "Đã xóa các sản phẩm được chọn.");
            } else {
                session.setAttribute("errorMsg", "Không thể xóa sản phẩm. Vui lòng thử lại.");
            }
            response.sendRedirect(redirectUrl);
            return;
        }

        String error = null;
        if ("add".equals(action)) {
            error = validateProductInput(request);
            if (error != null) {
                session.setAttribute("errorMsg", error);
                response.sendRedirect(redirectUrl);
                return;
            }

            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            Product p = new Product();
            p.setName(name);
            p.setBrand(brand);
            p.setImg(img);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);

            ProductService.getInstance().addProduct(p);
            session.setAttribute("successMsg", "Product added successfully.");
            response.sendRedirect(redirectUrl);
        } else if ("update".equals(action)) {
            error = validateProductInput(request);
            if (error != null) {
                session.setAttribute("errorMsg", error);
                response.sendRedirect(redirectUrl);
                return;
            }

            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Invalid product ID.");
                response.sendRedirect(redirectUrl);
                return;
            }

            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            Product p = new Product();
            p.setId(id);
            p.setName(name);
            p.setBrand(brand);
            p.setImg(img);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);

            ProductService.getInstance().updateProduct(p);
            session.setAttribute("successMsg", "Product updated successfully.");
            response.sendRedirect(redirectUrl);
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ProductService.getInstance().deleteProduct(id);
                session.setAttribute("successMsg", "Product deleted successfully.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Invalid product ID.");
            }
            response.sendRedirect(redirectUrl);
        } else {
            doGet(request, response);
        }
    }

    private int parseIntParameter(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String buildBaseQueryString(String q, String brand, String status, String price) {
        StringJoiner joiner = new StringJoiner("&");
        if (q != null && !q.trim().isEmpty()) {
            joiner.add("q=" + URLEncoder.encode(q, StandardCharsets.UTF_8));
        }
        if (brand != null && !brand.trim().isEmpty()) {
            joiner.add("brand=" + URLEncoder.encode(brand, StandardCharsets.UTF_8));
        }
        if (status != null && !status.trim().isEmpty()) {
            joiner.add("status=" + URLEncoder.encode(status, StandardCharsets.UTF_8));
        }
        if (price != null && !price.trim().isEmpty()) {
            joiner.add("price=" + URLEncoder.encode(price, StandardCharsets.UTF_8));
        }
        return joiner.toString();
    }
}
