package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.ReviewService;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", value = "/review")
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đánh giá.\"}");
            return;
        }

        // Lấy customerId
        int customerId = new UserDAO().getCustomerIdByAccountId(user.getAccountID());
        if (customerId == -1) {
            response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy thông tin khách hàng.\"}");
            return;
        }

        // Lấy parameters
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            handleAddReview(request, response, customerId);
        } else if ("delete".equals(action)) {
            handleDeleteReview(request, response, customerId);
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Hành động không hợp lệ.\"}");
        }
    }

    private void handleAddReview(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String ratingParam = request.getParameter("rating");
            String content = request.getParameter("content");

            Integer rating = null;
            if (ratingParam != null && !ratingParam.isEmpty()) {
                rating = Integer.parseInt(ratingParam);
            }

            // Validate
            if (content == null || content.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Nội dung đánh giá không được để trống.\"}");
                return;
            }

            if (rating != null && (rating < 1 || rating > 5)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Đánh giá phải từ 1 đến 5 sao.\"}");
                return;
            }

            // Kiểm tra quyền đánh giá
            ReviewService reviewService = ReviewService.getInstance();
            
            if (!reviewService.hasCustomerPurchasedProduct(customerId, productId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn chỉ có thể đánh giá sản phẩm đã mua.\"}");
                return;
            }

            if (reviewService.hasCustomerReviewedProduct(customerId, productId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đánh giá sản phẩm này rồi.\"}");
                return;
            }

            // Thêm review
            boolean success = reviewService.addReview(productId, customerId, rating, content);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Cảm ơn bạn đã đánh giá!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra. Vui lòng thử lại.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ.\"}");
        }
    }

    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));

            boolean success = ReviewService.getInstance().deleteReview(reviewId, customerId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Đã xóa đánh giá.\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể xóa đánh giá.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ.\"}");
        }
    }
}
