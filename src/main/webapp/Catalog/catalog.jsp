<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Catalog</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Catalog/catalog.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
            </head>

            <body>
                <jsp:include page="/style/header/header.jsp" />


                <div class="container">
                    <div class="page-header">
                        <div class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/index.html" class="home-link"><i
                                    class="fa-solid fa-house"></i></a>
                            <span class="chevron">›</span>
                            <span id="crumbCurrent">
                                <c:choose>
                                    <c:when test="${not empty currentCategory}">
                                        ${currentCategory.categoryName}
                                    </c:when>
                                    <c:otherwise>
                                        Tất cả sản phẩm
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="catalog-page">
                        <aside class="filter-sidebar" id="filterSidebar">
                            <section class="filter-block brand">
                                <h3 class="filter-title">Mặt Hàng</h3>
                                <div class="filter-list" id="brandList">
                                    <label class="chk"><input type="checkbox" name="brand" value="Reiwa"
                                            ${selectedBrands.contains("Reiwa") ? "checked" : "" }>
                                        <span>Reiwa</span></label>
                                    <label class="chk"><input type="checkbox" name="brand" value="Kakusan"
                                            ${selectedBrands.contains("Kakusan") ? "checked" : "" }>
                                        <span>Kakusan</span></label>
                                    <label class="chk"><input type="checkbox" name="brand" value="TouchBeauty"
                                            ${selectedBrands.contains("TouchBeauty") ? "checked" : "" }>
                                        <span>TouchBeauty</span></label>
                                    <label class="chk"><input type="checkbox" name="brand" value="ROAMAN"
                                            ${selectedBrands.contains("ROAMAN") ? "checked" : "" }>
                                        <span>ROAMAN</span></label>
                                    <label class="chk"><input type="checkbox" name="brand" value="Microfiber"
                                            ${selectedBrands.contains("Microfiber") ? "checked" : "" }>
                                        <span>Microfiber</span></label>
                                </div>
                            </section>

                            <section class="filter-block price">
                                <h3 class="filter-title">KHOẢNG GIÁ</h3>
                                <div class="filter-list" id="priceList">
                                    <label class="chk"><input type="radio" name="price" value="p1" ${selectedPrice=="p1"
                                            ? "checked" : "" }> <span>Dưới 2 triệu</span></label>
                                    <label class="chk"><input type="radio" name="price" value="p2" ${selectedPrice=="p2"
                                            ? "checked" : "" }> <span>2 triệu - Dưới 4 triệu</span></label>
                                    <label class="chk"><input type="radio" name="price" value="p3" ${selectedPrice=="p3"
                                            ? "checked" : "" }> <span>4 triệu - Dưới 6 triệu</span></label>
                                    <label class="chk"><input type="radio" name="price" value="p4" ${selectedPrice=="p4"
                                            ? "checked" : "" }> <span>6 triệu trở lên</span></label>
                                </div>
                            </section>
                        </aside>

                        <main class="catalog-main">
                            <div class="toolbar">
                                <div class="sort-bar" id="sortBar">
                                    <button
                                        class="sort-btn ${selectedSort == 'best' || empty selectedSort ? 'active' : ''}"
                                        data-sort="best">Bán chạy nhất</button>
                                    <button class="sort-btn ${selectedSort == 'priceAsc' ? 'active' : ''}"
                                        data-sort="priceAsc">Giá tăng dần</button>
                                    <button class="sort-btn ${selectedSort == 'priceDesc' ? 'active' : ''}"
                                        data-sort="priceDesc">Giá giảm dần</button>
                                    <button class="sort-btn ${selectedSort == 'newest' ? 'active' : ''}"
                                        data-sort="newest">Mới nhất</button>
                                </div>
                                <div class="result-counter" id="resultCounter">${products.size()} sản phẩm</div>
                            </div>

                            <div class="product-grid" id="productGrid">
                                <c:forEach var="p" items="${products}">
                                    <article class="p-card" data-id="${p.id}">
                                        <c:if test="${not empty p.badge}">
                                            <div class="p-badge">-${p.badge}</div>
                                        </c:if>
                                        <a class="p-thumb"
                                            href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                                            <img class="p-img" src="${p.img}" alt="${p.name}">
                                        </a>
                                        <h3 class="p-title"><a
                                                href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                                class="p-link">${p.name}</a></h3>
                                        <div class="p-rating">
                                            <span class="stars">
                                                <c:forEach begin="1" end="${p.rating.intValue()}">★</c:forEach>
                                                <c:if test="${p.rating % 1 != 0}">☆</c:if>
                                            </span>
                                            <span class="p-reviews">(${p.reviews})</span>
                                        </div>
                                        <div class="p-price">
                                            <span class="price-new">
                                                <fmt:formatNumber value="${p.price}" type="currency"
                                                    currencySymbol="đ" />
                                            </span>
                                            <c:if test="${p.oldPrice > p.price}">
                                                <s class="price-old">
                                                    <fmt:formatNumber value="${p.oldPrice}" type="currency"
                                                        currencySymbol="đ" />
                                                </s>
                                            </c:if>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                            class="p-buy">MUA NGAY</a>
                                    </article>
                                </c:forEach>
                            </div>
                        </main>
                    </div>

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
                                                alt="">Youtube</a></li>
                                    <li><a href="#"><img src="https://meta.vn/Data/2025/Thang06/tiktok-meta.svg"
                                                alt="">Tiktok</a></li>
                                </ul>
                                <div class="ft-lang">
                                    <a href="#">VN</a> / <a href="#">EN</a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        const updateURL = () => {
                            const currentParams = new URLSearchParams(window.location.search);
                            const params = new URLSearchParams();

                            if (currentParams.has('cid')) {
                                params.append('cid', currentParams.get('cid'));
                            }

                            // Brands
                            document.querySelectorAll("input[name='brand']:checked").forEach(cb => {
                                params.append("brand", cb.value);
                            });

                            // Price
                            const price = document.querySelector("input[name='price']:checked");
                            if (price) params.append("price", price.value);

                            // Sort
                            const activeSort = document.querySelector(".sort-btn.active");
                            if (activeSort) params.append("sort", activeSort.dataset.sort);

                            window.location.href = "${pageContext.request.contextPath}/catalog?" + params.toString();
                        };

                        // Event listeners for filters
                        document.querySelectorAll("input[name='brand'], input[name='price']").forEach(el => {
                            el.addEventListener("change", updateURL);
                        });

                        // Event listeners for sort buttons
                        document.querySelectorAll(".sort-btn").forEach(btn => {
                            btn.addEventListener("click", () => {
                                document.querySelectorAll(".sort-btn").forEach(b => b.classList.remove("active"));
                                btn.classList.add("active");
                                updateURL();
                            });
                        });
                    });
                </script>
                <script src="${pageContext.request.contextPath}/style/header/header.js"></script>
            </body>

            </html>