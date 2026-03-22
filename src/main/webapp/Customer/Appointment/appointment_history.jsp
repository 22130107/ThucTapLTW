<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch đặt khám</title>

    <link rel="stylesheet" href="${contextPath}/Customer/Appointment/appointment_history.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Customer/User_sidebar/user_sidebar.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<jsp:include page="/style/header/header.jsp"/>

<div class="user-container">

    <jsp:include page="/Customer/User_sidebar/user_sidebar.jsp"/>

    <main class="content">
        <section class="appointment-history">
            <h2 style="padding-bottom: 10px;">Xem đặt lịch khám</h2>

            <div class="tabs">
                <button class="tab active" onclick="filterApps('all', this)">Tất cả</button>
                <button class="tab" onclick="filterApps('New', this)">Chờ xác nhận</button>
                <button class="tab" onclick="filterApps('Confirmed', this)">Đã xác nhận</button>
                <button class="tab" onclick="filterApps('Completed', this)">Đã khám xong</button>
                <button class="tab" onclick="filterApps('Cancelled', this)">Đã hủy</button>
            </div>

            <div class="search-box">
                <input type="text" id="searchInput" onkeyup="searchApps()"
                       placeholder="Tìm theo mã lịch, tên dịch vụ..."/>
                <button class="search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>

            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="empty-state">
                        <img src="https://cdn-icons-png.flaticon.com/512/2907/2907150.png" alt="No Appointment"
                             width="100" style="opacity: 0.5;">
                        <p style="margin-top: 15px; color: #777;">Bạn chưa có lịch hẹn nào.</p>
                        <a href="${contextPath}/booking" class="btn-action" style="margin-top: 10px;">Đặt lịch ngay</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div id="appList">
                        <c:forEach var="app" items="${appointments}">
                            <div class="appointment-card" data-status="${app.status}">

                                <div class="app-header">
                                    <div>
                                        <span class="app-id">Lịch hẹn #${app.appointmentID}</span>
                                        <span class="app-date">
                                            <i class="fa-regular fa-clock"></i> ${app.formattedDateTime}
                                        </span>
                                    </div>
                                    <div class="status-badge status-${app.statusCssClass}">
                                            ${app.statusVietnamese}
                                    </div>
                                </div>

                                <div class="app-body">
                                    <div class="app-item">
                                        <div class="item-icon">
                                            <i class="fa-solid fa-user-doctor"></i>
                                        </div>

                                        <div class="item-info">
                                            <c:choose>
                                                <c:when test="${not empty app.productID and app.productID > 0}">
                                                    <a href="${contextPath}/product-detail?id=${app.productID}"
                                                       class="item-name search-target">
                                                            ${productNames[app.productID]}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="item-name search-target">Tư vấn sức khỏe tổng quát</span>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="item-detail">
                                                <i class="fa-solid fa-notes-medical"
                                                   style="width: 20px; color: #777;"></i>
                                                Hình thức: <b>${app.typeVietnamese}</b>
                                            </div>

                                            <div class="item-detail">
                                                <i class="fa-solid fa-location-dot"
                                                   style="width: 20px; color: #777;"></i>
                                                Địa điểm: ${empty app.address ? 'Tại phòng khám' : app.address}
                                            </div>

                                            <c:if test="${not empty app.adminNote}">
                                                <div class="item-note">
                                                    <i class="fa-solid fa-circle-info"></i> <b>Phản hồi từ
                                                    Admin:</b> ${app.adminNote}
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="app-footer">
                                    <c:if test="${app.status == 'NEW'}">
                                        <button onclick="confirmCancelApp(${app.appointmentID})"
                                                class="btn-action btn-cancel">
                                            Hủy lịch
                                        </button>
                                    </c:if>

                                    <c:if test="${app.status == 'COMPLETED' || app.status == 'CANCELLED'}">
                                        <a href="${contextPath}/booking?productId=${app.productID}" class="btn-action">
                                            <i class="fa-solid fa-rotate-right"></i> Đặt lại
                                        </a>
                                    </c:if>
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

<script>
    // 1. Tự động chuyển Tab nếu URL có ?tab=...
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const activeTab = urlParams.get('tab');
        if (activeTab) {

            let buttons = document.querySelectorAll('.tab');
            buttons.forEach(btn => {
                if (btn.getAttribute('onclick').toLowerCase().includes(activeTab.toLowerCase())) {
                    filterApps(activeTab, btn);
                }
            });
        }
    });

    // 2. Hàm lọc Tab
    function filterApps(statusType, btnElement) {
        // Đổi active tab
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        if (btnElement) btnElement.classList.add('active');

        // Lọc cards
        let cards = document.querySelectorAll('.appointment-card');

        cards.forEach(card => {
            // Lấy status từ data attribute
            let cardStatus = card.getAttribute('data-status');

            // Chuyển cả 2 về chữ IN HOA để so sánh (Khắc phục lỗi New vs NEW)
            // Kiểm tra null để tránh lỗi nếu dữ liệu bị thiếu
            if (cardStatus && statusType) {
                if (statusType === 'all' || cardStatus.toUpperCase() === statusType.toUpperCase()) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            }
        });
    }

    // 3. Hàm Tìm kiếm
    function searchApps() {
        let input = document.getElementById('searchInput').value.toLowerCase();
        let cards = document.querySelectorAll('.appointment-card');

        cards.forEach(card => {
            let idText = card.querySelector('.app-id').innerText.toLowerCase();
            let nameText = card.querySelector('.search-target').innerText.toLowerCase();

            if (idText.includes(input) || nameText.includes(input)) {
                card.classList.remove('hidden');
                card.style.display = 'block'; // Reset display
            } else {
                card.classList.add('hidden');
                card.style.display = 'none';
            }
        });
    }

    // 4. Hàm Hủy lịch hẹn
    function confirmCancelApp(appId) {
        if (confirm("Bạn có chắc chắn muốn hủy lịch hẹn #" + appId + " không?")) {
            // Bạn cần tạo Servlet CancelAppointmentController để xử lý URL này
            window.location.href = "${contextPath}/cancel-appointment?id=" + appId;
        }
    }
</script>

</body>
</html>