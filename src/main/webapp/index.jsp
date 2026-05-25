<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Trang chủ</title>
                <link rel="stylesheet" href="style/style.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet" href="Home/Category/Category-sibar.css">
                <link rel="stylesheet" href="Home/Product/HomeProduct.css">
                <link rel="stylesheet" href="Home/Slide/slide.css">
                <link rel="stylesheet" href="Home/Product/productTypes.css">
                <link rel="stylesheet" href="style/footer/footer.css">
                <link rel="stylesheet" href="Home/Category/Categories.css">
                <link rel="stylesheet" href="style/header/header.css">
            </head>

            <body>
                    <c:if test="${categories == null}">
                        <c:redirect url="/home" />
                    </c:if>

                    <jsp:include page="/style/header/header.jsp" />
                    <div class="container">
                        <div class="category-sidebar" role="navigation" aria-label="Danh mụcsản phẩm">
                            <div class="category">
                                <div class="category-header">
                                    <div class="burger" aria-hidden="true"><i class="fa-solid fa-bars menu-icon"></i>
                                    </div>
                                    Danh mục sản phẩm
                                </div>
                                <div id="category-list" class="category-list" role="list">
                                    <c:if test="${not empty categories}">
                                        <c:forEach var="category" items="${categories}">
                                            <c:if test="${category.slug != 'cham-soc-suc-khoe'}">
                                                <a class="category-link" href="catalog?cid=${category.categoryID}">
                                                    <div class="category-item">
                                                        <img src="${category.image}" alt="${category.categoryName}">
                                                        <span>${category.categoryName}</span>
                                                    </div>
                                                </a>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${categories != null && empty categories}">
                                        <div class="category-item"><span>Không có danh mục nào</span></div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <section id="dm-section">

                            <section class="home-intro" aria-label="Banner nổi bật">
                                <div class="home-intro-carousel" data-autoplay="true">
                                    <div class="home-intro-track">
                                        <div class="home-intro-slide is-active">
                                            <img src="https://thietbiyte24h.net/wp-content/uploads/2024/06/banner-trang-chu-b46-2.jpg"
                                                alt="Banner thiết bị y tế B46" loading="eager" fetchpriority="high">
                                        </div>
                                        <div class="home-intro-slide">
                                            <img src="https://thietbiyte24h.net/wp-content/uploads/2024/06/banner-trang-chu-c88-2.jpg"
                                                alt="Banner thiết bị y tế C88" loading="lazy">
                                        </div>
                                        <div class="home-intro-slide">
                                            <img src="https://thietbiyte24h.net/wp-content/uploads/2024/06/banner-trang-chu-s108-2.jpg"
                                                alt="Banner thiết bị y tế S108" loading="lazy">
                                        </div>
                                    </div>

                                    <button class="home-intro-arrow prev" type="button" aria-label="Banner trước">
                                        &#10094;
                                    </button>
                                    <button class="home-intro-arrow next" type="button" aria-label="Banner sau">
                                        &#10095;
                                    </button>

                                    <div class="home-intro-dots" role="tablist" aria-label="Chọn banner">
                                        <button class="home-intro-dot is-active" type="button" data-slide="0"
                                            aria-label="Banner 1" aria-selected="true"></button>
                                        <button class="home-intro-dot" type="button" data-slide="1"
                                            aria-label="Banner 2" aria-selected="false"></button>
                                        <button class="home-intro-dot" type="button" data-slide="2"
                                            aria-label="Banner 3" aria-selected="false"></button>
                                    </div>
                                </div>
                            </section>


                            <%-- Category Sections --%>
                                <c:set var="stopRender" value="false" scope="page" />
                                <c:forEach var="cat" items="${categories}">
                                    <c:if test="${cat.slug == 'thuc-pham-chuc-nang' || cat.categoryName == 'THỰC PHẨM CHỨC NĂNG' || cat.slug == 'cham-soc-suc-khoe'}">
                                        <c:set var="stopRender" value="true" scope="page" />
                                    </c:if>

                                    <c:if test="${not stopRender}">
                                        <c:set var="catProducts" value="${categoryProducts[cat.categoryID]}" />
                                        <c:if test="${not empty catProducts}">
                                            <div class="dm-container">
                                                <div class="dm-head">
                                                    <h2>${cat.categoryName}</h2>
                                                    <a class="dm-viewall" href="catalog?cid=${cat.categoryID}">Xem tất
                                                        cả
                                                        &gt;</a>
                                                </div>

                                            <%-- Product Grid (Max 12) --%>
                                                <div class="dm-cats">
                                                    <c:forEach var="p" items="${catProducts}" end="11">
                                                        <a class="dm-cat" href="product-detail?id=${p.id}">
                                                            <img src="${p.img}" alt="${p.name}">
                                                            <span>${p.name}</span>
                                                        </a>
                                                    </c:forEach>
                                                </div>

                                                <div class="dm-subhead">
                                                    <h3>Sản phẩm nổi bật</h3>
                                                </div>

                                                <div class="dm-slider">
                                                    <button class="dm-nav dm-prev" aria-label="Trước">&#10094;</button>
                                                    <div class="dm-track" style="--ppv:5">
                                                        <c:forEach var="p" items="${catProducts}">
                                                            <a class="dm-card" href="product-detail?id=${p.id}">
                                                                <c:if test="${not empty p.badge}">
                                                                    <span
                                                                        class="badge ${p.badge.contains('%') ? 'badge--sale' : 'badge--gift'}">${p.badge}</span>
                                                                </c:if>
                                                                <div class="thumb"><img src="${p.img}" alt="${p.name}">
                                                                </div>
                                                                <div class="brand">${p.brand}</div>
                                                                <h4 class="name">${p.name}</h4>
                                                                <div class="price">
                                                                    <span class="new">
                                                                        <fmt:formatNumber value="${p.price}"
                                                                            type="currency" currencySymbol="đ" />
                                                                    </span>
                                                                    <c:if test="${p.oldPrice > p.price}">
                                                                        <span class="old">
                                                                            <fmt:formatNumber value="${p.oldPrice}"
                                                                                type="currency" currencySymbol="đ" />
                                                                        </span>
                                                                    </c:if>
                                                                </div>
                                                                <div class="rating">
                                                                    <span class="stars">
                                                                        <c:forEach begin="1"
                                                                            end="${p.rating.intValue()}">★
                                                                        </c:forEach>
                                                                        <c:if test="${p.rating % 1 != 0}">☆</c:if>
                                                                    </span>
                                                                    <span class="count">(${p.reviews})</span>
                                                                </div>
                                                            </a>
                                                        </c:forEach>
                                                    </div>
                                                    <button class="dm-nav dm-next" aria-label="Sau">&#10095;</button>
                                                </div>
                                            </div>
                                        </c:if>

                                    </c:if>
                                </c:forEach>
                        </section>

                        <jsp:include page="/style/footer/footer.jsp" />

                    </div> <!-- JS sẽ render vào đây -->
                    <script src="Home/Category/categories.js"></script>
                    <script src="style/header/header.js"></script>
                    <script src="style/footer/footer.js"></script>


            </body>

            </html>