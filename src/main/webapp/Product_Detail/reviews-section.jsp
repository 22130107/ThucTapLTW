<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .reviews-section {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .reviews-header {
        border-bottom: 2px solid #e0e0e0;
        padding-bottom: 15px;
        margin-bottom: 30px;
    }
    
    .reviews-header h2 {
        font-size: 24px;
        color: #333;
        margin: 0 0 10px 0;
    }
    
    .reviews-stats {
        display: flex;
        align-items: center;
        gap: 20px;
        color: #666;
    }
    
    .review-form {
        background: #f9f9f9;
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 30px;
    }
    
    .review-form h3 {
        margin-top: 0;
        color: #333;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #555;
    }
    
    .star-rating {
        display: flex;
        gap: 5px;
        font-size: 24px;
    }
    
    .star-rating i {
        cursor: pointer;
        color: #ddd;
        transition: color 0.2s;
    }
    
    .star-rating i.active,
    .star-rating i:hover {
        color: #ffc107;
    }
    
    .form-group textarea {
        width: 100%;
        min-height: 100px;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-family: inherit;
        font-size: 14px;
        resize: vertical;
    }
    
    .btn-submit-review {
        background: #2ecc71;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 4px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: background 0.3s;
    }
    
    .btn-submit-review:hover {
        background: #27ae60;
    }
    
    .btn-submit-review:disabled {
        background: #95a5a6;
        cursor: not-allowed;
    }
    
    .review-item {
        border-bottom: 1px solid #e0e0e0;
        padding: 20px 0;
    }
    
    .review-item:last-child {
        border-bottom: none;
    }
    
    .review-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    
    .reviewer-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .reviewer-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #3498db;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 18px;
    }
    
    .reviewer-name {
        font-weight: 600;
        color: #333;
    }
    
    .review-date {
        color: #999;
        font-size: 14px;
    }
    
    .review-rating {
        margin-bottom: 10px;
    }
    
    .review-rating i {
        color: #ffc107;
        font-size: 16px;
    }
    
    .review-content {
        color: #555;
        line-height: 1.6;
    }
    
    .no-reviews {
        text-align: center;
        padding: 40px;
        color: #999;
    }
    
    .alert {
        padding: 12px 20px;
        border-radius: 4px;
        margin-bottom: 20px;
    }
    
    .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    
    .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    
    .alert-info {
        background: #d1ecf1;
        color: #0c5460;
        border: 1px solid #bee5eb;
    }
</style>

<div class="reviews-section">
    <div class="reviews-header">
        <h2><i class="fas fa-comments"></i> Đánh giá sản phẩm</h2>
        <div class="reviews-stats">
            <span><strong>${reviewCount}</strong> đánh giá</span>
            <c:if test="${product.rating > 0}">
                <span>
                    <i class="fas fa-star" style="color: #ffc107;"></i>
                    <strong><fmt:formatNumber value="${product.rating}" maxFractionDigits="1"/></strong>/5
                </span>
            </c:if>
        </div>
    </div>

    <!-- Form đánh giá -->
    <c:choose>
        <c:when test="${empty auth}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để đánh giá sản phẩm.
            </div>
        </c:when>
        <c:when test="${canReview}">
            <div class="review-form">
                <h3>Viết đánh giá của bạn</h3>
                <div id="reviewMessage"></div>
                <form id="reviewForm">
                    <input type="hidden" name="productId" value="${product.id}">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" id="ratingValue" name="rating" value="">
                    
                    <div class="form-group">
                        <label>Đánh giá của bạn:</label>
                        <div class="star-rating" id="starRating">
                            <i class="far fa-star" data-rating="1"></i>
                            <i class="far fa-star" data-rating="2"></i>
                            <i class="far fa-star" data-rating="3"></i>
                            <i class="far fa-star" data-rating="4"></i>
                            <i class="far fa-star" data-rating="5"></i>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="reviewContent">Nhận xét của bạn: <span style="color: red;">*</span></label>
                        <textarea id="reviewContent" name="content" required 
                                  placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit-review">
                        <i class="fas fa-paper-plane"></i> Gửi đánh giá
                    </button>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                Bạn chỉ có thể đánh giá sản phẩm đã mua.
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Danh sách đánh giá -->
    <div class="reviews-list">
        <c:choose>
            <c:when test="${empty reviews}">
                <div class="no-reviews">
                    <i class="fas fa-comment-slash" style="font-size: 48px; color: #ddd; margin-bottom: 10px;"></i>
                    <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                    <c:if test="${canReview}">
                        <p>Hãy là người đầu tiên đánh giá!</p>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${reviews}" var="review">
                    <div class="review-item">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    ${review.customerName.substring(0, 1).toUpperCase()}
                                </div>
                                <div>
                                    <div class="reviewer-name">${review.customerName}</div>
                                    <div class="review-date">
                                        <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${review.rating != null}">
                            <div class="review-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= review.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star" style="color: #ddd;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </c:if>
                        
                        <div class="review-content">
                            ${review.content}
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Star rating interaction
    const stars = document.querySelectorAll('#starRating i');
    const ratingValue = document.getElementById('ratingValue');
    
    stars.forEach(star => {
        star.addEventListener('click', function() {
            const rating = this.getAttribute('data-rating');
            ratingValue.value = rating;
            
            // Update star display
            stars.forEach(s => {
                const starRating = s.getAttribute('data-rating');
                if (starRating <= rating) {
                    s.classList.remove('far');
                    s.classList.add('fas', 'active');
                } else {
                    s.classList.remove('fas', 'active');
                    s.classList.add('far');
                }
            });
        });
        
        // Hover effect
        star.addEventListener('mouseenter', function() {
            const rating = this.getAttribute('data-rating');
            stars.forEach(s => {
                const starRating = s.getAttribute('data-rating');
                if (starRating <= rating) {
                    s.style.color = '#ffc107';
                } else {
                    s.style.color = '#ddd';
                }
            });
        });
    });
    
    // Reset hover effect
    document.getElementById('starRating').addEventListener('mouseleave', function() {
        const currentRating = ratingValue.value;
        stars.forEach(s => {
            const starRating = s.getAttribute('data-rating');
            if (currentRating && starRating <= currentRating) {
                s.style.color = '#ffc107';
            } else {
                s.style.color = '#ddd';
            }
        });
    });
    
    // Submit review form
    document.getElementById('reviewForm')?.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        const messageDiv = document.getElementById('reviewMessage');
        const submitBtn = this.querySelector('button[type="submit"]');
        
        // Debug: Log form data
        console.log('Submitting review...');
        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        
        // Disable submit button
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
        
        try {
            const response = await fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                body: formData
            });
            
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers.get('content-type'));
            
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                const text = await response.text();
                console.error('Expected JSON but got:', text);
                messageDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Lỗi: Server không trả về JSON. Kiểm tra console.</div>';
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
                return;
            }
            
            const result = await response.json();
            console.log('Result:', result);
            
            if (result.success) {
                messageDiv.innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> ' + result.message + '</div>';
                // Reload page after 2 seconds
                setTimeout(() => {
                    window.location.reload();
                }, 2000);
            } else {
                messageDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ' + result.message + '</div>';
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
            }
        } catch (error) {
            messageDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Có lỗi xảy ra. Vui lòng thử lại.</div>';
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
        }
    });
</script>
