<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thanh toán SePay QR</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .card {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
      max-width: 480px;
      width: 100%;
      overflow: hidden;
    }

    .card-header {
      background: linear-gradient(135deg, #1abc9c, #16a085);
      padding: 24px;
      text-align: center;
      color: #fff;
    }
    .card-header .logo { font-size: 40px; margin-bottom: 8px; }
    .card-header h2 { font-size: 20px; font-weight: 700; margin-bottom: 4px; }
    .card-header p { font-size: 13px; opacity: .85; }

    .card-body { padding: 28px 24px; }

    .info-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 0;
      border-bottom: 1px solid #f0f0f0;
      font-size: 14px;
    }
    .info-row:last-of-type { border-bottom: none; }
    .info-row .label { color: #888; }
    .info-row .value { font-weight: 700; color: #2c3e50; }
    .info-row .value.amount { color: #e74c3c; font-size: 18px; }
    .info-row .value.content {
      background: #f8f9ff;
      border: 1.5px dashed #667eea;
      border-radius: 6px;
      padding: 4px 10px;
      font-family: 'Courier New', monospace;
      font-size: 15px;
      letter-spacing: 1px;
      color: #667eea;
    }

    .copy-btn {
      background: none;
      border: none;
      cursor: pointer;
      color: #667eea;
      font-size: 14px;
      margin-left: 8px;
      padding: 2px 6px;
      border-radius: 4px;
      transition: background .2s;
    }
    .copy-btn:hover { background: #eef0ff; }

    .qr-section {
      text-align: center;
      margin: 20px 0 16px;
    }
    .qr-wrapper {
      display: inline-block;
      padding: 10px;
      border: 3px solid #1abc9c;
      border-radius: 12px;
      background: #fff;
    }
    .qr-wrapper img {
      width: 200px;
      height: 200px;
      display: block;
    }
    .qr-hint {
      font-size: 12px;
      color: #999;
      margin-top: 8px;
    }

    .steps {
      background: #f8fffe;
      border-left: 4px solid #1abc9c;
      border-radius: 0 8px 8px 0;
      padding: 14px 16px;
      margin: 16px 0;
      font-size: 13px;
      color: #555;
    }
    .steps ol { padding-left: 18px; }
    .steps li { margin-bottom: 6px; }

    .status-bar {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 14px;
      border-radius: 10px;
      font-size: 15px;
      font-weight: 600;
      margin: 16px 0 0;
      transition: all .4s;
    }
    .status-bar.pending { background: #fff8e1; color: #f39c12; border: 1.5px solid #f39c12; }
    .status-bar.success { background: #d4edda; color: #155724; border: 1.5px solid #28a745; }
    .status-bar.cancelled{ background: #f8d7da; color: #721c24; border: 1.5px solid #dc3545; }

    .spinner {
      width: 18px; height: 18px;
      border: 3px solid #f39c12;
      border-top-color: transparent;
      border-radius: 50%;
      animation: spin .8s linear infinite;
      display: inline-block;
      flex-shrink: 0;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    #timer {
      font-size: 13px;
      color: #e74c3c;
      text-align: center;
      margin-top: 10px;
      font-weight: 600;
    }

    #debugPanel {
      display: none;
      background: #1e1e1e;
      color: #0f0;
      font-family: monospace;
      font-size: 11px;
      padding: 10px;
      border-radius: 6px;
      margin-top: 10px;
      max-height: 120px;
      overflow-y: auto;
    }

    .btn-cancel {
      display: block;
      width: 100%;
      padding: 12px;
      background: #ecf0f1;
      color: #7f8c8d;
      border: none;
      border-radius: 8px;
      font-size: 14px;
      cursor: pointer;
      margin-top: 16px;
      text-align: center;
      text-decoration: none;
      transition: background .2s;
    }
    .btn-cancel:hover { background: #dfe6e9; }

    #toast {
      position: fixed;
      bottom: 30px; left: 50%;
      transform: translateX(-50%) translateY(80px);
      background: #2c3e50;
      color: #fff;
      padding: 10px 22px;
      border-radius: 24px;
      font-size: 14px;
      transition: transform .3s;
      z-index: 999;
    }
    #toast.show { transform: translateX(-50%) translateY(0); }
  </style>
</head>
<body>

<div class="card">
  <div class="card-header">
    <div class="logo">📱</div>
    <h2>Quét mã QR để thanh toán</h2>
    <p>Sử dụng app ngân hàng hoặc ví điện tử để quét</p>
  </div>

  <div class="card-body">
    <div class="info-row">
      <span class="label">Mã đơn hàng</span>
      <span class="value">#${orderId}</span>
    </div>
    <div class="info-row">
      <span class="label">Số tiền</span>
      <span class="value amount">
        <fmt:formatNumber value="${amount}" type="number" groupingUsed="true"/> ₫
      </span>
    </div>
    <div class="info-row">
      <span class="label">Ngân hàng</span>
      <span class="value">${bankCode} – ${bankAccount}</span>
    </div>
    <c:if test="${not empty accountName}">
      <div class="info-row">
        <span class="label">Chủ tài khoản</span>
        <span class="value">${accountName}</span>
      </div>
    </c:if>
    <div class="info-row">
      <span class="label">Nội dung CK</span>
      <span>
        <span class="value content" id="transferContent">${content}</span>
        <button class="copy-btn" onclick="copyContent()" title="Sao chép">
          <i class="fas fa-copy"></i>
        </button>
      </span>
    </div>

    <div class="qr-section">
      <div class="qr-wrapper">
        <img src="${qrImageUrl}" alt="QR Code SePay"
             onerror="this.src='https://via.placeholder.com/200x200?text=QR+Error'">
      </div>
      <p class="qr-hint"><i class="fas fa-info-circle"></i>
        Mở app ngân hàng → Quét mã QR → Kiểm tra nội dung → Xác nhận
      </p>
    </div>

    <div class="steps">
      <strong><i class="fas fa-list-ol"></i> Hướng dẫn:</strong>
      <ol>
        <li>Mở ứng dụng ngân hàng / ví điện tử của bạn</li>
        <li>Chọn <strong>Quét mã QR</strong> hoặc <strong>Chuyển khoản</strong></li>
        <li>Nhập đúng <strong>nội dung chuyển khoản: ${content}</strong></li>
        <li>Xác nhận số tiền <strong><fmt:formatNumber value="${amount}" type="number"/> ₫</strong></li>
        <li>Trang này sẽ tự động cập nhật khi nhận được thanh toán</li>
      </ol>
    </div>

    <div class="status-bar pending" id="statusBar">
      <span class="spinner" id="spinner"></span>
      <span id="statusText">Đang chờ thanh toán...</span>
    </div>

    <div id="timer"></div>

    <div id="debugPanel"></div>

    <a href="${pageContext.request.contextPath}/purchase-history" class="btn-cancel">
      <i class="fas fa-times-circle"></i> Huỷ và quay lại lịch sử đơn hàng
    </a>
  </div>
</div>

<div id="toast"></div>
