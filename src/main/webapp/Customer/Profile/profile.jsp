<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <%-- Lấy dữ liệu từ Session --%>
                    <c:set var="user" value="${sessionScope.auth}" />
                    <c:set var="customer" value="${sessionScope.customer}" />

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Thông tin tài khoản - ${user.username}</title>

                        <%-- CSS riêng của trang Profile --%>
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/Customer/Profile/profile.css">

                            <%-- CSS của các thành phần chung (Header, Footer, Sidebar) --%>
                                <link rel="stylesheet"
                                    href="${pageContext.request.contextPath}/style/header/header.css" />
                                <link rel="stylesheet"
                                    href="${pageContext.request.contextPath}/Customer/User_sidebar/user_sidebar.css">
                                <link rel="stylesheet"
                                    href="${pageContext.request.contextPath}/style/footer/footer.css" />

                                <link rel="stylesheet"
                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

                                <style>
                                    /* --- CSS CHO TRANG PROFILE --- */
                                    * {
                                        margin: 0;
                                        padding: 0;
                                        box-sizing: border-box;
                                        font-family: 'Roboto', Arial, sans-serif;
                                    }

                                    .container {
                                        display: flex;
                                        width: 100%;
                                        min-height: calc(100vh - 70px);
                                        gap: 15px;
                                        padding: 35px 140px 8px;
                                        background-color: #f8f8f8;
                                    }

                                    .profile {
                                        flex: 1;
                                        background: white;
                                    }

                                    .profile-header {
                                        margin-bottom: 30px;
                                        padding: 30px;
                                        text-align: center;
                                    }

                                    .avatar-large {
                                        width: 100px;
                                        height: 100px;
                                        background-color: #bb5e41;
                                        color: white;
                                        border-radius: 50%;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        font-size: 36px;
                                        margin: 0 auto 10px;
                                    }

                                    .change-avatar {
                                        background: none;
                                        border: none;
                                        color: #0a66c2;
                                        cursor: pointer;
                                        font-size: 14px;
                                    }

                                    .info-table {
                                        width: 100%;
                                        padding: 0 190px;
                                    }

                                    .info-row {
                                        display: grid;
                                        grid-template-columns: 200px 1fr 100px;
                                        padding: 16px 0;
                                        border-bottom: 1px solid #eee;
                                        align-items: center;
                                        text-align: left;
                                    }

                                    .info-row.editable {
                                        border-bottom: 1px solid #ddd;
                                    }

                                    .label {
                                        color: #555;
                                        font-size: 15px;
                                    }

                                    .value {
                                        font-size: 15px;
                                    }

                                    .info-row input.value {
                                        width: 100%;
                                        padding: 8px 10px;
                                        border: 1px solid #ccc;
                                        border-radius: 4px;
                                        font-size: 15px;
                                    }

                                    .info-row input.value:focus {
                                        border-color: #0a66c2;
                                        outline: none;
                                    }

                                    .action,
                                    .info-row button.action {
                                        color: #0a66c2;
                                        font-size: 15px;
                                        cursor: pointer;
                                        justify-self: end;
                                        background: none;
                                        border: none;
                                        padding: 0;
                                        text-decoration: none;
                                    }

                                    .info-row button.action {
                                        color: white;
                                        background-color: #0a66c2;
                                        padding: 8px 15px;
                                        border-radius: 4px;
                                        font-weight: bold;
                                        text-transform: uppercase;
                                    }

                                    .info-row button.action:hover {
                                        background-color: #084c98;
                                    }

                                    .verified {
                                        color: #2ecc71;
                                        margin-left: 5px;
                                    }

                                    /* --- 🔴 CSS CHO MODAL (POPUP) --- */
                                    /* Lớp nền mờ che phủ toàn màn hình */
                                    .modal {
                                        display: none;
                                        /* Mặc định ẩn */
                                        position: fixed;
                                        /* Cố định vị trí so với màn hình */
                                        z-index: 9999;
                                        /* Luôn nổi lên trên cùng */
                                        left: 0;
                                        top: 0;
                                        width: 100%;
                                        height: 100%;
                                        overflow: auto;
                                        /* Cho phép cuộn nếu modal quá dài */
                                        background-color: rgba(0, 0, 0, 0.5);
                                        /* Màu đen mờ 50% */
                                    }

                                    /* Hộp nội dung Modal */
                                    .modal-content {
                                        background-color: #fefefe;
                                        margin: 10% auto;
                                        /* Cách trên 10% và căn giữa ngang */
                                        padding: 25px;
                                        border: 1px solid #888;
                                        width: 400px;
                                        /* Chiều rộng cố định */
                                        border-radius: 8px;
                                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                                        animation: slideDown 0.3s;
                                        position: relative;
                                    }

                                    /* Nút tắt (x) */
                                    .close {
                                        color: #aaa;
                                        float: right;
                                        font-size: 28px;
                                        font-weight: bold;
                                        cursor: pointer;
                                    }

                                    .close:hover {
                                        color: black;
                                    }

                                    /* Form bên trong Modal */
                                    .modal h3 {
                                        text-align: center;
                                        margin-bottom: 20px;
                                        color: #333;
                                    }

                                    .form-group {
                                        margin-bottom: 15px;
                                    }

                                    .form-group label {
                                        display: block;
                                        margin-bottom: 5px;
                                        font-weight: 500;
                                        font-size: 14px;
                                    }

                                    .form-group input {
                                        width: 100%;
                                        padding: 10px;
                                        border: 1px solid #ccc;
                                        border-radius: 4px;
                                    }

                                    .btn-save-pass {
                                        width: 100%;
                                        padding: 10px;
                                        background-color: #0a66c2;
                                        color: white;
                                        border: none;
                                        border-radius: 4px;
                                        cursor: pointer;
                                        font-weight: bold;
                                        margin-top: 10px;
                                    }

                                    .btn-save-pass:hover {
                                        background-color: #084c98;
                                    }

                                    @keyframes slideDown {
                                        from {
                                            transform: translateY(-50px);
                                            opacity: 0;
                                        }

                                        to {
                                            transform: translateY(0);
                                            opacity: 1;
                                        }
                                    }
                                </style>
                    </head>

                    <body>

                        <%-- 1. Kiểm tra đăng nhập --%>
                            <c:if test="${empty user}">
                                <c:redirect url="${pageContext.request.contextPath}/login" />
                            </c:if>

                            <%-- 2. NHÚNG HEADER --%>
                                <%-- Giả sử file header.jsp nằm ở thư mục gốc (webapp/header.jsp) --%>
                                    <%-- Nếu file nằm ở thư mục khác, hãy sửa đường dẫn bên dưới (VD:
                                        /includes/header.jsp) --%>
                                        <jsp:include page="/style/header/header.jsp" />

                                        <main class="container">

                                            <%-- 3. NHÚNG SIDEBAR --%>
                                                <%-- File này nằm ở thư mục webapp/User_sidebar/user_sidebar.jsp --%>
                                                    <jsp:include page="/Customer/User_sidebar/user_sidebar.jsp" />

                                                    <%-- 4. NỘI DUNG CHÍNH (FORM PROFILE) --%>
                                                        <section class="profile">

                                                            <%-- Hiển thị thông báo (1s mờ dần) --%>
                                                                <c:if test="${not empty message}">
                                                                    <%-- Thêm id="success-alert" và class transition để
                                                                        làm hiệu ứng mờ dần --%>
                                                                        <div id="success-alert"
                                                                            style="color: green; padding: 10px; border: 1px solid green; margin-bottom: 20px; transition: opacity 0.5s ease;">
                                                                            ${message}
                                                                        </div>
                                                                        <c:remove var="message" scope="session" />
                                                                        <c:remove var="message" scope="request" />
                                                                </c:if>

                                                                <c:if test="${not empty error}">
                                                                    <div
                                                                        style="color: red; padding: 10px; border: 1px solid red; margin-bottom: 20px;">
                                                                        ${error}
                                                                    </div>
                                                                    <c:remove var="message" scope="session" />
                                                                    <c:remove var="message" scope="request" />
                                                                </c:if>

                                                                <%-- &lt;%&ndash; Hiển thị thông báo cũ &ndash;%&gt;--%>
                                                                    <%-- <c:if test="${not empty message}">--%>
                                                                        <%-- <div
                                                                            style="color: green; padding: 10px; border: 1px solid green; margin-bottom: 20px;">--%>
                                                                            <%-- ${message}--%>
                                                                                <%-- </div>--%>
                                                                                    <%-- </c:if>--%>
                                                                                        <%-- <c:if
                                                                                            test="${not empty error}">--%>
                                                                                            <%-- <div
                                                                                                style="color: red; padding: 10px; border: 1px solid red; margin-bottom: 20px;">--%>
                                                                                                <%-- ${error}--%>
                                                                                                    <%-- </div>--%>
                                                                                                        <%-- </c:if>--%>

                                                                                                            <div
                                                                                                                class="profile-header">
                                                                                                                <%-- Avatar
                                                                                                                    chữ
                                                                                                                    cái
                                                                                                                    đầu
                                                                                                                    --%>
                                                                                                                    <div
                                                                                                                        class="avatar-large">
                                                                                                                        ${fn:substring(user.username,
                                                                                                                        0,
                                                                                                                        1)}
                                                                                                                    </div>
                                                                                                                    <button
                                                                                                                        class="change-avatar">Thay
                                                                                                                        ảnh</button>

                                                                                                                    <%-- BUTTON
                                                                                                                        ADMIN
                                                                                                                        PANEL
                                                                                                                        (Only
                                                                                                                        for
                                                                                                                        Admin)
                                                                                                                        --%>
                                                                                                                        <c:if
                                                                                                                            test="${user.role == 'Admin' || user.role == 'Manager'}">
                                                                                                                            <div
                                                                                                                                style="margin-top: 15px;">
                                                                                                                                <a href="${pageContext.request.contextPath}/admin/overview"
                                                                                                                                    style="display: inline-block; background-color: #cc2121; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; font-family: sans-serif;">
                                                                                                                                    <i
                                                                                                                                        class="fa fa-user-shield"></i>
                                                                                                                                    Trang
                                                                                                                                    Quản
                                                                                                                                    Trị
                                                                                                                                </a>
                                                                                                                            </div>
                                                                                                                        </c:if>
                                                                                                            </div>

                                                                                                            <div
                                                                                                                class="info-table">
                                                                                                                <div
                                                                                                                    class="info-row">
                                                                                                                    <span
                                                                                                                        class="label">Tên
                                                                                                                        đăng
                                                                                                                        nhập</span>
                                                                                                                    <span
                                                                                                                        class="value">${user.username}</span>
                                                                                                                </div>

                                                                                                                <div
                                                                                                                    class="info-row">
                                                                                                                    <span
                                                                                                                        class="label">Email</span>
                                                                                                                    <span
                                                                                                                        class="value">${user.email}
                                                                                                                        <i
                                                                                                                            class="fa fa-check verified"></i></span>
                                                                                                                    <a class="action"
                                                                                                                        href="#">Sửa</a>
                                                                                                                </div>

                                                                                                                <%-- FORM
                                                                                                                    CẬP
                                                                                                                    NHẬT
                                                                                                                    --%>
                                                                                                                    <form
                                                                                                                        action="${pageContext.request.contextPath}/update-profile"
                                                                                                                        method="post">

                                                                                                                        <%-- 1.
                                                                                                                            HỌ
                                                                                                                            TÊN:
                                                                                                                            Thêm
                                                                                                                            required
                                                                                                                            --%>
                                                                                                                            <div
                                                                                                                                class="info-row editable">
                                                                                                                                <span
                                                                                                                                    class="label">Họ
                                                                                                                                    tên</span>
                                                                                                                                <input
                                                                                                                                    type="text"
                                                                                                                                    name="fullName"
                                                                                                                                    class="value"
                                                                                                                                    value="${customer.fullName}"
                                                                                                                                    placeholder="Cập nhật họ tên"
                                                                                                                                    required
                                                                                                                                    title="Họ tên không được để trống">
                                                                                                                                <button
                                                                                                                                    type="submit"
                                                                                                                                    class="action">Lưu</button>
                                                                                                                            </div>

                                                                                                                            <%-- 2.
                                                                                                                                ĐIỆN
                                                                                                                                THOẠI:
                                                                                                                                Thêm
                                                                                                                                required
                                                                                                                                +
                                                                                                                                pattern
                                                                                                                                số
                                                                                                                                --%>
                                                                                                                                <div
                                                                                                                                    class="info-row editable">
                                                                                                                                    <span
                                                                                                                                        class="label">Điện
                                                                                                                                        thoại</span>
                                                                                                                                    <input
                                                                                                                                        type="text"
                                                                                                                                        name="phone"
                                                                                                                                        class="value"
                                                                                                                                        value="${customer.phoneNumber}"
                                                                                                                                        placeholder="Cập nhật số điện thoại"
                                                                                                                                        required
                                                                                                                                        pattern="[0-9]{10,11}"
                                                                                                                                        title="Số điện thoại phải là số và có 10-11 chữ số">
                                                                                                                                    <button
                                                                                                                                        type="submit"
                                                                                                                                        class="action">Lưu</button>
                                                                                                                                </div>

                                                                                                                                <%-- 3.
                                                                                                                                    ĐỊA
                                                                                                                                    CHỈ:
                                                                                                                                    Thêm
                                                                                                                                    required
                                                                                                                                    --%>
                                                                                                                                    <div
                                                                                                                                        class="info-row editable">
                                                                                                                                        <span
                                                                                                                                            class="label">Địa
                                                                                                                                            chỉ</span>
                                                                                                                                        <input
                                                                                                                                            type="text"
                                                                                                                                            name="address"
                                                                                                                                            class="value"
                                                                                                                                            value="${customer.address}"
                                                                                                                                            placeholder="Cập nhật địa chỉ"
                                                                                                                                            required
                                                                                                                                            title="Địa chỉ không được để trống">
                                                                                                                                        <button
                                                                                                                                            type="submit"
                                                                                                                                            class="action">Lưu</button>
                                                                                                                                    </div>
                                                                                                                    </form>

                                                                                                                    <div
                                                                                                                        class="info-row">
                                                                                                                        <span
                                                                                                                            class="label">Mật
                                                                                                                            khẩu</span>
                                                                                                                        <span
                                                                                                                            class="value">*****</span>
                                                                                                                        <%-- CẬP
                                                                                                                            NHẬT:
                                                                                                                            THÊM
                                                                                                                            SỰ
                                                                                                                            KIỆN
                                                                                                                            ONCLICK
                                                                                                                            MỞ
                                                                                                                            MODAL
                                                                                                                            --%>
                                                                                                                            <%-- Thêm 'event'
                                                                                                                                vào
                                                                                                                                openModal(event)
                                                                                                                                để
                                                                                                                                chặn
                                                                                                                                hành
                                                                                                                                vi
                                                                                                                                load
                                                                                                                                lại
                                                                                                                                trang
                                                                                                                                --%>
                                                                                                                                <a class="action"
                                                                                                                                    href="#"
                                                                                                                                    onclick="openModal(event)">Đổi
                                                                                                                                    mật
                                                                                                                                    khẩu</a>
                                                                                                                    </div>

                                                                                                                    <%-- <div
                                                                                                                        class="info-row">--%>
                                                                                                                        <%-- <span
                                                                                                                            class="label">Vô
                                                                                                                            hiệu
                                                                                                                            hóa
                                                                                                                            và
                                                                                                                            xóa</span>--%>
                                                                                                                            <%-- <span
                                                                                                                                class="value long-text">Vô
                                                                                                                                hiệu
                                                                                                                                hóa
                                                                                                                                tạm
                                                                                                                                thời
                                                                                                                                hoặc
                                                                                                                                xóa
                                                                                                                                vĩnh
                                                                                                                                viễn
                                                                                                                                tài
                                                                                                                                khoản.</span>--%>
                                                                                                                                <%-- <a
                                                                                                                                    class="action"
                                                                                                                                    href="#">Xem</a>--%>
                                                                                                                                    <%--
                                                                                                                                        </div>--%>
                                                                                                            </div>

                                                        </section>

                                        </main>

                                        <div class="content">
                                            <section class="feature-strip">
                                                <div class="feature">
                                                    <img class="feature-icon"
                                                        src="https://meta.vn/images/icons/dich-vu-uy-tin-icon.svg"
                                                        alt="Uy tín">
                                                    <span class="feature-text">Dịch vụ uy tín</span>
                                                </div>

                                                <div class="feature">
                                                    <img class="feature-icon"
                                                        src="https://meta.vn/images/icons/doi-tra-hang-icon.svg"
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
                                                        <li><a href="#"><img src="https://meta.vn/images/icons/zalo.svg"
                                                                    alt="">Zalo</a>
                                                        </li>
                                                        <li><a href="#"><img
                                                                    src="https://meta.vn/images/icons/facebook-icon.svg"
                                                                    alt="">Facebook</a></li>
                                                        <li><a href="#"><img
                                                                    src="https://meta.vn/images/icons/youtube-icon.svg"
                                                                    alt="">Youtube</a></li>
                                                        <li><a href="#"><img
                                                                    src="https://meta.vn/Data/2025/Thang06/tiktok-meta.svg"
                                                                    alt="">Tiktok</a></li>
                                                    </ul>
                                                    <div class="ft-lang">
                                                        <a href="#">VN</a> / <a href="#">EN</a>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                        <%-- 5. NHÚNG FOOTER (Nếu bạn có file footer.jsp) --%>
                                            <%-- <jsp:include page="/footer.jsp" /> --%>
                                            <%--<div class="content">--%>
                                                <%--< /div>--%>

                                                    <%-- CẬP NHẬT: HTML CHO MODAL ĐỔI MẬT KHẨU --%>
                                                        <div id="passwordModal" class="modal">
                                                            <div class="modal-content">
                                                                <span class="close"
                                                                    onclick="closeModal()">&times;</span>
                                                                <h3>Đổi Mật Khẩu</h3>

                                                                <%-- Form gửi đến ChangePasswordController --%>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/change-password"
                                                                        method="post">
                                                                        <div class="form-group">
                                                                            <label>Mật khẩu cũ</label>
                                                                            <input type="password" name="oldPass"
                                                                                required
                                                                                placeholder="Nhập mật khẩu hiện tại">
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label>Mật khẩu mới</label>
                                                                            <input type="password" name="newPass"
                                                                                required
                                                                                placeholder="Nhập mật khẩu mới">
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label>Nhập lại mật khẩu mới</label>
                                                                            <input type="password" name="confirmPass"
                                                                                required
                                                                                placeholder="Xác nhận mật khẩu mới">
                                                                        </div>

                                                                        <button type="submit" class="btn-save-pass">Xác
                                                                            nhận đổi</button>
                                                                    </form>
                                                            </div>
                                                        </div>

                                                        <%-- SCRIPT XỬ LÝ JS --%>
                                                            <script>
                                                                // CAP NHAT: Xu ly Modal ChangePassword
                                                                var modal = document.getElementById("passwordModal");

                                                                // Thêm tham số 'event'
                                                                function openModal(event) {
                                                                    if (event) event.preventDefault(); // Chặn load lại trang

                                                                    var modal = document.getElementById("passwordModal");
                                                                    if (modal) {
                                                                        modal.style.display = "block";
                                                                    } else {
                                                                        console.error("Lỗi: Không tìm thấy Modal ID='passwordModal'");
                                                                    }
                                                                }

                                                                function closeModal() {
                                                                    var modal = document.getElementById("passwordModal");
                                                                    if (modal) modal.style.display = "none";
                                                                }

                                                                // Đóng modal khi click ra ngoài vùng trắng
                                                                window.onclick = function (event) {
                                                                    var modal = document.getElementById("passwordModal");
                                                                    if (event.target == modal) {
                                                                        modal.style.display = "none";
                                                                    }
                                                                }

                                                                // CAP NHAT: Script xu ly an thong bao sau 1s
                                                                document.addEventListener("DOMContentLoaded", function () {
                                                                    var alertBox = document.getElementById("success-alert");
                                                                    if (alertBox) {
                                                                        // Đợi 1 giây (1000ms)
                                                                        setTimeout(function () {
                                                                            // Bước 1: Làm mờ dần
                                                                            alertBox.style.opacity = "0";

                                                                            // Bước 2: Sau khi mờ xong (0.5s), ẩn hẳn khỏi layout
                                                                            setTimeout(function () {
                                                                                alertBox.style.display = "none";
                                                                            }, 500);
                                                                        }, 1000);
                                                                    }
                                                                });
                                                            </script>
                    </body>

                    </html>