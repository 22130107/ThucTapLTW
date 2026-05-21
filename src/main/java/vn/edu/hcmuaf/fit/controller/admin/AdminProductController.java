package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductController", value = "/admin/products")
public class AdminProductController extends HttpServlet {
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

        ProductService ps = ProductService.getInstance();
        List<Product> list;

        if ((q != null && !q.isEmpty()) ||
                (brand != null && !brand.isEmpty()) ||
                (status != null && !status.isEmpty()) ||
                (price != null && !price.isEmpty())) {
            list = ps.filterAdmin(q, brand, status, price);
        } else {
            list = ps.getAllProducts();
        }

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

        request.getRequestDispatcher("/Admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/Login/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");

            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Tên sản phẩm không được để trống");
                response.sendRedirect("products");
                return;
            }

            double price = 0;
            int stock = 0;
            try {
                price = Double.parseDouble(request.getParameter("price"));
                stock = Integer.parseInt(request.getParameter("stock"));
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Giá hoặc tồn kho không hợp lệ");
                response.sendRedirect("products");
                return;
            }

            Product p = new Product();
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

            ProductService.getInstance().addProduct(p);
            request.getSession().setAttribute("success", "Thêm sản phẩm thành công!");
            response.sendRedirect("products");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");

            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Tên sản phẩm không được để trống");
                response.sendRedirect("products");
                return;
            }

            double price = 0;
            int stock = 0;
            try {
                price = Double.parseDouble(request.getParameter("price"));
                stock = Integer.parseInt(request.getParameter("stock"));
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Giá hoặc tồn kho không hợp lệ");
                response.sendRedirect("products");
                return;
            }

            Product p = new Product();
            p.setId(id);
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

            ProductService.getInstance().updateProduct(p);
            request.getSession().setAttribute("success", "Cập nhật sản phẩm thành công!");
            response.sendRedirect("products");
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ProductService.getInstance().deleteProduct(id);
                request.getSession().setAttribute("success", "Xóa sản phẩm thành công!");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID sản phẩm không hợp lệ");
            }
            response.sendRedirect("products");
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
}
