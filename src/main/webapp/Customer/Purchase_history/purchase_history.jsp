<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- Lấy đối tượng User và Customer từ Session --%>
<c:set var="user" value="${sessionScope.auth}"/>
<c:set var="customer" value="${sessionScope.customer}"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Lịch sử mua hàng</title>

    <link rel="stylesheet" href="${contextPath}/Customer/Purchase_history/purchase_history.css"/>
    <link rel="stylesheet" href="${contextPath}/style/header/header.css"/>
    <link rel="stylesheet" href="${contextPath}/Customer/User_sidebar/user_sidebar.css"/>
    <link rel="stylesheet" href="${contextPath}/style/footer/footer.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        /* CSS BỔ SUNG */
        .order-card {
            border: 1px solid #ddd;
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 8px;
            background: white;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            background: #f9f9f9;
            padding: 10px;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
        }

        .order-item {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            align-items: center;
            border-bottom: 1px dashed #eee;
            padding-bottom: 10px;
        }

        .item-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border: 1px solid #eee;
        }

        /* Màu trạng thái (Giữ tên class tiếng Anh để map với Database) */
        .status-Pending {
            color: #f39c12;
            font-weight: bold;
        }

        /* Cam */
        .status-Processing {
            color: #3498db;
            font-weight: bold;
        }

        /* Xanh dương */
        .status-Shipping {
            color: #17a2b8;
            font-weight: bold;
        }

        /* Xanh ngọc */
        .status-Completed {
            color: #2ecc71;
            font-weight: bold;
        }

        /* Xanh lá */
        .status-Cancelled {
            color: #e74c3c;
            font-weight: bold;
        }

        /* Đỏ */

        .item-info {
            flex-grow: 1;
        }

        .hidden {
            display: none !important;
        }
    </style>
</head>

<body>
<jsp:include page="/style/header/header.jsp"/>

<div class="user-container">

    <jsp:include page="/Customer/User_sidebar/user_sidebar.jsp"/>

    <main class="content">
        <section class="order-history">
            <h2 style="padding-bottom: 10px;">Lịch sử đơn hàng</h2>

            <div class="tabs">
                <button class="tab active" onclick="filterOrders('all', this)">Tất cả</button>
                <button class="tab" onclick="filterOrders('Pending', this)">Chờ xác nhận</button>
                <button class="tab" onclick="filterOrders('Processing', this)">Đã xác nhận</button>
                <button class="tab" onclick="filterOrders('Shipping', this)">Đang giao</button>
                <button class="tab" onclick="filterOrders('Completed', this)">Đã giao</button>
                <button class="tab" onclick="filterOrders('Cancelled', this)">Đã hủy</button>
            </div>

            <div class="search-box">
                <input type="text" id="searchInput" onkeyup="searchOrders()"
                       placeholder="Tìm theo mã đơn hàng, tên sản phẩm..."/>
                <button class="search-btn" onclick="searchOrders()"><i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state">
                        <img src="https://cdn-icons-png.flaticon.com/512/1170/1170678.png" alt="No Orders"/>
                        <p>Chưa có đơn hàng nào</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div id="orderList">
                        <c:forEach var="order" items="${orders}">

                            <div class="order-card" data-status="${order.status}">

                                <div class="order-header">
                                    <div>
                                        <b class="order-id-text">Đơn hàng #${order.orderId}</b>
                                        <span style="font-size: 0.9em; color: #666; margin-left: 10px;">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                    </div>

                                    <div class="status-${order.status}">
                                        <c:choose>
                                            <c:when test="${order.status == 'Pending'}">Chờ xác nhận</c:when>
                                            <c:when test="${order.status == 'Processing'}">Đã xác nhận</c:when>
                                            <c:when test="${order.status == 'Shipping'}">Đang giao hàng</c:when>
                                            <c:when test="${order.status == 'Completed'}">Giao thành công</c:when>
                                            <c:when test="${order.status == 'Cancelled'}">Đã hủy</c:when>
                                            <c:otherwise>${order.status}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <c:forEach var="item" items="${orderItemsMap[order.orderId]}">
                                    <c:set var="product" value="${productsMap[item.productId]}"/>

                                    <div class="order-item">
                                        <img src="${product.img}" alt="${product.name}" class="item-img"
                                             onerror="this.src='https://placehold.co/70x70?text=No+Image'">

                                        <div class="item-info">
                                            <div class="search-target"><b>${product.name}</b></div>
                                            <div>
                                                SL: ${item.quantity} x
                                                <span style="color: #d70018;">
                                                <fmt:formatNumber value="${item.priceAtOrder}" type="currency"
                                                                  currencySymbol="₫"/>
                                            </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 10px; padding-top: 10px; border-top: 1px solid #eee;">
                                    <div style="font-size: 0.9em; color: #555;">
                                        <i class="fa-solid fa-location-dot"></i> ${order.shippingAddress}
                                    </div>
                                    <div style="text-align: right;">
                                        Tổng tiền:
                                        <span style="font-size: 1.2em; color: #d70018; font-weight: bold;">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                          currencySymbol="₫"/>
                                    </span>

                                        <c:if test="${order.status == 'Pending'}">
                                            <div style="margin-top: 10px;">
                                                <button onclick="confirmCancelOrder(${order.orderId})"
                                                        style="background: #fff; border: 1px solid #d32f2f; color: #d32f2f; padding: 5px 10px; border-radius: 4px; cursor: pointer;">
                                                    Hủy đơn
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>
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

<%--<jsp:include page="/style/footer/footer.jsp"/>--%>
<%-- Hiển thị thông báo Toast --%>
<c:if test="${not empty sessionScope.toastSuccess}">
    <div id="toast-msg"
         style="position: fixed; top: 20px; right: 20px; z-index: 9999; background: #d4edda; color: #155724; padding: 15px 20px; border-radius: 5px; border-left: 5px solid #28a745; box-shadow: 0 4px 6px rgba(0,0,0,0.1); animation: slideIn 0.5s ease-out;">
        <i class="fa-solid fa-circle-check"></i> <strong>Thành công!</strong> ${sessionScope.toastSuccess}
    </div>
    <%-- Xóa session sau khi hiện để không hiện lại khi reload --%>
    <c:remove var="toastSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.toastError}">
    <div id="toast-msg"
         style="position: fixed; top: 20px; right: 20px; z-index: 9999; background: #f8d7da; color: #721c24; padding: 15px 20px; border-radius: 5px; border-left: 5px solid #dc3545; box-shadow: 0 4px 6px rgba(0,0,0,0.1); animation: slideIn 0.5s ease-out;">
        <i class="fa-solid fa-circle-exclamation"></i> <strong>Lỗi!</strong> ${sessionScope.toastError}
    </div>
    <c:remove var="toastError" scope="session"/>
</c:if>

<style>
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
</style>

<script>
    // Tự động ẩn thông báo sau 3 giây
    setTimeout(function () {
        let toast = document.getElementById('toast-msg');
        if (toast) {
            toast.style.transition = "opacity 0.5s ease";
            toast.style.opacity = "0";
            setTimeout(() => toast.remove(), 500);
        }
    }, 3000);
</script>

<script>
    // 1. Tự động chuyển Tab nếu URL có ?tab=...
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const activeTab = urlParams.get('tab'); // Ví dụ: Cancelled

        if (activeTab) {
            let buttons = document.querySelectorAll('.tab');
            buttons.forEach(btn => {
                // Lấy chuỗi trong onclick, ví dụ: "filterOrders('Cancelled', this)"
                let onClickText = btn.getAttribute('onclick').toLowerCase();

                // So sánh đơn giản hơn: chỉ cần chứa từ khóa status là được
                if (onClickText.includes(activeTab.toLowerCase())) {
                    filterOrders(activeTab, btn);
                }
            });
        }
    });

    // 2. Hàm lọc Tab
    function filterOrders(statusType, btnElement) {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        if (btnElement) btnElement.classList.add('active');

        let cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            // Lấy status GỐC (Tiếng Anh) từ data-status
            let cardStatus = card.getAttribute('data-status');

            if (statusType === 'all' ||
                (cardStatus && cardStatus.toUpperCase() === statusType.toUpperCase())) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    // 3. Hàm Tìm kiếm
    function searchOrders() {
        let input = document.getElementById('searchInput').value.toLowerCase();
        let cards = document.querySelectorAll('.order-card');

        cards.forEach(card => {
            let idEl = card.querySelector('.order-id-text');
            let idText = idEl ? idEl.innerText.toLowerCase() : "";

            let hasProduct = false;
            let productNames = card.querySelectorAll('.search-target');
            productNames.forEach(name => {
                if (name.innerText.toLowerCase().includes(input)) hasProduct = true;
            });

            if (idText.includes(input) || hasProduct) {
                card.classList.remove('hidden');
                if (card.style.display !== 'none') card.style.display = 'block';
            } else {
                card.classList.add('hidden');
            }
        });
    }

    // 4. Hàm Hủy Đơn Hàng
    function confirmCancelOrder(orderId) {
        if (confirm("Bạn có chắc chắn muốn hủy đơn hàng #" + orderId + " không?")) {
            window.location.href = "${contextPath}/cancel-order?id=" + orderId;
        }
    }
</script>
</body>
</html>