<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <title>Giỏ hàng - META</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Cart/cart.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
            </head>

            <body>
                <jsp:include page="/style/header/header.jsp" />

                <main class="cart-container">
                    <h1>Giỏ hàng</h1>

                    <div class="cart-grid">
                        <section class="cart-list">
                            <table class="cart-table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                        <th></th>
                                    </tr>
                                </thead>

                                <tbody id="cart-rows">
                                    <c:forEach var="item" items="${sessionScope.cart.data.values()}">
                                        <tr>
                                            <td>
                                                <div class="cart-item">
                                                    <img class="cart-thumb" src="${item.product.img}"
                                                        alt="${item.product.name}">
                                                    <div class="cart-name">${item.product.name}
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${item.product.price}" type="currency"
                                                    currencySymbol="đ" />
                                            </td>
                                            <td>
                                                <div class="qty-box">
                                                    <button type="button"
                                                        onclick="updateCart(${item.product.id}, ${item.quantity - 1})">−</button>
                                                    <input type="number" value="${item.quantity}" min="1"
                                                        onchange="updateCart(${item.product.id}, this.value)">
                                                    <button type="button"
                                                        onclick="updateCart(${item.product.id}, ${item.quantity + 1})">+</button>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                    currencySymbol="đ" />
                                            </td>
                                            <td>
                                                <button class="remove-btn" title="Xóa"
                                                    onclick="updateCart(${item.product.id}, 0)">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </section>

                        <aside class="cart-summary">
                            <h2>Thông tin đơn hàng</h2>
                            <div class="sum-row"><span>Tổng sản phẩm</span><strong
                                    id="sum-qty">${sessionScope.cart.totalQuantity}</strong></div>
                            <div class="sum-row"><span>Tạm tính</span><strong id="sum-price">
                                    <fmt:formatNumber value="${sessionScope.cart.totalPrice}" type="currency"
                                        currencySymbol="đ" />
                                </strong></div>
                            <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout"
                                id="btn-checkout">Tiến hành đặt
                                hàng</a>
                        </aside>
                    </div>
                </main>

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
                            <img class="feature-icon" src="https://meta.vn/images/icons/giao-hang-toan-quoc-icon.svg"
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
                                <li>Mua hàng: <a class="tel" href="tel:02435686969">(024) 3568
                                        6969</a></li>
                                <li>Bảo hành: <a class="tel" href="tel:02435681234">(024) 3568
                                        1234</a></li>
                                <li class="ft-flag"><strong>Miền Nam</strong></li>
                                <li>Mua hàng: <a class="tel" href="tel:02838336666">(028) 3833
                                        6666</a></li>
                                <li>Bảo hành: <a class="tel" href="tel:02838331234">(028) 3833
                                        1234</a></li>
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
                                <li><a href="#"><img src="https://meta.vn/images/icons/zalo.svg" alt="">Zalo</a></li>
                                <li><a href="#"><img src="https://meta.vn/images/icons/facebook-icon.svg"
                                            alt="">Facebook</a></li>
                                <li><a href="#"><img src="https://meta.vn/images/icons/youtube-icon.svg"
                                            alt="">Youtube</a></li>
                                <li><a href="#"><img src="https://meta.vn/Data/2025/Thang06/tiktok-meta.svg"
                                            alt="Tiktok">Tiktok</a>
                                </li>
                            </ul>
                            <div class="ft-lang">
                                <a href="#">VN</a> / <a href="#">EN</a>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/style/header/header.js"></script>
                <script src="${pageContext.request.contextPath}/style/footer/footer.js"></script>
                <script>
                    function updateCart(id, quantity) {
                        fetch('${pageContext.request.contextPath}/add-to-cart', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=update&id=' + id + '&quantity=' + quantity
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.status === 'success') {
                                    location.reload();
                                } else {
                                    alert(data.message);
                                }
                            });
                    }
                </script>
            </body>

            </html>