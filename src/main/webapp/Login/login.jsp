<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập – Thiết Bị Y Tế 24H</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Login/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css"/>
</head>
<body>
<jsp:include page="/style/header/header.jsp"/>

<!-- Toast container -->
<div class="toast-container" id="toastContainer"></div>

<main class="auth-wrapper">
  <div class="auth-card">

    <!-- Header card -->
    <div class="auth-card-header">
      <div class="brand-logo">
        <!-- Logo giống hệt header: fa-heart-pulse nền xanh nhạt -->
        <div class="brand-logo-icon">
          <i class="fa-solid fa-heart-pulse" aria-hidden="true"></i>
        </div>
        <div class="brand-name">
          Thiết Bị Y Tế 24H
          <span>Thiết bị y tế chính hãng</span>
        </div>
      </div>
      <div class="auth-tabs">
        <button class="auth-tab active" onclick="location.href='${pageContext.request.contextPath}/login'">Đăng nhập</button>
        <button class="auth-tab" onclick="location.href='${pageContext.request.contextPath}/register'">Đăng ký</button>
      </div>
    </div>

    <!-- Body card -->
    <div class="auth-card-body">
      <div class="form-heading">
        <h2>Chào mừng trở lại</h2>
        <p>Vui lòng nhập thông tin tài khoản của bạn</p>
      </div>

      <!-- Lỗi từ server hoặc từ redirect -->
      <%
        String serverError = (String) request.getAttribute("error");
        String paramError  = request.getParameter("error");
        String displayError = serverError != null ? serverError : paramError;
      %>
      <% if (displayError != null) { %>
      <div class="server-error">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <%= displayError %>
      </div>
      <% } %>

      <!-- Form đăng nhập — giữ nguyên action, name fields -->
      <form id="formLogin" action="${pageContext.request.contextPath}/login" method="post" novalidate>

        <!-- Tên đăng nhập -->
        <div class="form-group">
          <label for="username">Tên đăng nhập</label>
          <div class="input-wrapper">
            <span class="input-icon" aria-hidden="true">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
              </svg>
            </span>
            <input type="text" id="username" name="username"
                   placeholder="nguyenvana" autocomplete="username" required>
          </div>
          <span class="field-error" id="err-username"></span>
        </div>

        <!-- Mật khẩu -->
        <div class="form-group">
          <label for="password">Mật khẩu</label>
          <div class="input-wrapper">
            <span class="input-icon" aria-hidden="true">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
              </svg>
            </span>
            <input type="password" id="password" name="password"
                   placeholder="········" autocomplete="current-password"
                   class="has-toggle" required>
            <button type="button" class="toggle-password" onclick="togglePwd('password', this)" aria-label="Hiện/ẩn mật khẩu">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-icon">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
          <span class="field-error" id="err-password"></span>
        </div>

        <!-- Ghi nhớ + Quên mật khẩu -->
        <div class="form-row">
          <label class="checkbox-label">
            <input type="checkbox" name="rememberMe">
            Ghi nhớ đăng nhập
          </label>
          <a href="${pageContext.request.contextPath}/forgot-password" class="link-forgot">Quên mật khẩu?</a>
        </div>

        <button type="submit" class="btn-submit">
          Đăng nhập
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M5 12h14M12 5l7 7-7 7"/>
          </svg>
        </button>
      </form>

      <!-- Divider -->
      <div class="auth-divider"><span>HOẶC</span></div>

      <!-- Social login -->
      <div class="social-buttons">
        <a href="${pageContext.request.contextPath}/login-zalo" class="btn-social btn-zalo">
          <svg width="20" height="20" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
            <rect width="48" height="48" rx="10" fill="#0068FF"/>
            <text x="50%" y="55%" dominant-baseline="middle" text-anchor="middle" font-family="Arial,sans-serif" font-weight="800" font-size="20" fill="white">Z</text>
          </svg>
          Đăng nhập bằng Zalo
        </a>

        <%
          String googleLoginLink = vn.edu.hcmuaf.fit.util.GoogleUtils.buildLoginUrl();
        %>
        <a href="<%= googleLoginLink %>" class="btn-social btn-google">
          <i class="fa-brands fa-google" style="font-size:17px;color:#ea4335;" aria-hidden="true"></i>
          Đăng nhập bằng Google
        </a>
      </div>

    </div><!-- /auth-card-body -->
  </div><!-- /auth-card -->
</main>

<!-- Footer -->
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
            <img class="feature-icon" src="https://meta.vn/images/icons/giao-hang-toan-quoc-icon.svg" alt="Giao toàn quốc">
            <span class="feature-text">Giao hàng toàn quốc</span>
        </div>
    </section>
    <div class="ft-row ft-health">
        <div class="ft-col">
            <h4>Liên hệ &amp; hỗ trợ</h4>
            <ul class="ft-list">
                <li class="ft-flag"><strong>Miền Bắc &amp; Trung</strong></li>
                <li>Mua hàng: <a class="tel" href="tel:02435686969">(024) 3568 6969</a></li>
                <li>Bảo hành: <a class="tel" href="tel:02435681234">(024) 3568 1234</a></li>
                <li class="ft-flag"><strong>Miền Nam</strong></li>
                <li>Mua hàng: <a class="tel" href="tel:02838336666">(028) 3833 6666</a></li>
                <li>Bảo hành: <a class="tel" href="tel:02838331234">(028) 3833 1234</a></li>
                <li class="ft-time"><span>Thứ 2–Thứ 6: 8:00–17:30</span><span>Thứ 7: 8:00–12:00</span></li>
            </ul>
        </div>
        <div class="ft-col">
            <h4>Hỗ trợ khách hàng</h4>
            <ul class="ft-links">
                <li><a href="#">Chính sách đổi trả &amp; bảo hành</a></li>
                <li><a href="#">Hướng dẫn thanh toán</a></li>
                <li><a href="#">Chính sách giao hàng lạnh/nhanh</a></li>
                <li><a href="#">Hướng dẫn đặt hàng online</a></li>
                <li><a href="#">Bảo mật thông tin y tế</a></li>
            </ul>
        </div>
        <div class="ft-col">
            <h4>Dịch vụ chuyên môn</h4>
            <ul class="ft-links">
                <li><a href="#">Hiệu chuẩn &amp; kiểm định thiết bị</a></li>
                <li><a href="#">Tư vấn set-up phòng khám</a></li>
                <li><a href="#">Bảo trì – thay thế vật tư</a></li>
                <li><a href="#">Thuê thiết bị y tế</a></li>
            </ul>
        </div>
        <div class="ft-col">
            <h4>Về Thiết Bị Y Tế 24H</h4>
            <ul class="ft-links">
                <li><a href="#">Giới thiệu</a></li>
                <li><a href="#">Chứng nhận chất lượng</a></li>
                <li><a href="#">Tin tức – tuyển dụng</a></li>
                <li><a href="#">Liên hệ hợp tác</a></li>
            </ul>
        </div>
        <div class="ft-col">
            <h4>Kết nối với chúng tôi</h4>
            <ul class="ft-social">
                <li><a href="#"><img src="https://meta.vn/images/icons/zalo.svg" alt="">Zalo</a></li>
                <li><a href="#"><img src="https://meta.vn/images/icons/facebook-icon.svg" alt="">Facebook</a></li>
                <li><a href="#"><img src="https://meta.vn/images/icons/youtube-icon.svg" alt="">Youtube</a></li>
            </ul>
            <div class="ft-lang"><a href="#">VN</a> / <a href="#">EN</a></div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/style/header/header.js"></script>
<script>
/* Toggle hiện/ẩn mật khẩu */
function togglePwd(inputId, btn) {
    const input = document.getElementById(inputId);
    const isHidden = input.type === 'password';
    input.type = isHidden ? 'text' : 'password';
    const icon = btn.querySelector('.eye-icon');
    if (isHidden) {
        icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>' +
            '<path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>' +
            '<line x1="1" y1="1" x2="23" y2="23"/>';
    } else {
        icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
    }
}

/* Validation cơ bản trước khi submit */
document.getElementById('formLogin').addEventListener('submit', function(e) {
    let valid = true;
    const u = document.getElementById('username');
    const p = document.getElementById('password');
    document.getElementById('err-username').textContent = '';
    document.getElementById('err-password').textContent = '';
    u.classList.remove('is-invalid'); p.classList.remove('is-invalid');

    if (!u.value.trim()) {
        document.getElementById('err-username').textContent = 'Vui lòng nhập tên đăng nhập';
        u.classList.add('is-invalid'); valid = false;
    }
    if (!p.value) {
        document.getElementById('err-password').textContent = 'Vui lòng nhập mật khẩu';
        p.classList.add('is-invalid'); valid = false;
    }
    if (!valid) e.preventDefault();
});

/* Toast thông báo */
function showToast(msg, type) {
    const c = document.getElementById('toastContainer');
    const t = document.createElement('div');
    t.className = 'toast toast-' + (type || 'success');
    t.innerHTML = '<span class="toast-msg">' + msg + '</span>' +
        '<button onclick="this.parentElement.remove()" class="toast-close" aria-label="Đóng">✕</button>';
    c.appendChild(t);
    setTimeout(() => { t.classList.add('toast-out'); setTimeout(() => t.remove(), 300); }, 4000);
}

/* Hiện toast lỗi từ server nếu có */
<% if (displayError != null) { %>
window.addEventListener('DOMContentLoaded', function() {
    showToast('<%= displayError.replace("'", "\\'") %>', 'error');
});
<% } %>
</script>
</body>
</html>
