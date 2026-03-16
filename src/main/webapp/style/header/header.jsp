<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <header class="site-header">
                <div class="header-left">
                    <input type="checkbox" id="nav-toggle" hidden>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">HKH</a>
                </div>

                <form class="searchbar" action="${pageContext.request.contextPath}/catalog" method="get">
                    <input type="text" name="q" placeholder="Tìm kiếm?" />
                    <button type="submit">Tìm kiếm</button>
                </form>

                <div class="header-right">
                    <!-- CART WRAP để hover -->
                    <div class="cart-wrap">
                        <a class="topbtn cart-btn" href="${pageContext.request.contextPath}/cart">
                            <i class="fa-solid fa-cart-shopping"></i>
                            Giỏ Hàng <span class="cart-badge" aria-label="Số lượng">${sessionScope.cart.totalQuantity !=
                                null ? sessionScope.cart.totalQuantity : 0}</span>
                        </a>
                        <!-- MINI-CART DROPDOWN -->
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
                                <a class="mini-cart-view" href="${pageContext.request.contextPath}/cart">Xem
                                    Giỏ
                                    Hàng</a>
                            </div>
                        </div>
                    </div>

                    <a class="topbtn" href="#"><i class="fa-solid fa-phone"> </i>Hotline</a>

                    <c:choose>
                        <c:when test="${sessionScope.auth != null}">
                            <a class="topbtn" href="${pageContext.request.contextPath}/update-profile"><i
                                    class="fa-solid fa-user"> </i>${sessionScope.auth.username}</a>
                        </c:when>

                        <c:otherwise>
                            <a class="topbtn" href="${pageContext.request.contextPath}/login"><i
                                    class="fa-solid fa-user"> </i>Đăng Nhập </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </header>