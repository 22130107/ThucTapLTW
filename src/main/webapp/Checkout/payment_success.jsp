<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thanh toán thành công</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 20px;
    }
    .container {
      background: #fff; border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
      max-width: 500px; width: 100%;
      padding: 48px 40px 40px; text-align: center;
    }
    .icon-success { color: #2ecc71; font-size: 80px; margin-bottom: 20px; animation: pop .4s ease; }
    @keyframes pop {
      0% { transform: scale(.5); opacity: 0; }
      70% { transform: scale(1.1); }
      100% { transform: scale(1);  opacity: 1; }
    }
    h1 { color: #2c3e50; font-size: 26px; margin-bottom: 8px; }
    .sub { color: #7f8c8d; font-size: 15px; margin-bottom: 28px; }
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 28px; text-align: left; }
    .info-table td { padding: 11px 14px; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
    .info-table td:first-child { color: #999; width: 45%; }
    .info-table td:last-child  { color: #2c3e50; font-weight: 600; }
    .badge-success { display:inline-block; background:#d4edda; color:#155724; padding:3px 12px; border-radius:20px; font-size:13px; }
    .badge-sepay { display:inline-block; background:#e8f5e9; color:#2e7d32; padding:3px 12px; border-radius:20px; font-size:12px; }
    .btn-group { display:flex; gap:12px; justify-content:center; flex-wrap:wrap; }
    .btn {
      display:inline-flex; align-items:center; gap:6px;
      padding:12px 26px; border-radius:25px; font-weight:700;
      font-size:14px; text-decoration:none; transition:all .2s;
    }
    .btn-primary { background:#3498db; color:#fff; }
    .btn-primary:hover { background:#2980b9; transform:translateY(-1px); }
    .btn-outline { background:#fff; color:#3498db; border:2px solid #3498db; }
    .btn-outline:hover { background:#3498db; color:#fff; transform:translateY(-1px); }
    .footer-note { margin-top:28px; font-size:12px; color:#bdc3c7; }
  </style>
</head>
<body>
<div class="container">
  <i class="fas fa-check-circle icon-success"></i>
  <h1>Thanh toán thành công!</h1>
  <p class="sub">Giao dịch chuyển khoản của bạn đã được xác nhận qua SePay.</p>

  <%
    Object orderIdObj = request.getAttribute("orderId");
    String displayOrderId;
    if (orderIdObj != null) {
      displayOrderId = String.valueOf(orderIdObj);
    } else {
      String param = request.getParameter("orderId");
      displayOrderId = (param != null && !param.trim().isEmpty()) ? param.trim() : "—";
    }
    request.setAttribute("displayOrderId", displayOrderId);
  %>

  <table class="info-table">
    <tr>
      <td>Mã đơn hàng</td>
      <td>#${displayOrderId}</td>
    </tr>
    <tr>
      <td>Phương thức</td>
      <td><span class="badge-sepay"><i class="fas fa-qrcode"></i> SePay QR Banking</span></td>
    </tr>
    <tr>
      <td>Trạng thái</td>
      <td><span class="badge-success"><i class="fas fa-check"></i> Đã thanh toán</span></td>
    </tr>
  </table>

  <div class="btn-group">
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
      <i class="fas fa-home"></i> Trang chủ
    </a>
    <a href="${pageContext.request.contextPath}/purchase-history" class="btn btn-outline">
      <i class="fas fa-list"></i> Lịch sử đơn hàng
    </a>
  </div>

  <p class="footer-note">
    <i class="fas fa-shield-alt"></i>
    Thanh toán được xử lý an toàn bởi SePay &amp; hệ thống ngân hàng Việt Nam.
  </p>
</div>
</body>
</html>