package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductController", value = "/admin/products")
public class AdminProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String brand = request.getParameter("brand");
        String status = request.getParameter("status");
        String price = request.getParameter("price");

        List<Product> list;

        if ((q != null && !q.isEmpty()) ||
                (brand != null && !brand.isEmpty()) ||
                (status != null && !status.isEmpty()) ||
                (price != null && !price.isEmpty())) {
            list = ProductService.getInstance().filterAdmin(q, brand, status, price);
        } else {
            list = ProductService.getInstance().getAllProducts();
        }

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
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");
            double price = 0;
            int stock = 0;

            try {
                price = Double.parseDouble(request.getParameter("price"));
                stock = Integer.parseInt(request.getParameter("stock"));
            } catch (NumberFormatException e) {

            }

            Product p = new Product();
            p.setName(name);
            p.setBrand(brand);
            p.setImg(img);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);

            ProductService.getInstance().addProduct(p);

            response.sendRedirect("products");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String img = request.getParameter("img");
            String description = request.getParameter("description");
            double price = 0;
            int stock = 0;

            try {
                price = Double.parseDouble(request.getParameter("price"));
                stock = Integer.parseInt(request.getParameter("stock"));
            } catch (NumberFormatException e) {

            }

            Product p = new Product();
            p.setId(id);
            p.setName(name);
            p.setBrand(brand);
            p.setImg(img);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);

            ProductService.getInstance().updateProduct(p);

            response.sendRedirect("products");
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ProductService.getInstance().deleteProduct(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect("products");
        } else {
            doGet(request, response);
        }
    }
}
