<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 – Lỗi máy chủ | MEDITECH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/error/500.css">
</head>
<body>
    <div class="bg-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <div class="card">
        <div class="error-code">500</div>

        <div class="icon-wrap">
            <svg viewBox="0 0 24 24">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                <line x1="12" y1="9" x2="12" y2="13"/>
                <line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
        </div>

        <h1>Lỗi máy chủ nội bộ</h1>
        <p>Đã xảy ra sự cố không mong muốn từ phía chúng tôi.<br>Đội ngũ kỹ thuật đã được thông báo và đang khắc phục.</p>

        <div class="countdown">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12 6 12 12 16 14"/>
            </svg>
            Tự động thử lại sau <span id="timer">10</span> giây
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
                Về trang chủ
            </a>
            <a href="javascript:location.reload()" class="btn btn-secondary">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="23 4 23 10 17 10"/>
                    <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
                </svg>
                Thử lại
            </a>
        </div>

        <p class="hint">Mã lỗi: HTTP 500 &nbsp;·&nbsp; MEDITECH</p>
    </div>

    <script>
        let s = 10;
        const el = document.getElementById('timer');
        const iv = setInterval(() => {
            s--;
            el.textContent = s;
            if (s <= 0) { clearInterval(iv); location.reload(); }
        }, 1000);
    </script>
</body>
</html>
