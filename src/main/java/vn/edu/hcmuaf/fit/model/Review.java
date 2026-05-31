package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int productId;
    private int customerId;
    private Integer rating; // 1-5 stars
    private String content;
    private Timestamp reviewDate;
    
    // Thông tin bổ sung (không lưu trong DB, dùng để hiển thị)
    private String customerName;
    private String productName;

    public Review() {
    }

    public Review(int reviewId, int productId, int customerId, Integer rating, String content, Timestamp reviewDate) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.customerId = customerId;
        this.rating = rating;
        this.content = content;
        this.reviewDate = reviewDate;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    // Helper method để hiển thị rating dạng stars
    public String getStarsHtml() {
        if (rating == null) return "";
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("<i class='fas fa-star' style='color: #ffc107;'></i>");
            } else {
                stars.append("<i class='far fa-star' style='color: #ddd;'></i>");
            }
        }
        return stars.toString();
    }
}
