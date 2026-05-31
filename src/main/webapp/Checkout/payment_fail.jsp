<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thanh toán thất bại</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f7f6;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 20px;
    }
    .container {
      text-align: center;
      background: #fff;
      padding: 50px 40px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      max-width: 520px;
      width: 100%;
    }
    .icon-fail {
      color: #e74c3c;
      font-size: 80px;
      margin-bottom: 20px;
    }
    h1 { color: #2c3e50; font-size: 26px; margin-bottom: 10px; }
    .sub { color: #666; font-size: 16px; margin-bottom: 20px; }
    .error-box {
      background: #fff3cd;
      border: 1px solid #ffc107;
      border-radius: 8px;
      padding: 14px 20px;
      margin-bottom: 30px;
      color: #856404;
      font-size: 15px;
    }
    .error-code {
      background: #f8d7da;
      border: 1px solid #f5c2c7;
      border-radius: 8px;
      padding: 10px;
      margin-bottom: 20px;
      color: #842029;
      font-size: 14px;
    }
    .btn-group { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
    .btn {
      display: inline-block;
      padding: 12px 28px;
      border-radius: 25px;
      font-weight: bold;
      font-size: 15px;
      text-decoration: none;
      transition: all 0.2s;
    }
    .btn-danger { background: #e74c3c; color: white; }
    .btn-danger:hover { background: #c0392b; }
    .btn-outline { background: white; color: #3498db; border: 2px solid #3498db; }
    .btn-outline:hover { background: #3498db; color: white; }
    .codes-table { width: 100%; margin-top: 20px; text-align: left; font-size: 13px; color: #888; }
    .codes-table td { padding: 4px 8px; }
    details summary { cursor: pointer; color: #3498db; font-size: 14px; margin-top: 16px; }
  </style>
</head>
<body>
<div class="container">
  <i class="fas fa-times-circle icon-fail"></i>
  <h1>Thanh toán thất bại</h1>
  <p class="sub">Giao dịch VNPAY của bạn không thành công.</p>

  <c:if test="${not empty errorMessage}">
    <div class="error-box">
      <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
    </div>
  </c:if>

  <c:if test="${not empty responseCode}">
    <div class="error-code">
      Mã lỗi VNPAY: <strong>${responseCode}</strong>
    </div>
  </c:if>

  <div class="btn-group">
    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-danger">
      <i class="fas fa-redo"></i> Thử lại
    </a>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline">
      <i class="fas fa-home"></i> Trang chủ
    </a>
  </div>

  <details>
    <summary>Các mã lỗi phổ biến</summary>
    <table class="codes-table">
      <tr><td><b>07</b></td><td>Giao dịch bị nghi ngờ gian lận</td></tr>
      <tr><td><b>09</b></td><td>Thẻ/Tài khoản chưa đăng ký Internet Banking</td></tr>
      <tr><td><b>10</b></td><td>Xác thực thông tin thẻ/tài khoản sai quá 3 lần</td></tr>
      <tr><td><b>11</b></td><td>Đã hết hạn chờ thanh toán</td></tr>
      <tr><td><b>12</b></td><td>Thẻ/Tài khoản bị khóa</td></tr>
      <tr><td><b>24</b></td><td>Khách hàng hủy giao dịch</td></tr>
      <tr><td><b>51</b></td><td>Tài khoản không đủ số dư</td></tr>
      <tr><td><b>65</b></td><td>Vượt hạn mức giao dịch trong ngày</td></tr>
      <tr><td><b>75</b></td><td>Ngân hàng bảo trì</td></tr>
    </table>
  </details>
</div>
</body>
</html>