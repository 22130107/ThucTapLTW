package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Review;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.ProductService;
import vn.edu.hcmuaf.fit.service.ReviewService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Product product = ProductService.getInstance().getProductById(id);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.setAttribute("relatedProducts", ProductService.getInstance().getRelatedProducts(4));
                    
                    // Load reviews
                    List<Review> reviews = ReviewService.getInstance().getReviewsByProductId(id);
                    request.setAttribute("reviews", reviews);
                    request.setAttribute("reviewCount", reviews.size());
                    
                    // Kiểm tra khách hàng có thể đánh giá không
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("auth");
                    if (user != null) {
                        int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
                        if (customerId != -1) {
                            boolean canReview = ReviewService.getInstance().canCustomerReview(customerId, id);
                            request.setAttribute("canReview", canReview);
                        }
                    }
                    
                    request.getRequestDispatcher("/Product_Detail/product-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/catalog");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
