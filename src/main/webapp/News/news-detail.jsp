<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${article.title} | THIẾT BỊ Y TẾ 24H</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/News/news.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/News/news-detail.css">
</head>
<body>
<jsp:include page="/style/header/header.jsp"/>

<main class="news-page">

    <!-- HERO nhỏ -->
    <section class="detail-hero" style="background-image:url('${article.imageUrl}')">
        <div class="detail-hero-overlay"></div>
        <div class="container detail-hero-content">
            <nav class="breadcrumb">
                <a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="${pageContext.request.contextPath}/news">Tin Tức</a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="${pageContext.request.contextPath}/news?cat=${article.category}">${article.categoryLabel}</a>
            </nav>
            <span class="news-badge badge--${article.badgeType}" style="position:static;display:inline-flex;margin-bottom:12px">
                ${article.badgeLabel}
            </span>
            <h1 class="detail-hero-title">${article.title}</h1>
            <div class="detail-meta">
                <span><i class="fa-regular fa-calendar"></i> ${article.date}</span>
                <span><i class="fa-regular fa-eye"></i> ${article.views} lượt xem</span>
                <span><i class="fa-solid fa-folder-open"></i> ${article.categoryLabel}</span>
            </div>
        </div>
    </section>

    <div class="container news-layout">

        <!-- NỘI DUNG CHÍNH -->
        <div class="news-main">

            <!-- Bài viết -->
            <article class="detail-article">

                <!-- Nút quay lại -->
                <div class="detail-back-bar">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/news" class="btn-back-list">
                        <i class="fa-solid fa-newspaper"></i> Tất cả tin tức
                    </a>
                </div>

                <!-- Excerpt nổi bật -->
                <div class="detail-excerpt">
                    <i class="fa-solid fa-quote-left"></i>
                    ${article.excerpt}
                </div>

                <!-- Nội dung HTML – load từ JSP fragment -->
                <div class="detail-content">
                    <jsp:include page="${article.contentFragment}"/>
                </div>

                <!-- Tags -->
                <div class="detail-tags">
                    <i class="fa-solid fa-tags"></i>
                    <c:forEach var="tag" items="${article.tags}">
                        <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">${tag}</a>
                    </c:forEach>
                </div>

                <!-- Chia sẻ -->
                <div class="detail-share">
                    <span class="detail-share-label"><i class="fa-solid fa-share-nodes"></i> Chia sẻ bài viết:</span>
                    <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}"
                       target="_blank" class="share-btn share-btn--fb">
                        <i class="fa-brands fa-facebook-f"></i> Facebook
                    </a>
                    <a href="https://zalo.me/share/url?url=${pageContext.request.requestURL}"
                       target="_blank" class="share-btn share-btn--zalo">
                        <i class="fa-solid fa-comment-dots"></i> Zalo
                    </a>
                    <button class="share-btn share-btn--copy" onclick="copyLink()">
                        <i class="fa-solid fa-link"></i> Sao chép link
                    </button>
                </div>

                <!-- Điều hướng bài viết -->
                <div class="detail-nav">
                    <c:if test="${article.id > 1}">
                        <a href="${pageContext.request.contextPath}/news-detail?id=${article.id - 1}" class="detail-nav-btn detail-nav-btn--prev">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Bài trước</span>
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/news" class="detail-nav-btn detail-nav-btn--list">
                        <i class="fa-solid fa-th-list"></i>
                        <span>Danh sách</span>
                    </a>
                    <c:if test="${article.id < 24}">
                        <a href="${pageContext.request.contextPath}/news-detail?id=${article.id + 1}" class="detail-nav-btn detail-nav-btn--next">
                            <span>Bài tiếp</span>
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </c:if>
                </div>
            </article>

            <!-- BÀI VIẾT LIÊN QUAN -->
            <c:if test="${not empty related}">
            <section class="related-section">
                <div class="news-section-head">
                    <span class="news-section-eyebrow">
                        <i class="fa-solid fa-layer-group"></i> Bài viết liên quan
                    </span>
                    <a href="${pageContext.request.contextPath}/news?cat=${article.category}" class="news-viewall">
                        Xem tất cả <i class="fa-solid fa-arrow-right"></i>
                    </a>
                </div>
                <div class="news-grid">
                    <c:forEach var="r" items="${related}">
                        <article class="news-card">
                            <a href="${pageContext.request.contextPath}/news-detail?id=${r.id}" class="news-card-img-wrap">
                                <img src="${r.imageUrl}" alt="${r.title}" loading="lazy">
                                <span class="news-badge badge--${r.badgeType}">${r.badgeLabel}</span>
                            </a>
                            <div class="news-card-body">
                                <div class="news-card-tags">
                                    <span class="tag tag--${r.badgeType}">${r.badgeLabel}</span>
                                    <span class="tag tag--cat">${r.categoryLabel}</span>
                                </div>
                                <h2 class="news-card-title">
                                    <a href="${pageContext.request.contextPath}/news-detail?id=${r.id}">${r.title}</a>
                                </h2>
                                <p class="news-card-excerpt">${r.excerpt}</p>
                                <div class="news-card-footer">
                                    <span class="news-date"><i class="fa-regular fa-calendar"></i> ${r.date}</span>
                                    <a href="${pageContext.request.contextPath}/news-detail?id=${r.id}" class="btn-read">
                                        <i class="fa-solid fa-book-open-reader"></i> ĐỌC NGAY
                                    </a>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </section>
            </c:if>

        </div><!-- /news-main -->

        <!-- SIDEBAR -->
        <aside class="news-sidebar">

            <!-- CTA tư vấn -->
            <div class="sidebar-widget sidebar-hotline">
                <div class="hotline-icon"><i class="fa-solid fa-phone-volume"></i></div>
                <h3>Tư Vấn Miễn Phí</h3>
                <p>Chuyên gia sẵn sàng hỗ trợ bạn <strong>24/7</strong></p>
                <a href="tel:0888999406" class="hotline-number">0888.999.406</a>
                <span class="hotline-free-badge">Miễn phí hoàn toàn</span>
                <a href="tel:0888999406" class="hotline-btn"><i class="fa-solid fa-headset"></i> Gọi Ngay</a>
            </div>

            <!-- Danh mục -->
            <div class="sidebar-widget">
                <h3 class="sidebar-widget-title"><i class="fa-solid fa-list"></i> Danh Mục Tin Tức</h3>
                <ul class="sidebar-cat-list">
                    <li class="sidebar-cat-item ${article.category == 'meo-suc-khoe' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=meo-suc-khoe">
                            <i class="fa-solid fa-heart-pulse"></i>
                            <span>Mẹo chăm sóc sức khỏe</span>
                            <em>${catCounts['meo-suc-khoe']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${article.category == 'huong-dan' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=huong-dan">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                            <span>Hướng dẫn dùng thiết bị</span>
                            <em>${catCounts['huong-dan']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${article.category == 'tin-y-te' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=tin-y-te">
                            <i class="fa-solid fa-newspaper"></i>
                            <span>Tin y tế mới</span>
                            <em>${catCounts['tin-y-te']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${article.category == 'canh-bao' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=canh-bao">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span>Cảnh báo bệnh mùa</span>
                            <em>${catCounts['canh-bao']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${article.category == 'khuyen-nghi' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=khuyen-nghi">
                            <i class="fa-solid fa-user-doctor"></i>
                            <span>Khuyến nghị bác sĩ</span>
                            <em>${catCounts['khuyen-nghi']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${article.category == 'tre-em' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=tre-em">
                            <i class="fa-solid fa-baby"></i>
                            <span>Sức khỏe trẻ em</span>
                            <em>${catCounts['tre-em']}</em>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Tin đọc nhiều -->
            <div class="sidebar-widget">
                <h3 class="sidebar-widget-title"><i class="fa-solid fa-fire-flame-curved"></i> Tin Đọc Nhiều Nhất</h3>
                <ol class="sidebar-top-list">
                    <c:forEach var="f" items="${featured}" varStatus="st">
                        <li class="sidebar-top-item">
                            <span class="top-rank ${st.index==0?'top-rank--1':st.index==1?'top-rank--2':st.index==2?'top-rank--3':''}">${st.index+1}</span>
                            <div class="top-info">
                                <a href="${pageContext.request.contextPath}/news-detail?id=${f.id}">${f.title}</a>
                                <span class="top-views"><i class="fa-regular fa-eye"></i> ${f.views} lượt xem</span>
                            </div>
                        </li>
                    </c:forEach>
                </ol>
            </div>

        </aside>
    </div><!-- /news-layout -->

    <div class="container">
        <jsp:include page="/style/footer/footer.jsp"/>
    </div>
</main>

<script src="${pageContext.request.contextPath}/style/header/header.js"></script>
<script src="${pageContext.request.contextPath}/style/footer/footer.js"></script>
<script>
function copyLink() {
    navigator.clipboard.writeText(window.location.href).then(function() {
        var btn = document.querySelector('.share-btn--copy');
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fa-solid fa-check"></i> Đã sao chép!';
        btn.style.background = '#22a85a';
        setTimeout(function(){ btn.innerHTML = orig; btn.style.background = ''; }, 2000);
    });
}
</script>
</body>
</html>
