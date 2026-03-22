package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.service.ProductService;

import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", value = "/catalog")
public class ProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] brands = request.getParameterValues("brand");
        String priceRange = request.getParameter("price");
        String sort = request.getParameter("sort");
        String cidStr = request.getParameter("cid");

        Integer categoryId = null;
        Category currentCategory = null;
        if (cidStr != null && !cidStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(cidStr);
                currentCategory = CategoryService.getInstance().getById(categoryId);
            } catch (NumberFormatException e) {

            }
        }

        String search = request.getParameter("q");
        List<Product> products = ProductService.getInstance().getProducts(categoryId, brands, priceRange, sort, search);

        request.setAttribute("products", products);
        request.setAttribute("selectedBrands", brands != null ? List.of(brands) : List.of());
        request.setAttribute("selectedPrice", priceRange);
        request.setAttribute("selectedSort", sort);
        request.setAttribute("currentCategory", currentCategory);

        request.getRequestDispatcher("/Catalog/catalog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
