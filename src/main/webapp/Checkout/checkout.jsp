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
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        select:disabled {
            background-color: #f0f0f0;
            cursor: not-allowed;
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
        .btn-submit:disabled {
            background-color: #95a5a6;
            cursor: not-allowed;
        }
        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
        }
        .loading-hint {
            font-size: 13px;
            color: #999;
            margin-top: 4px;
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
                <span><fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" /></span>
            </div>
        </c:forEach>
        <div class="total-price">
            Tổng cộng: <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" />
        </div>
    </div>

    <form action="checkout" method="post" id="checkoutForm">

        <div class="form-group">
            <label for="recipientName"><i class="fas fa-user"></i> Tên người nhận</label>
            <input type="text" id="recipientName" name="recipientName" required
                   placeholder="Nhập tên người nhận">
        </div>

        <div class="form-group">
            <label for="recipientPhone"><i class="fas fa-phone"></i> Số điện thoại</label>
            <input type="text" id="recipientPhone" name="recipientPhone" required
                   placeholder="Nhập số điện thoại người nhận"
                   pattern="^(0|\+84)[0-9]{9}$"
                   title="Số điện thoại Việt Nam hợp lệ (VD: 0912345678)">
        </div>

        <!-- Tỉnh/Thành phố -->
        <div class="form-group">
            <label for="provinceSelect"><i class="fas fa-map-marker-alt"></i> Tỉnh / Thành phố</label>
            <select id="provinceSelect" required>
                <option value="">-- Chọn tỉnh/thành phố --</option>
            </select>
            <div class="loading-hint" id="provinceHint"></div>
        </div>

        <!-- Quận/Huyện -->
        <div class="form-group">
            <label for="districtSelect"><i class="fas fa-map"></i> Quận / Huyện</label>
            <select id="districtSelect" name="toDistrictId" required disabled>
                <option value="">-- Chọn quận/huyện --</option>
            </select>
            <div class="loading-hint" id="districtHint"></div>
        </div>

        <!-- Phường/Xã -->
        <div class="form-group">
            <label for="wardSelect"><i class="fas fa-map-pin"></i> Phường / Xã</label>
            <select id="wardSelect" name="toWardCode" required disabled>
                <option value="">-- Chọn phường/xã --</option>
            </select>
            <div class="loading-hint" id="wardHint"></div>
        </div>

        <!-- Địa chỉ chi tiết (số nhà, tên đường) -->
        <div class="form-group">
            <label for="shippingAddress"><i class="fas fa-home"></i> Địa chỉ chi tiết</label>
            <input type="text" id="shippingAddress" name="shippingAddress" required
                   placeholder="Số nhà, tên đường...">
        </div>

        <div class="form-group">
            <label for="paymentMethod"><i class="fas fa-credit-card"></i> Phương thức thanh toán</label>
            <select id="paymentMethod" name="paymentMethod">
                <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                <option value="BankTransfer">Chuyển khoản ngân hàng</option>
            </select>
        </div>

        <button type="submit" class="btn-submit" id="btnSubmit">Đặt hàng ngay</button>
    </form>
</div>

<script>
    // Gọi qua proxy server — token GHN không bị lộ ra client
    const PROXY = "${pageContext.request.contextPath}/ghn-proxy";

    const provinceSelect = document.getElementById("provinceSelect");
    const districtSelect = document.getElementById("districtSelect");
    const wardSelect     = document.getElementById("wardSelect");
    const provinceHint   = document.getElementById("provinceHint");
    const districtHint   = document.getElementById("districtHint");
    const wardHint       = document.getElementById("wardHint");

    // ---- Tải danh sách tỉnh/thành phố ----
    async function loadProvinces() {
        provinceHint.textContent = "Đang tải...";
        try {
            const res  = await fetch(PROXY + "?type=province");
            const json = await res.json();
            if (json.code === 200 && json.data) {
                json.data
                    .sort((a, b) => a.ProvinceName.localeCompare(b.ProvinceName, "vi"))
                    .forEach(p => {
                        const opt = document.createElement("option");
                        opt.value       = p.ProvinceID;
                        opt.textContent = p.ProvinceName;
                        provinceSelect.appendChild(opt);
                    });
                provinceHint.textContent = "";
            } else {
                provinceHint.textContent = "Không tải được danh sách tỉnh.";
            }
        } catch (e) {
            provinceHint.textContent = "Lỗi kết nối máy chủ.";
            console.error(e);
        }
    }

    // ---- Tải danh sách quận/huyện theo tỉnh ----
    async function loadDistricts(provinceId) {
        districtSelect.innerHTML = '<option value="">-- Chọn quận/huyện --</option>';
        wardSelect.innerHTML     = '<option value="">-- Chọn phường/xã --</option>';
        districtSelect.disabled  = true;
        wardSelect.disabled      = true;

        if (!provinceId) return;

        districtHint.textContent = "Đang tải...";
        try {
            const res  = await fetch(PROXY + "?type=district&province_id=" + provinceId);
            const json = await res.json();
            if (json.code === 200 && json.data) {
                json.data
                    .sort((a, b) => a.DistrictName.localeCompare(b.DistrictName, "vi"))
                    .forEach(d => {
                        const opt = document.createElement("option");
                        opt.value       = d.DistrictID;
                        opt.textContent = d.DistrictName;
                        districtSelect.appendChild(opt);
                    });
                districtSelect.disabled  = false;
                districtHint.textContent = "";
            } else {
                districtHint.textContent = "Không tải được danh sách quận/huyện.";
            }
        } catch (e) {
            districtHint.textContent = "Lỗi kết nối máy chủ.";
            console.error(e);
        }
    }

    // ---- Tải danh sách phường/xã theo quận ----
    async function loadWards(districtId) {
        wardSelect.innerHTML = '<option value="">-- Chọn phường/xã --</option>';
        wardSelect.disabled  = true;

        if (!districtId) return;

        wardHint.textContent = "Đang tải...";
        try {
            const res  = await fetch(PROXY + "?type=ward&district_id=" + districtId);
            const json = await res.json();
            if (json.code === 200 && json.data) {
                json.data
                    .sort((a, b) => a.WardName.localeCompare(b.WardName, "vi"))
                    .forEach(w => {
                        const opt = document.createElement("option");
                        opt.value       = w.WardCode;
                        opt.textContent = w.WardName;
                        wardSelect.appendChild(opt);
                    });
                wardSelect.disabled  = false;
                wardHint.textContent = "";
            } else {
                wardHint.textContent = "Không tải được danh sách phường/xã.";
            }
        } catch (e) {
            wardHint.textContent = "Lỗi kết nối máy chủ.";
            console.error(e);
        }
    }

    // ---- Sự kiện ----
    provinceSelect.addEventListener("change", () => loadDistricts(provinceSelect.value));
    districtSelect.addEventListener("change", () => loadWards(districtSelect.value));

    // Validate trước khi submit
    document.getElementById("checkoutForm").addEventListener("submit", function (e) {
        if (!districtSelect.value || !wardSelect.value) {
            e.preventDefault();
            alert("Vui lòng chọn đầy đủ Quận/Huyện và Phường/Xã.");
        }
    });

    // Khởi động
    loadProvinces();
</script>

</body>
</html>
