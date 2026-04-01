<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <header class="site-header">
                <div class="header-top">
                    <div class="container header-top-inner">
                        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-block" aria-label="Trang chủ">
                            <span class="logo-mark"><i class="fa-solid fa-heart-pulse"></i></span>
                            <span class="logo-text-wrap">
                                <span class="logo-main">THIET BI Y TE 24H</span>
                                <span class="logo-sub">Thiết bị y tế chính hãng</span>
                            </span>
                        </a>

                        <form class="searchbar" action="${pageContext.request.contextPath}/catalog" method="get">
                            <input type="text" name="q" placeholder="Nhập sản phẩm cần tìm" />
                            <button type="submit">Tìm kiếm</button>
                        </form>

                        <div class="header-contact">
                            <a class="contact-item" href="tel:0888999406">
                                <i class="fa-solid fa-phone-volume"></i>
                                <span class="contact-text">
                                    <span>Hotline mua hàng</span>
                                    <strong>0888.999.406</strong>
                                </span>
                            </a>
                            <a class="contact-item" href="tel:0888999406">
                                <i class="fa-solid fa-user-nurse"></i>
                                <span class="contact-text">
                                    <span>Tư vấn miễn phí</span>
                                    <strong>0888.999.406</strong>
                                </span>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${sessionScope.auth != null}">
                                <a class="account-link" href="${pageContext.request.contextPath}/update-profile">
                                    <i class="fa-solid fa-user"></i>
                                    ${sessionScope.auth.username}
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="account-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fa-solid fa-user"></i>
                                    Đăng nhập
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="header-nav-wrap">
                    <div class="container header-nav-inner">
                        <a class="menu-trigger" href="${pageContext.request.contextPath}/index.jsp">
                            <i class="fa-solid fa-bars"></i>
                            DANH MỤC SẢN PHẨM
                        </a>

                        <nav class="nav-links" aria-label="Điều hướng chính">
                            <a href="${pageContext.request.contextPath}/index.jsp">TRANG CHỦ</a>
                            <a href="#">GIỚI THIỆU</a>
                            <a href="${pageContext.request.contextPath}/catalog">SẢN PHẨM</a>
                            <a href="#">TIN TỨC</a>
                            <a href="#">LIÊN HỆ</a>
                        </nav>

                        <div class="cart-wrap">
                            <a class="cart-btn nav-cart-btn" href="${pageContext.request.contextPath}/cart">
                                <i class="fa-solid fa-cart-shopping"></i>
                                GIỎ HÀNG
                                <span class="cart-badge" aria-label="Số lượng">${sessionScope.cart.totalQuantity !=
                                    null ? sessionScope.cart.totalQuantity : 0}</span>
                            </a>

                            <div class="mini-cart" role="dialog" aria-label="Sản phẩm mới thêm">
                                <ul class="mini-cart-list" id="mini-cart-list">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.cart.data}">
                                            <c:forEach var="item" items="${sessionScope.cart.data.values()}">
                                                <li class="mini-cart-item">
                                                    <img src="${item.product.img}" alt="${item.product.name}"
                                                        class="mini-cart-thumb">
                                                    <div class="mini-cart-info">
                                                        <div class="mini-cart-title">${item.product.name}</div>
                                                        <div class="mini-cart-meta">
                                                            <span class="qty">${item.quantity} x</span>
                                                            <span class="mini-cart-price">
                                                                <fmt:formatNumber value="${item.product.price}"
                                                                    type="currency" currencySymbol="đ" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="mini-cart-price">
                                                        <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                            currencySymbol="đ" />
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="mini-cart-item" style="justify-content: center;">
                                                <span>Giỏ hàng trống</span>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                                <div class="mini-cart-footer">
                                    <div class="mini-cart-total">
                                        <span>Tổng:</span>
                                        <strong id="mini-cart-total">
                                            <fmt:formatNumber
                                                value="${sessionScope.cart.totalPrice != null ? sessionScope.cart.totalPrice : 0}"
                                                type="currency" currencySymbol="đ" />
                                        </strong>
                                    </div>
                                    <a class="mini-cart-view" href="${pageContext.request.contextPath}/cart">Xem giỏ
                                        hàng</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>