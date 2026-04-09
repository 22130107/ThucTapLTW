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
                                            <c:choose>
                                                <c:when test="${category.slug == 'cham-soc-suc-khoe'}">
                                                    <a class="category-link"
                                                        href="${pageContext.request.contextPath}/booking">
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="category-link" href="catalog?cid=${category.categoryID}">
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="category-item">
                                                <img src="${category.image}" alt="${category.categoryName}">
                                                <span>${category.categoryName}</span>
                                            </div>
                                            </a>
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
                                    <c:if test="${cat.slug == 'thuc-pham-chuc-nang' || cat.categoryName == 'THỰC PHẨM CHỨC NĂNG'}">
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

                        <div class="content">
                            <section class="feature-strip">
                                <div class="feature">
                                    <img class="feature-icon" src="https://meta.vn/images/icons/dich-vu-uy-tin-icon.svg"
                                        alt="Uy tín">
                                    <span class="feature-text">Dịch vụ uy tín</span>
                                </div>

                                <div class="feature">
                                    <img class="feature-icon" src="https://meta.vn/images/icons/doi-tra-hang-icon.svg"
                                        alt="Đổi trả 7 ngày">
                                    <span class="feature-text">Đổi trả trong 7 ngày</span>
                                </div>

                                <div class="feature">
                                    <img class="feature-icon"
                                        src="https://meta.vn/images/icons/giao-hang-toan-quoc-icon.svg"
                                        alt="Giao toàn quốc">
                                    <span class="feature-text">Giao hàng toàn quốc</span>
                                </div>
                            </section>
                            <div class="ft-row ft-health">
                                <!-- Cột 1 -->
                                <div class="ft-col">
                                    <h4>Liên hệ & hỗ trợ</h4>
                                    <ul class="ft-list">
                                        <li class="ft-flag"><strong>Miền Bắc & Trung</strong></li>
                                        <li>Mua hàng: <a class="tel" href="tel:02435686969">(024) 3568 6969</a></li>
                                        <li>Bảo hành: <a class="tel" href="tel:02435681234">(024) 3568 1234</a></li>
                                        <li class="ft-flag"><strong>Miền Nam</strong></li>
                                        <li>Mua hàng: <a class="tel" href="tel:02838336666">(028) 3833 6666</a></li>
                                        <li>Bảo hành: <a class="tel" href="tel:02838331234">(028) 3833 1234</a></li>
                                        <li class="ft-time">
                                            <span>Thứ 2–Thứ 6: 8:00–17:30</span>
                                            <span>Thứ 7: 8:00–12:00</span>
                                        </li>

                                    </ul>
                                </div>

                                <!-- Cột 2 -->
                                <div class="ft-col">
                                    <h4>Hỗ trợ khách hàng</h4>
                                    <ul class="ft-links">
                                        <li><a href="#">Chính sách đổi trả & bảo hành</a></li>
                                        <li><a href="#">Hướng dẫn thanh toán</a></li>
                                        <li><a href="#">Chính sách giao hàng lạnh/nhanh</a></li>
                                        <li><a href="#">Hướng dẫn đặt hàng online</a></li>
                                        <li><a href="#">Bảo mật thông tin y tế</a></li>
                                    </ul>
                                </div>

                                <!-- Cột 3 -->
                                <div class="ft-col">
                                    <h4>Dịch vụ chuyên môn</h4>
                                    <ul class="ft-links">
                                        <li><a href="#">Hiệu chuẩn & kiểm định thiết bị</a></li>
                                        <li><a href="#">Tư vấn set-up phòng khám</a></li>
                                        <li><a href="#">Bảo trì – thay thế vật tư</a></li>
                                        <li><a href="#">Thuê thiết bị y tế</a></li>
                                    </ul>
                                </div>

                                <!-- Cột 4 -->
                                <div class="ft-col">
                                    <h4>Về MEDITECH</h4>
                                    <ul class="ft-links">
                                        <li><a href="#">Giới thiệu</a></li>
                                        <li><a href="#">Chứng nhận chất lượng</a></li>
                                        <li><a href="#">Tin tức – tuyển dụng</a></li>
                                        <li><a href="#">Liên hệ hợp tác</a></li>
                                    </ul>
                                </div>

                                <!-- Cột 5 -->
                                <div class="ft-col">
                                    <h4>Kết nối với chúng tôi</h4>
                                    <ul class="ft-social">
                                        <li><a href="#"><img src="https://meta.vn/images/icons/zalo.svg" alt="">Zalo</a>
                                        </li>
                                        <li><a href="#"><img src="https://meta.vn/images/icons/facebook-icon.svg"
                                                    alt="">Facebook</a></li>
                                        <li><a href="#"><img src="https://meta.vn/images/icons/youtube-icon.svg"
                                                    alt="">Youtube</a>
                                        </li>
                                        <li><a href="#"><img src="https://meta.vn/Data/2025/Thang06/tiktok-meta.svg"
                                                    alt="">Tiktok</a></li>
                                    </ul>
                                    <div class="ft-lang">
                                        <a href="#">VN</a> / <a href="#">EN</a>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div> <!-- JS sẽ render vào đây -->
                    <script src="Home/Category/categories.js"></script>
                    <script src="style/header/header.js"></script>
                    <script src="style/footer/footer.js"></script>


            </body>

            </html>