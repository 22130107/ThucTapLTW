package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.service.CartService;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        vn.edu.hcmuaf.fit.model.User user = (vn.edu.hcmuaf.fit.model.User) session.getAttribute("auth");
        if (user != null) {
            int customerId = new vn.edu.hcmuaf.fit.dao.UserDAO().getCustomerIdByAccountId(user.getAccountID());
            if (customerId != -1) {
                Cart cart = CartService.getInstance().getCart(customerId);
                session.setAttribute("cart", cart);
            }
        } else {
            session.removeAttribute("cart");
        }

        List<Category> categories = CategoryService.getInstance().getAll();
        List<Product> featuredProducts = ProductService.getInstance().getFeaturedProducts(10);

        Map<Integer, List<Product>> categoryProducts = new HashMap<>();
        for (Category c : categories) {
            List<Product> products = ProductService.getInstance().getProductsByCategory(c.getCategoryID(), 12);
            if (!products.isEmpty()) {
                categoryProducts.put(c.getCategoryID(), products);
            }
        }

        request.setAttribute("categories", categories);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("categoryProducts", categoryProducts);

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
