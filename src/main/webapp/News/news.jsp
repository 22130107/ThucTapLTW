<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin Tức – Sức Khỏe | THIẾT BỊ Y TẾ 24H</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/News/news.css">
</head>
<body>
<jsp:include page="/style/header/header.jsp"/>

<main class="news-page">

    <!-- HERO -->
    <section class="news-hero">
        <div class="news-hero-overlay"></div>
        <div class="container news-hero-content">
            <nav class="breadcrumb" aria-label="Breadcrumb">
                <a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <i class="fa-solid fa-chevron-right"></i>
                <span>Tin Tức – Sức Khỏe</span>
            </nav>
            <h1 class="news-hero-title"><i class="fa-solid fa-newspaper"></i> TIN TỨC – SỨC KHỎE</h1>
            <p class="news-hero-sub">Kiến thức y tế, hướng dẫn thiết bị và cảnh báo sức khỏe từ chuyên gia</p>
        </div>
    </section>

    <div class="container news-layout">

        <!-- MAIN -->
        <div class="news-main">

            <!-- Section head -->
            <div class="news-section-head">
                <span class="news-section-eyebrow">
                    <c:choose>
                        <c:when test="${currentCat == 'all' || empty currentCat}">
                            <i class="fa-solid fa-fire"></i> Tất cả bài viết
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-filter"></i>
                            <c:forEach var="e" items="${catCounts}">
                                <c:if test="${e.key == currentCat}">
                                    Danh mục đã chọn
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </span>
                <span class="news-count-badge">${totalCount} bài viết</span>
            </div>

            <!-- CARD GRID -->
            <div class="news-grid">
                <c:forEach var="a" items="${articles}">
                    <article class="news-card">
                        <a href="${pageContext.request.contextPath}/news-detail?id=${a.id}" class="news-card-img-wrap">
                            <img src="${a.imageUrl}" alt="${a.title}" loading="lazy">
                            <span class="news-badge badge--${a.badgeType}">${a.badgeLabel}</span>
                        </a>
                        <div class="news-card-body">
                            <div class="news-card-tags">
                                <span class="tag tag--${a.badgeType}">
                                    <c:choose>
                                        <c:when test="${a.badgeType == 'guide'}"><i class="fa-solid fa-book-open"></i></c:when>
                                        <c:when test="${a.badgeType == 'warning'}"><i class="fa-solid fa-triangle-exclamation"></i></c:when>
                                        <c:when test="${a.badgeType == 'new'}"><i class="fa-solid fa-star"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-circle-check"></i></c:otherwise>
                                    </c:choose>
                                    ${a.badgeLabel}
                                </span>
                                <span class="tag tag--cat">${a.categoryLabel}</span>
                            </div>
                            <h2 class="news-card-title">
                                <a href="${pageContext.request.contextPath}/news-detail?id=${a.id}">${a.title}</a>
                            </h2>
                            <p class="news-card-excerpt">${a.excerpt}</p>
                            <div class="news-card-footer">
                                <span class="news-date"><i class="fa-regular fa-calendar"></i> ${a.date}</span>
                                <a href="${pageContext.request.contextPath}/news-detail?id=${a.id}" class="btn-read">
                                    <i class="fa-solid fa-book-open-reader"></i> ĐỌC NGAY
                                </a>
                            </div>
                        </div>
                    </article>
                </c:forEach>

                <c:if test="${empty articles}">
                    <div class="news-empty">
                        <i class="fa-solid fa-newspaper"></i>
                        <p>Chưa có bài viết nào trong danh mục này.</p>
                        <a href="${pageContext.request.contextPath}/news" class="btn-read">Xem tất cả</a>
                    </div>
                </c:if>
            </div>

            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
            <nav class="news-pagination" aria-label="Phân trang">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/news?page=${currentPage-1}&cat=${currentCat}"
                       class="page-btn page-btn--prev">
                        <i class="fa-solid fa-chevron-left"></i> Trước
                    </a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:choose>
                        <c:when test="${p == currentPage}">
                            <span class="page-btn page-btn--active">${p}</span>
                        </c:when>
                        <c:when test="${p == 1 || p == totalPages || (p >= currentPage-1 && p <= currentPage+1)}">
                            <a href="${pageContext.request.contextPath}/news?page=${p}&cat=${currentCat}"
                               class="page-btn">${p}</a>
                        </c:when>
                        <c:when test="${p == currentPage-2 || p == currentPage+2}">
                            <span class="page-dots">…</span>
                        </c:when>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/news?page=${currentPage+1}&cat=${currentCat}"
                       class="page-btn page-btn--next">
                        Tiếp <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </c:if>
            </nav>
            </c:if>

        </div><!-- /news-main -->

        <!-- SIDEBAR -->
        <aside class="news-sidebar">

            <!-- Danh mục -->
            <div class="sidebar-widget">
                <h3 class="sidebar-widget-title"><i class="fa-solid fa-list"></i> Danh Mục Tin Tức</h3>
                <ul class="sidebar-cat-list">
                    <li class="sidebar-cat-item ${currentCat == 'all' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=all">
                            <i class="fa-solid fa-border-all"></i>
                            <span>Tất cả bài viết</span>
                            <em>24</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'meo-suc-khoe' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=meo-suc-khoe">
                            <i class="fa-solid fa-heart-pulse"></i>
                            <span>Mẹo chăm sóc sức khỏe</span>
                            <em>${catCounts['meo-suc-khoe']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'huong-dan' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=huong-dan">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                            <span>Hướng dẫn dùng thiết bị</span>
                            <em>${catCounts['huong-dan']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'tin-y-te' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=tin-y-te">
                            <i class="fa-solid fa-newspaper"></i>
                            <span>Tin y tế mới</span>
                            <em>${catCounts['tin-y-te']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'canh-bao' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=canh-bao">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span>Cảnh báo bệnh mùa</span>
                            <em>${catCounts['canh-bao']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'khuyen-nghi' ? 'sidebar-cat-item--active' : ''}">
                        <a href="${pageContext.request.contextPath}/news?cat=khuyen-nghi">
                            <i class="fa-solid fa-user-doctor"></i>
                            <span>Khuyến nghị bác sĩ</span>
                            <em>${catCounts['khuyen-nghi']}</em>
                        </a>
                    </li>
                    <li class="sidebar-cat-item ${currentCat == 'tre-em' ? 'sidebar-cat-item--active' : ''}">
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
                            <span class="top-rank ${st.index == 0 ? 'top-rank--1' : st.index == 1 ? 'top-rank--2' : st.index == 2 ? 'top-rank--3' : ''}">${st.index + 1}</span>
                            <div class="top-info">
                                <a href="${pageContext.request.contextPath}/news-detail?id=${f.id}">${f.title}</a>
                                <span class="top-views"><i class="fa-regular fa-eye"></i> ${f.views} lượt xem</span>
                            </div>
                        </li>
                    </c:forEach>
                </ol>
            </div>

            <!-- Hotline -->
            <div class="sidebar-widget sidebar-hotline">
                <div class="hotline-icon"><i class="fa-solid fa-phone-volume"></i></div>
                <h3>Tư Vấn Miễn Phí</h3>
                <p>Chuyên gia sẵn sàng hỗ trợ bạn <strong>24/7</strong></p>
                <a href="tel:0888999406" class="hotline-number">0888.999.406</a>
                <span class="hotline-free-badge">Miễn phí hoàn toàn</span>
                <a href="tel:0888999406" class="hotline-btn"><i class="fa-solid fa-headset"></i> Gọi Ngay</a>
            </div>

            <!-- Tags -->
            <div class="sidebar-widget">
                <h3 class="sidebar-widget-title"><i class="fa-solid fa-tags"></i> Từ Khoá Phổ Biến</h3>
                <div class="sidebar-tags">
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Huyết áp</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Máy đo SpO2</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Xe lăn</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Khí dung</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Giường y tế</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Tiểu đường</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Người cao tuổi</a>
                    <a href="${pageContext.request.contextPath}/news?cat=tre-em" class="sidebar-tag">Trẻ em</a>
                    <a href="${pageContext.request.contextPath}/news?cat=all" class="sidebar-tag">Phục hồi chức năng</a>
                </div>
            </div>

        </aside>
    </div><!-- /news-layout -->

    <div class="container">
        <jsp:include page="/style/footer/footer.jsp"/>
    </div>
</main>

<script src="${pageContext.request.contextPath}/style/header/header.js"></script>
<script src="${pageContext.request.contextPath}/style/footer/footer.js"></script>
</body>
</html>
