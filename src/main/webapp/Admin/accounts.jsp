<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <title>MedHome Admin — Tài khoản</title>
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
                        <input type="text" placeholder="Tìm người dùng..." />
                        <button type="submit">Tìm</button>
                    </form>
                    <nav class="header-right">
                        <a class="topbtn" href="#" title="Thông báo">🔔</a>
                        <a class="topbtn" href="#" title="Tài khoản">👤</a>
                    </nav>

                </header>

                <!-- MAIN LAYOUT -->
                <div class="layout">

                    <!-- SIDEBAR -->
                    <aside id="sidebar" class="sidebar" aria-hidden="false">

                        <div class="sidebar-title">Quản trị</div>

                        <nav class="menu">
                            <a class="menu-item" href="overview">🏠 Tổng quan</a>
                            <a class="menu-item active" href="accounts">👥 Tài khoản</a>
                            <a class="menu-item" href="products">🧰 Sản phẩm</a>
                            <a class="menu-item" href="orders">🧾 Đơn hàng</a>
                            <a class="menu-item" href="appointments">💹 Lịch Khám</a>
                        </nav>


                    </aside>

                    <!-- CONTENT -->
                    <main class="content">

                        <h2>Quản lý tài khoản</h2>

                        <!-- BỘ LỌC -->
                        <section class="card" style="padding:12px; margin: 10px 0 14px;">

                            <form class="form" action="#" method="get"
                                style="display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:10px; align-items:end;">

                                <label>
                                    Tên / Email
                                    <input class="input" type="text" name="q" value="${msgName}"
                                        placeholder="Nhập từ khóa..." />
                                </label>

                                <label>
                                    Vai trò
                                    <select class="input" name="role">
                                        <option value="">Tất cả</option>
                                        <option ${msgRole=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option ${msgRole=='Customer' ? 'selected' : '' }>Customer</option>
                                    </select>
                                </label>

                                <label>
                                    Trạng thái
                                    <select class="input" name="status">
                                        <option value="">Tất cả</option>
                                        <option ${msgStatus=='Active' ? 'selected' : '' }>Active</option>
                                        <option ${msgStatus=='Locked' ? 'selected' : '' }>Locked</option>
                                        <option ${msgStatus=='Inactive' ? 'selected' : '' }>Inactive</option>
                                    </select>
                                </label>

                                <div class="actions" style="margin:0;">
                                    <button class="btn btn-ghost" type="submit">Lọc</button>
                                    <a class="btn btn-ghost" href="accounts">Reset</a>
                                </div>

                            </form>

                        </section>

                        <!-- THAO TÁC -->
                        <div class="actions">
                            <!-- <a class="btn" href="#modal-add-account">+ Thêm tài khoản</a> -->
                            <a class="btn btn-ghost" href="#modal-edit-account" id="btn-edit">Sửa</a>
                            <!-- <a class="btn btn-ghost" href="#modal-lock">Khóa/Mở khóa</a> -->
                            <!-- <a class="btn btn-danger" href="#modal-delete-account">Xóa</a> -->
                        </div>

                        <!-- BẢNG DỮ LIỆU -->
                        <section class="card">

                            <div class="table-wrap">

                                <table class="table">

                                    <thead>
                                        <tr>
                                            <th><input type="checkbox" aria-label="Chọn tất cả" /></th>
                                            <th>Mã</th>
                                            <th>Tên</th>
                                            <th>Email</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <c:forEach items="${listA}" var="o">
                                            <tr>
                                                <td><input type="checkbox" aria-label="Chọn" data-id="${o.id}"
                                                        data-username="${o.username}" data-email="${o.email}"
                                                        data-role="${o.role}" data-status="${o.status}" />
                                                </td>
                                                <td>U${o.id}</td>
                                                <td>${o.username}</td>
                                                <td>${o.email}</td>
                                                <td><span
                                                        class="badge ${o.role == 'Admin' ? '' : 'secondary'}">${o.role}</span>
                                                </td>
                                                <td>
                                                    <span
                                                        class="badge ${o.status == 'Active' ? 'ok' : (o.status == 'Locked' ? 'danger' : 'warn')}">
                                                        ${o.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy" />
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

                <!-- THÊM -->
                <!-- Modals removed as requested -->

                <!-- SỬA -->
                <div id="modal-edit-account" class="modal">
                    <a href="#" class="modal-overlay" aria-label="Đóng"></a>

                    <div class="modal-body">

                        <h3>Sửa tài khoản</h3>

                        <form class="form" action="accounts" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="edit-id">

                            <label>Tên đăng nhập
                                <input class="input" name="username" id="edit-username" required />
                            </label>

                            <label>Email
                                <input class="input" type="email" name="email" id="edit-email" required />
                            </label>

                            <label>Mật khẩu (để trống nếu giữ nguyên)
                                <input class="input" type="password" name="password" />
                            </label>

                            <label>Vai trò
                                <select class="input" name="role" id="edit-role">
                                    <option>Admin</option>
                                    <option>Customer</option>
                                </select>
                            </label>

                            <label>Trạng thái
                                <select class="input" name="status" id="edit-status">
                                    <option>Active</option>
                                    <option>Locked</option>
                                    <option>Inactive</option>
                                </select>
                            </label>

                            <div class="actions">
                                <a class="btn btn-ghost" href="#">Hủy</a>
                                <button class="btn" type="submit">Cập nhật</button>
                            </div>

                        </form>

                    </div>

                </div>

                <!-- Lock modal removed -->

                <!-- Delete modal removed -->

                <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
                <script>
                    document.getElementById('btn-edit').addEventListener('click', function (e) {
                        const checked = document.querySelector('table input[type="checkbox"]:checked');
                        if (checked) {
                            document.getElementById('edit-id').value = checked.getAttribute('data-id');
                            document.getElementById('edit-username').value = checked.getAttribute('data-username');
                            document.getElementById('edit-email').value = checked.getAttribute('data-email');
                            document.getElementById('edit-role').value = checked.getAttribute('data-role');
                            document.getElementById('edit-status').value = checked.getAttribute('data-status');
                        } else {
                            e.preventDefault();
                            alert("Vui lòng chọn một tài khoản để sửa!");
                        }
                    });
                </script>

            </body>

            </html>