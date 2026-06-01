<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giới Thiệu – THIẾT BỊ Y TẾ 24H</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/About/about.css">
</head>

<body>
    <jsp:include page="/style/header/header.jsp" />

    <main class="about-page">

        <!-- ===== HERO BANNER ===== -->
        <section class="about-hero">
            <div class="about-hero-overlay"></div>
            <div class="container about-hero-content">
                <p class="about-hero-eyebrow">
                    <i class="fa-solid fa-heart-pulse"></i> Thành lập năm 2015
                </p>
                <h1 class="about-hero-title">THIẾT BỊ Y TẾ 24H</h1>
                <p class="about-hero-sub">
                    Đồng hành cùng sức khỏe cộng đồng – Chính hãng, Uy tín, Tận tâm
                </p>
                <div class="about-hero-actions">
                    <a href="${pageContext.request.contextPath}/catalog" class="btn-primary">
                        <i class="fa-solid fa-th-large"></i> Xem Sản Phẩm
                    </a>
                    <a href="tel:0888999406" class="btn-outline">
                        <i class="fa-solid fa-phone-volume"></i> Gọi Ngay
                    </a>
                </div>
            </div>
        </section>

        <div class="container">

            <!-- ===== STATS BAR ===== -->
            <section class="about-stats" aria-label="Thống kê nổi bật">
                <div class="stat-item">
                    <span class="stat-number">10+</span>
                    <span class="stat-label">Năm kinh nghiệm</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-number">50.000+</span>
                    <span class="stat-label">Khách hàng tin dùng</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-number">5.000+</span>
                    <span class="stat-label">Sản phẩm chính hãng</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-number">200+</span>
                    <span class="stat-label">Đối tác y tế</span>
                </div>
            </section>

            <!-- ===== SỨ MỆNH & GIỚI THIỆU ===== -->
            <section class="about-intro">
                <div class="about-intro-img">
                    <img src="https://thietbiyte24h.net/wp-content/uploads/2024/06/banner-trang-chu-b46-2.jpg"
                         alt="Thiết bị y tế 24H" loading="lazy">
                    <div class="about-intro-badge">
                        <i class="fa-solid fa-award"></i>
                        <span>Thương hiệu uy tín<br>hàng đầu Việt Nam</span>
                    </div>
                </div>
                <div class="about-intro-text">
                    <span class="section-eyebrow">
                        <i class="fa-solid fa-circle-info"></i> Về chúng tôi
                    </span>
                    <h2 class="section-title">Sứ Mệnh & Tầm Nhìn</h2>
                    <p>
                        Được thành lập năm <strong>2015</strong>, <strong>THIẾT BỊ Y TẾ 24H</strong> là đơn vị
                        phân phối thiết bị y tế uy tín hàng đầu tại Việt Nam. Chúng tôi hướng đến sứ mệnh
                        <em>mang sức khỏe đến mọi gia đình</em> – cung cấp thiết bị y tế chất lượng cao,
                        giá cả minh bạch và dịch vụ tận tâm 24/7.
                    </p>
                    <p>
                        Với tầm nhìn trở thành nền tảng y tế số hàng đầu Đông Nam Á vào năm 2030,
                        chúng tôi không ngừng mở rộng danh mục sản phẩm, nâng cao chất lượng dịch vụ
                        và xây dựng hệ sinh thái chăm sóc sức khỏe toàn diện cho cộng đồng.
                    </p>
                    <a href="${pageContext.request.contextPath}/catalog" class="btn-primary btn-sm">
                        <i class="fa-solid fa-arrow-right"></i> Khám phá sản phẩm
                    </a>
                </div>
            </section>

            <!-- ===== CAM KẾT ===== -->
            <section class="about-commitments">
                <div class="section-header">
                    <span class="section-eyebrow">
                        <i class="fa-solid fa-shield-halved"></i> Cam kết của chúng tôi
                    </span>
                    <h2 class="section-title">Tại Sao Chọn THIẾT BỊ Y TẾ 24H?</h2>
                </div>

                <div class="commit-grid">
                    <div class="commit-card">
                        <div class="commit-icon commit-icon--blue">
                            <i class="fa-solid fa-certificate"></i>
                        </div>
                        <h3>Hàng Chính Hãng 100%</h3>
                        <p>Toàn bộ sản phẩm có đầy đủ chứng nhận lưu hành từ Bộ Y tế, tem chống giả,
                           hóa đơn VAT và nguồn gốc xuất xứ rõ ràng.</p>
                    </div>

                    <div class="commit-card">
                        <div class="commit-icon commit-icon--green">
                            <i class="fa-solid fa-user-doctor"></i>
                        </div>
                        <h3>Đội Ngũ Chuyên Gia</h3>
                        <p>Hơn <strong>50 chuyên gia</strong> y tế và kỹ thuật thiết bị giàu kinh nghiệm,
                           sẵn sàng tư vấn miễn phí và hỗ trợ kỹ thuật tận nơi.</p>
                    </div>

                    <div class="commit-card">
                        <div class="commit-icon commit-icon--orange">
                            <i class="fa-solid fa-truck-fast"></i>
                        </div>
                        <h3>Giao Hàng Toàn Quốc</h3>
                        <p>Giao hàng nhanh trong <strong>2–4 giờ</strong> nội thành, toàn quốc trong
                           1–3 ngày. Miễn phí vận chuyển cho đơn hàng từ 500.000đ.</p>
                    </div>

                    <div class="commit-card">
                        <div class="commit-icon commit-icon--purple">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                        </div>
                        <h3>Bảo Hành & Hậu Mãi</h3>
                        <p>Bảo hành chính hãng từ 12–36 tháng. Hỗ trợ đổi trả trong 7 ngày,
                           bảo trì định kỳ và thay thế vật tư tận nhà.</p>
                    </div>

                    <div class="commit-card">
                        <div class="commit-icon commit-icon--red">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <h3>Hỗ Trợ 24/7</h3>
                        <p>Đội ngũ chăm sóc khách hàng trực tuyến 24/7 qua hotline, Zalo, Facebook
                           – luôn sẵn sàng giải đáp mọi thắc mắc của bạn.</p>
                    </div>

                    <div class="commit-card">
                        <div class="commit-icon commit-icon--teal">
                            <i class="fa-solid fa-tag"></i>
                        </div>
                        <h3>Giá Cả Minh Bạch</h3>
                        <p>Cam kết giá tốt nhất thị trường, không phát sinh chi phí ẩn.
                           Hoàn tiền 100% nếu phát hiện hàng giả, hàng kém chất lượng.</p>
                    </div>
                </div>
            </section>

            <!-- ===== ĐỘI NGŨ ===== -->
            <section class="about-team">
                <div class="section-header">
                    <span class="section-eyebrow">
                        <i class="fa-solid fa-users"></i> Con người
                    </span>
                    <h2 class="section-title">Đội Ngũ Chuyên Gia</h2>
                    <p class="section-desc">
                        Chúng tôi quy tụ những chuyên gia hàng đầu trong lĩnh vực y tế và kỹ thuật thiết bị,
                        cam kết mang đến dịch vụ tư vấn chuyên nghiệp và tận tâm nhất.
                    </p>
                </div>

                <div class="team-grid">
                    <div class="team-card">
                        <div class="team-avatar">
                            <i class="fa-solid fa-user-tie"></i>
                        </div>
                        <h4>Ban Lãnh Đạo</h4>
                        <p>Đội ngũ quản lý với hơn 15 năm kinh nghiệm trong ngành thiết bị y tế và dược phẩm.</p>
                    </div>
                    <div class="team-card">
                        <div class="team-avatar">
                            <i class="fa-solid fa-stethoscope"></i>
                        </div>
                        <h4>Chuyên Gia Y Tế</h4>
                        <p>Bác sĩ, dược sĩ và kỹ thuật viên y tế tư vấn chuyên sâu về sản phẩm và sử dụng đúng cách.</p>
                    </div>
                    <div class="team-card">
                        <div class="team-avatar">
                            <i class="fa-solid fa-gear"></i>
                        </div>
                        <h4>Kỹ Thuật Viên</h4>
                        <p>Đội ngũ kỹ thuật được đào tạo bởi nhà sản xuất, hỗ trợ lắp đặt và bảo trì thiết bị.</p>
                    </div>
                    <div class="team-card">
                        <div class="team-avatar">
                            <i class="fa-solid fa-comments"></i>
                        </div>
                        <h4>Tư Vấn Viên</h4>
                        <p>Đội ngũ tư vấn nhiệt tình, am hiểu sản phẩm, hỗ trợ khách hàng chọn đúng thiết bị phù hợp.</p>
                    </div>
                </div>
            </section>

            <!-- ===== ĐỐI TÁC ===== -->
            <section class="about-partners">
                <div class="section-header">
                    <span class="section-eyebrow">
                        <i class="fa-solid fa-handshake"></i> Hợp tác
                    </span>
                    <h2 class="section-title">Đối Tác & Bệnh Viện Tin Dùng</h2>
                    <p class="section-desc">
                        Chúng tôi tự hào là đối tác cung cấp thiết bị y tế cho hơn <strong>200 bệnh viện,
                        phòng khám</strong> trên toàn quốc.
                    </p>
                </div>

                <div class="partner-grid">
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-hospital"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Bệnh viện Chợ Rẫy</h4>
                            <span>TP. Hồ Chí Minh</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-hospital"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Bệnh viện Bạch Mai</h4>
                            <span>Hà Nội</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-hospital"></i>
                        </div>
                        <div class="partner-info">
                            <h4>BV Đại học Y Dược TP.HCM</h4>
                            <span>TP. Hồ Chí Minh</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-hospital"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Bệnh viện Vinmec</h4>
                            <span>Toàn quốc</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-clinic-medical"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Phòng khám Columbia Asia</h4>
                            <span>TP. Hồ Chí Minh</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-clinic-medical"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Phòng khám Đa khoa Quốc tế</h4>
                            <span>Hà Nội & TP.HCM</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-hospital"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Bệnh viện FV</h4>
                            <span>TP. Hồ Chí Minh</span>
                        </div>
                    </div>
                    <div class="partner-card">
                        <div class="partner-icon">
                            <i class="fa-solid fa-clinic-medical"></i>
                        </div>
                        <div class="partner-info">
                            <h4>Hệ thống Phòng khám MEDLATEC</h4>
                            <span>Toàn quốc</span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ===== HOTLINE / CTA ===== -->
            <section class="about-cta">
                <div class="about-cta-inner">
                    <div class="about-cta-text">
                        <h2>
                            <i class="fa-solid fa-phone-volume"></i>
                            Cần tư vấn? Gọi ngay miễn phí!
                        </h2>
                        <p>
                            Đội ngũ chuyên gia của chúng tôi luôn sẵn sàng hỗ trợ bạn
                            <strong>24/7</strong> – từ tư vấn chọn sản phẩm đến hỗ trợ kỹ thuật sau mua hàng.
                        </p>
                        <div class="cta-hotline">
                            <i class="fa-solid fa-circle-phone-flip"></i>
                            <a href="tel:0888999406">0888.999.406</a>
                            <span class="cta-free-badge">Miễn phí</span>
                        </div>
                    </div>
                    <div class="about-cta-actions">
                        <a href="${pageContext.request.contextPath}/catalog" class="btn-primary btn-lg">
                            <i class="fa-solid fa-th-large"></i> Xem Tất Cả Sản Phẩm
                        </a>
                        <a href="tel:0888999406" class="btn-white btn-lg">
                            <i class="fa-solid fa-headset"></i> Liên Hệ Ngay
                        </a>
                    </div>
                </div>
            </section>

        </div><!-- /container -->

        <!-- ===== FOOTER ===== -->
        <div class="container">
            <jsp:include page="/style/footer/footer.jsp" />
        </div>

    </main>

    <script src="${pageContext.request.contextPath}/style/header/header.js"></script>
    <script src="${pageContext.request.contextPath}/style/footer/footer.js"></script>
</body>

</html>
