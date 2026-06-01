<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên Hệ | THIẾT BỊ Y TẾ 24H</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Contact/contact.css">
</head>
<body>
<jsp:include page="/style/header/header.jsp"/>

<main class="contact-page">

    <!-- ===== HERO ===== -->
    <section class="contact-hero">
        <div class="contact-hero-overlay"></div>
        <div class="container contact-hero-content">
            <nav class="ct-breadcrumb">
                <a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <i class="fa-solid fa-chevron-right"></i>
                <span>Liên Hệ</span>
            </nav>
            <h1><i class="fa-solid fa-headset"></i> THÔNG TIN LIÊN HỆ & HỖ TRỢ KHÁCH HÀNG</h1>
            <p>Quý khách vui lòng điền thông tin hoặc gọi trực tiếp hotline để được tư vấn miễn phí</p>
        </div>
    </section>

    <!-- ===== BADGE STRIP ===== -->
    <div class="ct-badge-strip">
        <div class="container ct-badge-row">
            <span class="ct-badge ct-badge--green"><i class="fa-solid fa-truck-fast"></i> Giao nhanh 2h nội thành</span>
            <span class="ct-badge ct-badge--blue"><i class="fa-solid fa-box-open"></i> Miễn phí vận chuyển &gt;500k</span>
            <span class="ct-badge ct-badge--red"><i class="fa-solid fa-certificate"></i> Cam kết chính hãng 100%</span>
            <span class="ct-badge ct-badge--orange"><i class="fa-solid fa-rotate-left"></i> Đổi trả trong 7 ngày</span>
            <span class="ct-badge ct-badge--purple"><i class="fa-solid fa-gift"></i> Quà tặng VIP khi liên hệ</span>
        </div>
    </div>

    <div class="container ct-layout">

        <!-- ===== CỘT TRÁI ===== -->
        <div class="ct-main">

            <!-- Thông tin liên hệ -->
            <div class="ct-info-grid">
                <!-- Hotline -->
                <div class="ct-info-card ct-info-card--hotline">
                    <div class="ct-info-icon"><i class="fa-solid fa-phone-volume"></i></div>
                    <div class="ct-info-body">
                        <span class="ct-info-label">Hotline mua hàng & Tư vấn miễn phí</span>
                        <a href="tel:0888999406" class="ct-hotline-number">0888.999.406</a>
                        <span class="ct-info-sub">Hỗ trợ 24/7 – Miễn phí hoàn toàn</span>
                    </div>
                    <span class="ct-free-tag">FREE</span>
                </div>

                <!-- Email -->
                <div class="ct-info-card">
                    <div class="ct-info-icon ct-info-icon--blue"><i class="fa-solid fa-envelope"></i></div>
                    <div class="ct-info-body">
                        <span class="ct-info-label">Email hỗ trợ</span>
                        <a href="mailto:thietbiyte24h@gmail.com" class="ct-info-value">thietbiyte24h@gmail.com</a>
                        <span class="ct-info-sub">Phản hồi trong vòng 2 giờ</span>
                    </div>
                </div>

                <!-- Địa chỉ -->
                <div class="ct-info-card">
                    <div class="ct-info-icon ct-info-icon--green"><i class="fa-solid fa-location-dot"></i></div>
                    <div class="ct-info-body">
                        <span class="ct-info-label">Showroom & Văn phòng</span>
                        <span class="ct-info-value">Số 123, đường Nguyễn Lương Bằng</span>
                        <span class="ct-info-sub">Quận Liên Chiểu, TP. Đà Nẵng</span>
                    </div>
                </div>

                <!-- Giờ làm việc -->
                <div class="ct-info-card">
                    <div class="ct-info-icon ct-info-icon--orange"><i class="fa-solid fa-clock"></i></div>
                    <div class="ct-info-body">
                        <span class="ct-info-label">Giờ làm việc</span>
                        <span class="ct-info-value">Thứ 2 – Thứ 7: 8:00 – 20:00</span>
                        <span class="ct-info-sub">Chủ nhật: 9:00 – 17:00</span>
                    </div>
                </div>
            </div>

            <!-- Banner VIP -->
            <div class="ct-vip-banner">
                <div class="ct-vip-icon"><i class="fa-solid fa-crown"></i></div>
                <div class="ct-vip-text">
                    <strong>Để lại thông tin – Nhận ngay Quà Tặng VIP!</strong>
                    <span>Khách hàng liên hệ hôm nay nhận voucher giảm 10% + quà tặng kèm trị giá 200.000đ</span>
                </div>
                <span class="ct-vip-tag">VIP</span>
            </div>

            <!-- Form liên hệ -->
            <div class="ct-form-card">
                <div class="ct-form-header">
                    <h2><i class="fa-solid fa-paper-plane"></i> GỬI YÊU CẦU TƯ VẤN</h2>
                    <p><i class="fa-solid fa-circle-check"></i> Chúng tôi sẽ liên hệ lại trong vòng <strong>30 phút</strong> (trong giờ làm việc)</p>
                </div>

                <form class="ct-form" action="${pageContext.request.contextPath}/contact" method="post" novalidate>
                    <div class="ct-form-row">
                        <div class="ct-form-group">
                            <label for="fullname"><i class="fa-solid fa-user"></i> Họ và tên <span class="required">*</span></label>
                            <input type="text" id="fullname" name="fullname" placeholder="Nguyễn Văn A" required>
                        </div>
                        <div class="ct-form-group">
                            <label for="phone"><i class="fa-solid fa-phone"></i> Số điện thoại <span class="required">*</span></label>
                            <input type="tel" id="phone" name="phone" placeholder="0888.999.xxx" required>
                        </div>
                    </div>

                    <div class="ct-form-group">
                        <label for="email"><i class="fa-solid fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com">
                    </div>

                    <div class="ct-form-group">
                        <label for="subject"><i class="fa-solid fa-tag"></i> Chủ đề tư vấn</label>
                        <select id="subject" name="subject">
                            <option value="">-- Chọn sản phẩm cần tư vấn --</option>
                            <option>Máy đo huyết áp</option>
                            <option>Máy xông khí dung</option>
                            <option>Xe lăn</option>
                            <option>Giường y tế</option>
                            <option>Máy đo đường huyết</option>
                            <option>Máy đo SpO2</option>
                            <option>Thiết bị khác</option>
                        </select>
                    </div>

                    <div class="ct-form-group">
                        <label for="message"><i class="fa-solid fa-comment-dots"></i> Nội dung <span class="required">*</span></label>
                        <textarea id="message" name="message" rows="5"
                            placeholder="Tôi cần tư vấn về máy đo huyết áp / máy xông khí dung / xe lăn..." required></textarea>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="ct-alert ct-alert--success">
                            <i class="fa-solid fa-circle-check"></i> ${successMsg}
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMsg}">
                        <div class="ct-alert ct-alert--error">
                            <i class="fa-solid fa-circle-exclamation"></i> ${errorMsg}
                        </div>
                    </c:if>

                    <button type="submit" class="ct-submit-btn">
                        <i class="fa-solid fa-paper-plane"></i> GỬI LIÊN HỆ NGAY
                    </button>
                </form>
            </div>
        </div>

        <!-- ===== CỘT PHẢI (SIDEBAR) ===== -->
        <aside class="ct-sidebar">

            <!-- Hỗ trợ trực tuyến -->
            <div class="ct-widget">
                <h3 class="ct-widget-title"><i class="fa-solid fa-comments"></i> Hỗ Trợ Trực Tuyến</h3>
                <ul class="ct-online-list">
                    <li>
                        <a href="https://zalo.me/0888999406" target="_blank" class="ct-online-item ct-online-item--zalo">
                            <span class="ct-online-dot"></span>
                            <i class="fa-solid fa-comment-dots"></i>
                            <div>
                                <strong>Chat Zalo</strong>
                                <span>0888.999.406 – Trả lời ngay</span>
                            </div>
                            <i class="fa-solid fa-chevron-right ct-arrow"></i>
                        </a>
                    </li>
                    <li>
                        <a href="https://facebook.com/thietbiyte24h" target="_blank" class="ct-online-item ct-online-item--fb">
                            <span class="ct-online-dot"></span>
                            <i class="fa-brands fa-facebook-f"></i>
                            <div>
                                <strong>Facebook Messenger</strong>
                                <span>/thietbiyte24h</span>
                            </div>
                            <i class="fa-solid fa-chevron-right ct-arrow"></i>
                        </a>
                    </li>
                    <li>
                        <a href="tel:0888999406" class="ct-online-item ct-online-item--phone">
                            <span class="ct-online-dot"></span>
                            <i class="fa-solid fa-phone"></i>
                            <div>
                                <strong>Gọi điện trực tiếp</strong>
                                <span>0888.999.406 – 24/7</span>
                            </div>
                            <i class="fa-solid fa-chevron-right ct-arrow"></i>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Chính sách -->
            <div class="ct-widget">
                <h3 class="ct-widget-title"><i class="fa-solid fa-shield-halved"></i> Chính Sách</h3>
                <ul class="ct-policy-list">
                    <li><a href="#"><i class="fa-solid fa-rotate-left"></i> Chính sách đổi trả</a></li>
                    <li><a href="#"><i class="fa-solid fa-screwdriver-wrench"></i> Chính sách bảo hành</a></li>
                    <li><a href="#"><i class="fa-solid fa-truck"></i> Chính sách giao hàng</a></li>
                    <li><a href="#"><i class="fa-solid fa-cart-shopping"></i> Hướng dẫn mua hàng online</a></li>
                    <li><a href="#"><i class="fa-solid fa-lock"></i> Bảo mật thông tin</a></li>
                </ul>
            </div>

            <!-- Phương thức thanh toán -->
            <div class="ct-widget">
                <h3 class="ct-widget-title"><i class="fa-solid fa-credit-card"></i> Phương Thức Thanh Toán</h3>
                <div class="ct-payment-grid">
                    <div class="ct-payment-item">
                        <i class="fa-solid fa-money-bill-wave"></i>
                        <span>Tiền mặt (COD)</span>
                    </div>
                    <div class="ct-payment-item">
                        <i class="fa-brands fa-cc-visa"></i>
                        <span>Visa / Master</span>
                    </div>
                    <div class="ct-payment-item">
                        <i class="fa-solid fa-building-columns"></i>
                        <span>Chuyển khoản</span>
                    </div>
                    <div class="ct-payment-item">
                        <i class="fa-solid fa-mobile-screen"></i>
                        <span>Ví điện tử</span>
                    </div>
                    <div class="ct-payment-item">
                        <i class="fa-solid fa-hand-holding-dollar"></i>
                        <span>Trả góp 0%</span>
                    </div>
                    <div class="ct-payment-item">
                        <i class="fa-solid fa-qrcode"></i>
                        <span>QR Code</span>
                    </div>
                </div>
            </div>

            <!-- Mini map -->
            <div class="ct-widget ct-widget--map">
                <h3 class="ct-widget-title"><i class="fa-solid fa-map-location-dot"></i> Vị Trí Cửa Hàng</h3>
                <div class="ct-mini-map">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3833.8!2d108.15!3d16.07!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTbCsDA0JzEyLjAiTiAxMDjCsDA5JzAwLjAiRQ!5e0!3m2!1svi!2svn!4v1234567890"
                        width="100%" height="180" style="border:0;" allowfullscreen="" loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade" title="Bản đồ THIẾT BỊ Y TẾ 24H">
                    </iframe>
                </div>
                <a href="https://maps.google.com" target="_blank" class="ct-map-link">
                    <i class="fa-solid fa-diamond-turn-right"></i> Xem chỉ đường đến cửa hàng
                </a>
            </div>

        </aside>
    </div><!-- /ct-layout -->

    <!-- ===== BẢN ĐỒ LỚN ===== -->
    <section class="ct-map-section">
        <div class="ct-map-header">
            <h2><i class="fa-solid fa-map-location-dot"></i> Xem Chỉ Đường Đến Cửa Hàng</h2>
            <p>Số 123, đường Nguyễn Lương Bằng, Quận Liên Chiểu, TP. Đà Nẵng</p>
        </div>
        <div class="ct-map-frame">
            <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d60940.8!2d108.15!3d16.07!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314219c792252a13%3A0x1595f7b8b2b0f542!2zTGnDqm4gQ2hp4buBdSwgxJDDoCBO4bq1bmcsIFZpZXRuYW0!5e0!3m2!1svi!2svn!4v1234567890"
                width="100%" height="420" style="border:0;" allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade" title="Bản đồ cửa hàng">
            </iframe>
        </div>
        <div class="container ct-map-actions">
            <a href="https://maps.google.com" target="_blank" class="ct-btn-directions">
                <i class="fa-solid fa-diamond-turn-right"></i> Mở Google Maps
            </a>
            <a href="tel:0888999406" class="ct-btn-call">
                <i class="fa-solid fa-phone-volume"></i> Gọi 0888.999.406
            </a>
        </div>
    </section>

    <!-- Footer -->
    <div class="container">
        <jsp:include page="/style/footer/footer.jsp"/>
    </div>

</main>

<script src="${pageContext.request.contextPath}/style/header/header.js"></script>
<script src="${pageContext.request.contextPath}/style/footer/footer.js"></script>
<script src="${pageContext.request.contextPath}/Contact/contact.js"></script>
</body>
</html>
