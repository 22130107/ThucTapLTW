<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Thanh toán</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        background-color: #f4f7f6;
                        margin: 0;
                        padding: 0;
                    }

                    .container {
                        max-width: 800px;
                        margin: 50px auto;
                        background: #fff;
                        padding: 30px;
                        border-radius: 8px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    h2 {
                        color: #333;
                        text-align: center;
                        margin-bottom: 30px;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    label {
                        display: block;
                        margin-bottom: 8px;
                        color: #555;
                        font-weight: 600;
                    }

                    input[type="text"],
                    select {
                        width: 100%;
                        padding: 12px;
                        border: 1px solid #ddd;
                        border-radius: 4px;
                        box-sizing: border-box;
                        font-size: 16px;
                    }

                    .order-summary {
                        background: #f9f9f9;
                        padding: 20px;
                        border-radius: 4px;
                        margin-bottom: 30px;
                    }

                    .order-summary h3 {
                        margin-top: 0;
                        color: #444;
                        border-bottom: 1px solid #eee;
                        padding-bottom: 10px;
                    }

                    .order-item {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 10px;
                        color: #666;
                    }

                    .total-price {
                        font-size: 1.2em;
                        font-weight: bold;
                        color: #e74c3c;
                        text-align: right;
                        margin-top: 15px;
                        border-top: 1px solid #eee;
                        padding-top: 10px;
                    }

                    .btn-submit {
                        display: block;
                        width: 100%;
                        padding: 15px;
                        background-color: #2ecc71;
                        color: white;
                        border: none;
                        border-radius: 4px;
                        font-size: 18px;
                        font-weight: bold;
                        cursor: pointer;
                        transition: background 0.3s;
                    }

                    .btn-submit:hover {
                        background-color: #27ae60;
                    }

                    .error {
                        color: #e74c3c;
                        text-align: center;
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body>

                <div class="container">
                    <h2>Thông tin giao hàng</h2>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <div class="order-summary">
                        <h3>Đơn hàng của bạn</h3>
                        <c:forEach items="${cart.data.values()}" var="item">
                            <div class="order-item">
                                <span>${item.product.name} x ${item.quantity}</span>
                                <span>
                                    <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" />
                                </span>
                            </div>
                        </c:forEach>
                        <div class="total-price">
                            Tổng cộng:
                            <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" />
                        </div>
                    </div>

                    <form action="checkout" method="post">
                        <div class="form-group">
                            <label for="recipientName"><i class="fas fa-user"></i> Tên người nhận</label>
                            <input type="text" id="recipientName" name="recipientName" required
                                placeholder="Nhập tên người nhận">
                        </div>

                        <div class="form-group">
                            <label for="shippingAddress"><i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng</label>
                            <input type="text" id="shippingAddress" name="shippingAddress" required
                                placeholder="Nhập địa chỉ giao hàng">
                        </div>

                        <div class="form-group">
                            <label for="paymentMethod"><i class="fas fa-credit-card"></i> Phương thức thanh toán</label>
                            <select id="paymentMethod" name="paymentMethod">
                                <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                                <option value="BankTransfer">Chuyển khoản ngân hàng</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-submit">Đặt hàng ngay</button>
                    </form>
                </div>

            </body>

            </html>