<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lấy lại mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Login/forgot_password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css"/>

    <style>
        .alert-error {
            color: #d9534f;
            background: #f2dede;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 10px;
            text-align: center;
        }

        .alert-success {
            color: #3c763d;
            background: #dff0d8;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 10px;
            text-align: center;
        }
    </style>
</head>

<body>

<jsp:include page="/style/header/header.jsp"/>

<div class="container">
    <div class="banner-left">
        <img src="https://i.imgur.com/7lFwwFv.jpeg" alt="Banner">
    </div>

    <div class="form-box">
        <a href="${pageContext.request.contextPath}/Login/login.jsp" class="back-btn"><i class="fa fa-arrow-left"></i>
            Quay lại</a>
        <h2>Lấy lại mật khẩu</h2>
        <p>Nhập địa chỉ email bạn đã đăng ký với HKH.vn.</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert-error"><%= request.getAttribute("error") %>
        </div>
        <% } %>
        <% if (request.getAttribute("message") != null) { %>
        <div class="alert-success"><%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <input type="email" name="email" class="email-input" placeholder="Nhập email" required>

            <div class="links">
                <a href="#" style="float:right;">Bạn cần hỗ trợ?</a>
            </div>

            <button type="submit" class="submit-btn">TIẾP THEO</button>
        </form>
    </div>
</div>

<!-- FOOTER -->
<div class="content">
    <section class="feature-strip">
        <div class="feature">
            <img class="feature-icon" src="https://meta.vn/images/icons/dich-vu-uy-tin-icon.svg" alt="Uy tín">
            <span class="feature-text">Dịch vụ uy tín</span>
        </div>

        <div class="feature">
            <img class="feature-icon" src="https://meta.vn/images/icons/doi-tra-hang-icon.svg" alt="Đổi trả 7 ngày">
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
                <li><a href="#"><img src="https://meta.vn/images/icons/zalo.svg" alt="">Zalo</a></li>
                <li><a href="#"><img src="https://meta.vn/images/icons/facebook-icon.svg" alt="">Facebook</a></li>
                <li><a href="#"><img src="https://meta.vn/images/icons/youtube-icon.svg" alt="">Youtube</a></li>
                <li><a href="#"><img src="https://meta.vn/Data/2025/Thang06/tiktok-meta.svg" alt="">Tiktok</a></li>
            </ul>
            <div class="ft-lang">
                <a href="#">VN</a> / <a href="#">EN</a>
            </div>
        </div>
    </div>

</div>

</body>
</html>