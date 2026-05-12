<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>MedHome Admin — Đơn hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css"/>
    <style>
        .action-btns { display: flex; gap: 6px; flex-wrap: wrap; }
        .btn-confirm { background: #2ecc71; color: #fff; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .btn-cancel  { background: #e74c3c; color: #fff; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .btn-confirm:hover { background: #27ae60; }
        .btn-cancel:hover  { background: #c0392b; }
        code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 12px; }
    </style>
</head>
<body>

<header class="site-header">
    <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar" aria-expanded="true">☰</button>
    <a href="overview" class="logo">HKH</a>
    <form class="searchbar" action="orders" method="get" role="search">
        <input type="text" name="q" value="${msgName}" placeholder="Tìm đơn hàng (mã/khách)..."/>
        <button type="submit">Tìm</button>
    </form>
    <nav class="header-right">
        <a class="topbtn" href="#" title="Thông báo">🔔</a>
        <a class="topbtn" href="#" title="Tài khoản">👤</a>
    </nav>
</header>

<div class="layout">

    <aside id="sidebar" class="sidebar" aria-hidden="false">
        <div class="sidebar-title">Quản trị</div>
        <nav class="menu">
            <a class="menu-item" href="overview">🏠 Tổng quan</a>
            <a class="menu-item" href="accounts">👥 Tài khoản</a>
            <a class="menu-item" href="products">🧰 Sản phẩm</a>
            <a class="menu-item active" href="orders">🧾 Đơn hàng</a>
            <a class="menu-item" href="appointments">💹 Lịch Khám</a>
        </nav>
    </aside>

    <main class="content">

        <h2>Quản lý đơn hàng</h2>

        <!-- BỘ LỌC -->
        <section class="card" style="padding:12px; margin:10px 0 14px;">
            <form class="form" action="orders" method="get"
                  style="display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:10px; align-items:end;">
                <label>Mã / Khách
                    <input class="input" type="text" name="q" value="${msgName}" placeholder="VD: 10234, Nguyễn Văn A"/>
                </label>
                <label>Trạng thái
                    <select class="input" name="status">
                        <option value="">Tất cả</option>
                        <option value="Pending"    ${msgStatus=='Pending'    ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="Processing" ${msgStatus=='Processing' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="Shipping"   ${msgStatus=='Shipping'   ? 'selected' : ''}>Đang giao</option>
                        <option value="Completed"  ${msgStatus=='Completed'  ? 'selected' : ''}>Đã giao</option>
                        <option value="Cancelled"  ${msgStatus=='Cancelled'  ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </label>
                <label>Từ ngày
                    <input class="input" type="date" name="dateFrom" value="${msgDateFrom}"/>
                </label>
                <label>Đến ngày
                    <input class="input" type="date" name="dateTo" value="${msgDateTo}"/>
                </label>
                <label>Tiền min
                    <input class="input" type="number" name="priceMin" value="${msgPriceMin}" placeholder="0"/>
                </label>
                <label>Tiền max
                    <input class="input" type="number" name="priceMax" value="${msgPriceMax}" placeholder="max"/>
                </label>
                <div class="actions" style="margin:0;">
                    <button class="btn btn-ghost" type="submit">Lọc</button>
                    <a class="btn btn-ghost" href="orders">Reset</a>
                </div>
            </form>
        </section>

        <!-- TOOLBAR -->
        <div class="actions" style="margin-bottom:10px;">
            <form action="orders" method="post" style="display:inline;">
                <input type="hidden" name="action" value="syncGhn"/>
                <button class="btn btn-ghost" type="submit"
                        onclick="return confirm('Đồng bộ trạng thái từ GHN?')">
                    🔄 Đồng bộ GHN
                </button>
            </form>
        </div>

        <!-- BẢNG ĐƠN HÀNG -->
        <section class="card">
            <div class="table-wrap">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Khách</th>
                            <th>Ngày</th>
                            <th>Thanh toán</th>
                            <th>Tổng (₫)</th>
                            <th>Trạng thái</th>
                            <th>Mã GHN</th>
                            <th>Trạng thái GHN</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listO}" var="o">
                            <tr>
                                <td><strong>DH${o.orderId}</strong></td>
                                <td>${o.recipientName}</td>
                                <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${o.paymentMethod}</td>
                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                <td>
                                    <span class="badge ${o.statusCssClass}">${o.statusVietnamese}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty ghnMap[o.orderId]}">
                                            <code>${ghnMap[o.orderId].ghnOrderCode}</code>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty ghnMap[o.orderId] and not empty ghnMap[o.orderId].ghnStatus}">
                                            <small>${ghnMap[o.orderId].ghnStatus}</small>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <c:choose>
                                            <%-- Chỉ Pending mới có hành động thủ công --%>
                                            <c:when test="${o.status == 'Pending'}">
                                                <form action="orders" method="post">
                                                    <input type="hidden" name="action" value="updateStatus"/>
                                                    <input type="hidden" name="id" value="${o.orderId}"/>
                                                    <input type="hidden" name="status" value="Processing"/>
                                                    <button class="btn-confirm" type="submit"
                                                            onclick="return confirm('Xác nhận đơn DH${o.orderId}?\nHệ thống sẽ tạo vận đơn GHN tự động.')">
                                                        ✔ Xác nhận
                                                    </button>
                                                </form>
                                                <form action="orders" method="post">
                                                    <input type="hidden" name="action" value="updateStatus"/>
                                                    <input type="hidden" name="id" value="${o.orderId}"/>
                                                    <input type="hidden" name="status" value="Cancelled"/>
                                                    <button class="btn-cancel" type="submit"
                                                            onclick="return confirm('Hủy đơn DH${o.orderId}?')">
                                                        ✖ Hủy
                                                    </button>
                                                </form>
                                            </c:when>
                                            <%-- Processing/Shipping/Completed/Cancelled: GHN tự cập nhật --%>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <footer class="foot">© 2025 MedHome Admin</footer>

    </main>
</div>

<script src="${pageContext.request.contextPath}/Admin/app.js"></script>

</body>
</html>
