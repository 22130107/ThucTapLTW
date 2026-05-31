package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.ReviewDAO;
import vn.edu.hcmuaf.fit.model.Review;

import java.util.List;

public class ReviewService {
    private static final ReviewService instance = new ReviewService();
    private final ReviewDAO reviewDAO = ReviewDAO.getInstance();

    private ReviewService() {
    }

    public static ReviewService getInstance() {
        return instance;
    }

    /**
     * Lấy tất cả review của sản phẩm
     */
    public List<Review> getReviewsByProductId(int productId) {
        return reviewDAO.getReviewsByProductId(productId);
    }

    /**
     * Kiểm tra khách hàng có thể đánh giá sản phẩm không
     * Điều kiện: Đã mua hàng và chưa đánh giá
     */
    public boolean canCustomerReview(int customerId, int productId) {
        boolean hasPurchased = reviewDAO.hasCustomerPurchasedProduct(customerId, productId);
        boolean hasReviewed = reviewDAO.hasCustomerReviewedProduct(customerId, productId);
        return hasPurchased && !hasReviewed;
    }

    /**
     * Kiểm tra khách hàng đã mua sản phẩm chưa
     */
    public boolean hasCustomerPurchasedProduct(int customerId, int productId) {
        return reviewDAO.hasCustomerPurchasedProduct(customerId, productId);
    }

    /**
     * Kiểm tra khách hàng đã đánh giá sản phẩm chưa
     */
    public boolean hasCustomerReviewedProduct(int customerId, int productId) {
        return reviewDAO.hasCustomerReviewedProduct(customerId, productId);
    }

    /**
     * Thêm review mới
     */
    public boolean addReview(int productId, int customerId, Integer rating, String content) {
        // Validate
        if (content == null || content.trim().isEmpty()) {
            return false;
        }

        if (rating != null && (rating < 1 || rating > 5)) {
            return false;
        }

        // Kiểm tra quyền đánh giá
        if (!canCustomerReview(customerId, productId)) {
            return false;
        }

        Review review = new Review();
        review.setProductId(productId);
        review.setCustomerId(customerId);
        review.setRating(rating);
        review.setContent(content.trim());

        return reviewDAO.addReview(review);
    }

    /**
     * Xóa review
     */
    public boolean deleteReview(int reviewId, int customerId) {
        return reviewDAO.deleteReview(reviewId, customerId);
    }

    /**
     * Lấy review của khách hàng
     */
    public List<Review> getReviewsByCustomerId(int customerId) {
        return reviewDAO.getReviewsByCustomerId(customerId);
    }

    /**
     * Đếm số review của sản phẩm
     */
    public int countReviews(int productId) {
        return reviewDAO.countReviewsByProductId(productId);
    }

    /**
     * Lấy rating trung bình
     */
    public double getAverageRating(int productId) {
        return reviewDAO.getAverageRating(productId);
    }
}
