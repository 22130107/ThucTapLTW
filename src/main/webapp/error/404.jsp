<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 – Không tìm thấy trang | MEDITECH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/error/404.css">
</head>
<body>
    <div class="bg-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <div class="card">
        <div class="error-code">404</div>

        <div class="icon-wrap">
            <svg viewBox="0 0 24 24">
                <circle cx="11" cy="11" r="8"/>
                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                <line x1="11" y1="8" x2="11" y2="11"/>
                <line x1="11" y1="14" x2="11.01" y2="14"/>
            </svg>
        </div>

        <h1>Trang không tìm thấy</h1>
        <p>Trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.<br>Vui lòng kiểm tra lại địa chỉ URL.</p>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
                Về trang chủ
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"/>
                </svg>
                Quay lại
            </a>
        </div>

        <p class="hint">Mã lỗi: HTTP 404 &nbsp;·&nbsp; MEDITECH</p>
    </div>
</body>
</html>
