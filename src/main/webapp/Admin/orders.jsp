<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <title>MedHome Admin — Đơn hàng</title>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css" />
            </head>

            <body>

                <!-- HEADER -->
                <header class="site-header">

                    <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar"
                        aria-expanded="true">☰</button>

                    <a href="overview" class="logo">HKH</a>

                    <form class="searchbar" action="#" role="search">
                        <input type="text" placeholder="Tìm đơn hàng (mã/khách)..." />
                        <button type="submit">Tìm</button>
                    </form>

                    <nav class="header-right">
                        <a class="topbtn" href="#" title="Thông báo">🔔</a>
                        <a class="topbtn" href="#" title="Tài khoản">👤</a>
                    </nav>

                </header>

                <!-- LAYOUT -->
                <div class="layout">

                    <!-- SIDEBAR -->
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

                    <!-- CONTENT -->
                    <main class="content">

                        <h2>Quản lý đơn hàng</h2>

                        <!-- BỘ LỌC -->
                        <section class="card" style="padding:12px; margin:10px 0 14px;">

                            <form class="form" action="#" method="get"
                                style="display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:10px; align-items:end;">

                                <label>
                                    Mã / Khách
                                    <input class="input" type="text" name="q" value="${msgName}"
                                        placeholder="VD: 10234, Nguyễn Văn A" />
                                </label>

                                <label>
                                    Trạng thái
                                    <select class="input" name="status">
                                        <option value="">Tất cả</option>
                                        <option ${msgStatus=='Pending' ? 'selected' : '' }>Pending</option>
                                        <option ${msgStatus=='Processing' ? 'selected' : '' }>Processing</option>
                                        <option ${msgStatus=='Shipping' ? 'selected' : '' }>Shipping</option>
                                        <option ${msgStatus=='Completed' ? 'selected' : '' }>Completed</option>
                                        <option ${msgStatus=='Cancelled' ? 'selected' : '' }>Cancelled</option>
                                    </select>
                                </label>

                                <label>
                                    Từ ngày
                                    <input class="input" type="date" name="dateFrom" value="${msgDateFrom}" />
                                </label>

                                <label>
                                    Đến ngày
                                    <input class="input" type="date" name="dateTo" value="${msgDateTo}" />
                                </label>

                                <label>
                                    Tiền min
                                    <input class="input" type="number" name="priceMin" value="${msgPriceMin}"
                                        placeholder="0" />
                                </label>

                                <label>
                                    Tiền max
                                    <input class="input" type="number" name="priceMax" value="${msgPriceMax}"
                                        placeholder="max" />
                                </label>

                                <div class="actions" style="margin:0;">
                                    <button class="btn btn-ghost" type="submit">Lọc</button>
                                    <a class="btn btn-ghost" href="orders">Reset</a>
                                </div>

                            </form>

                        </section>

                        <!-- ACTIONS -->
                        <div class="actions">
                            <a class="btn btn-ghost" href="#modal-status" id="btn-update-status">Cập nhật trạng thái</a>
                        </div>

                        <!-- BẢNG ĐƠN HÀNG -->
                        <section class="card">

                            <div class="table-wrap">

                                <table class="table">

                                    <thead>
                                        <tr>
                                            <th><input type="checkbox" aria-label="Chọn tất cả" /></th>
                                            <th>Mã</th>
                                            <th>Khách</th>
                                            <th>Ngày</th>
                                            <th>Thanh toán</th>
                                            <th>Tổng (₫)</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <c:forEach items="${listO}" var="o">
                                            <tr>
                                                <td><input type="checkbox" aria-label="Chọn" data-id="${o.orderId}"
                                                        data-status="${o.status}" /></td>
                                                <td>DH${o.orderId}</td>
                                                <td>${o.recipientName}</td>
                                                <td>
                                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td>${o.paymentMethod}</td>
                                                <td>
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                        currencySymbol="₫" />
                                                </td>
                                                <td>
                                                    <span
                                                        class="badge ${o.status == 'Completed' ? 'ok' : (o.status == 'Cancelled' ? 'danger' : (o.status == 'Shipping' ? 'warn' : 'secondary'))}">
                                                        ${o.status}
                                                    </span>
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

                <!-- MODALS -->

                <!-- CẬP NHẬT TRẠNG THÁI -->
                <div id="modal-status" class="modal modal-sm">
                    <a href="#" class="modal-overlay" aria-label="Đóng"></a>

                    <div class="modal-body">

                        <h3>Cập nhật trạng thái</h3>

                        <form class="form" action="orders" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" id="status-id">

                            <label>Trạng thái
                                <select class="input" name="status" id="status-select">
                                    <option>Pending</option>
                                    <option>Processing</option>
                                    <option>Shipping</option>
                                    <option>Completed</option>
                                    <option>Cancelled</option>
                                </select>
                            </label>

                            <div class="actions">
                                <a class="btn btn-ghost" href="#">Đóng</a>
                                <button class="btn" type="submit">Lưu</button>
                            </div>

                        </form>

                    </div>

                </div>

                <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
                <script>
                    document.getElementById('btn-update-status').addEventListener('click', function (e) {
                        const checked = document.querySelector('table input[type="checkbox"]:checked');
                        if (checked) {
                            document.getElementById('status-id').value = checked.getAttribute('data-id');
                            document.getElementById('status-select').value = checked.getAttribute('data-status');
                        } else {
                            e.preventDefault();
                            alert("Vui lòng chọn một đơn hàng!");
                        }
                    });
                </script>

            </body>

            </html>