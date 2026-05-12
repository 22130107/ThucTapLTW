<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>MedHome Admin — Mã khuyến mãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css?v=3" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<header class="site-header">
    <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar" aria-expanded="true">☰</button>
    <a href="overview" class="logo">HKH</a>
    <div class="searchbar">
        <input type="text" placeholder="Tìm nhanh..." disabled />
        <button type="button">Tìm</button>
    </div>
    <nav class="header-right">
        <a class="topbtn" href="#" title="Thông báo"><i class="fa-solid fa-bell"></i></a>
        <span class="topbtn" style="cursor: default;">
            <i class="fa-solid fa-user"></i> ${auth.username}
        </span>
    </nav>
</header>
<div class="layout">
    <aside id="sidebar" class="sidebar" aria-hidden="false">
        <div class="sidebar-title">Quản trị</div>
        <nav class="menu">
            <a class="menu-item" href="overview">Tổng quan</a>
            <a class="menu-item" href="accounts">Tài khoản</a>
            <a class="menu-item" href="products">Sản phẩm</a>
            <a class="menu-item active" href="promocodes">Khuyến mãi</a>
            <a class="menu-item" href="orders">Đơn hàng</a>
        </nav>
        <div class="sidebar-logout">
            <a class="logout-btn" href="${pageContext.request.contextPath}/logout"
               onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </aside>
    <main class="content">
        <h2>Quản lý mã khuyến mãi</h2>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-error">${sessionScope.errorMsg}</div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success">${sessionScope.successMsg}</div>
        <c:remove var="successMsg" scope="session" />
    </c:if>

    <div style="margin:12px 0;">
        <a class="btn" href="#modal-add">Tạo mã mới</a>
    </div>

    <section class="card">
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Code</th>
                    <th>Loại</th>
                    <th>Amount</th>
                    <th>Used/Limit</th>
                    <th>Active</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="p">
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.code}</td>
                        <td>${p.type}</td>
                        <td><fmt:formatNumber value="${p.amount}" type="currency" currencySymbol=""/></td>
                        <td>${p.usedCount}/${p.usageLimit}</td>
                        <td>${p.active ? 'Yes' : 'No'}</td>
                        <td>
                            <a class="btn btn-ghost" href="#" onclick="openEdit(${p.id})">Sửa</a>
                            <form action="promocodes" method="post" style="display:inline">
                                <input type="hidden" name="csrf_token" value="${csrfToken}" />
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="${p.id}" />
                                <button class="btn btn-danger" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </section>

    <!-- Add Modal -->
    <div id="modal-add" class="modal">
        <a href="#" class="modal-overlay" aria-label="Đóng"></a>
        <div class="modal-body">
            <h3>Tạo mã khuyến mãi</h3>
            <form action="promocodes" method="post" class="form">
                <input type="hidden" name="csrf_token" value="${csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <label>Code<input class="input" name="code" required /></label>
                <label>Loại
                    <select name="type" class="input">
                        <option value="percent">Phần trăm</option>
                        <option value="fixed">Tiền cố định</option>
                    </select>
                </label>
                <label>Giá trị<input class="input" name="amount" required /></label>
                <label>Min order (VNĐ)<input class="input" name="minOrderValue" /></label>
                <label>Start<input type="datetime-local" name="startAt" class="input" /></label>
                <label>End<input type="datetime-local" name="endAt" class="input" /></label>
                <label>Usage limit<input class="input" name="usageLimit" /></label>
                <label>Applies to
                    <select name="appliesTo" class="input">
                        <option value="all">Tất cả</option>
                        <option value="category">Danh mục</option>
                        <option value="product">Sản phẩm</option>
                    </select>
                </label>
                <label>AppliesToId (nếu cần)<input class="input" name="appliesToId" /></label>
                <label><input type="checkbox" name="active" checked /> Active</label>
                <div class="actions"><a class="btn btn-ghost" href="#">Hủy</a><button class="btn" type="submit">Lưu</button></div>
            </form>
        </div>
    </div>

    <script>
        function openEdit(id) {
            // Simple redirect to edit via query param (server could render edit form)
            window.location = 'promocodes?id=' + id;
        }
    </script>

</main>
</body>
</html>
