<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <title>MedHome Admin — Danh mục</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css?v=2" />
</head>

<body>

    <!-- HEADER -->
    <header class="site-header">
        <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar"
            aria-expanded="true">☰</button>
        <a href="overview" class="logo">HKH</a>
        <div class="searchbar">
            <input type="text" placeholder="Tìm nhanh..." disabled />
        </div>
        <nav class="header-right">
            <a class="topbtn" href="#" title="Thông báo"><i class="fa-solid fa-bell"></i></a>
            <a class="topbtn" href="#" title="Tài khoản"><i class="fa-solid fa-user"></i></a>
        </nav>
    </header>

    <!-- LAYOUT -->
    <div class="layout">

        <!-- SIDEBAR -->
        <aside id="sidebar" class="sidebar" aria-hidden="false">
            <div class="sidebar-title">Quản trị</div>
            <nav class="menu">
                <a class="menu-item" href="overview">Tổng quan</a>
                <a class="menu-item" href="accounts">Tài khoản</a>
                <a class="menu-item" href="products">Sản phẩm</a>
                <a class="menu-item" href="orders">Đơn hàng</a>
                <a class="menu-item" href="appointments">Lịch khám</a>
            </nav>
        </aside>

        <!-- CONTENT -->
        <main class="content">

            <h2>Quản lý danh mục sản phẩm</h2>

            <!-- ACTIONS -->
            <div class="actions" style="margin: 15px 0;">
                <a class="btn" href="#modal-add">+ Thêm danh mục</a>
                <a class="btn btn-ghost" href="#modal-edit" id="btn-edit">Sửa danh mục</a>
                <a class="btn btn-danger" href="#modal-delete" id="btn-delete">Xóa danh mục</a>
            </div>

            <!-- BẢNG DANH MỤC -->
            <section class="card">
                <div class="table-wrap">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="check-all" aria-label="Chọn tất cả" /></th>
                                <th>Mã danh mục</th>
                                <th>Hình ảnh</th>
                                <th>Tên danh mục</th>
                                <th>Mô tả</th>
                                <th>Thứ tự hiển thị</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${categories}" var="cat">
                                <tr data-id="${cat.categoryID}" data-name="${cat.categoryName}" data-desc="${cat.description}"
                                    data-order="${cat.displayOrder}" data-img="${cat.image}">
                                    <td><input type="checkbox" class="cat-check" aria-label="Chọn" /></td>
                                    <td>DM${cat.categoryID}</td>
                                    <td>
                                        <c:if test="${not empty cat.image}">
                                            <img src="${cat.image}" alt=""
                                                style="width:40px; height:40px; object-fit:contain; border:1px solid #eee; border-radius:4px;">
                                        </c:if>
                                        <c:if test="${empty cat.image}">
                                            <span style="color:#aaa; font-size:12px;">Không có</span>
                                        </c:if>
                                    </td>
                                    <td><strong>${cat.categoryName}</strong></td>
                                    <td>${cat.description}</td>
                                    <td>${cat.displayOrder}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

        </main>

    </div>

    <!-- MODALS CRUD -->

    <!-- THÊM -->
    <div id="modal-add" class="modal">
        <a href="#" class="modal-overlay" aria-label="Đóng"></a>
        <div class="modal-body">
            <h3>Thêm danh mục</h3>
            <form class="form" action="categories" method="post">
                <input type="hidden" name="action" value="add">
                <label>Tên danh mục
                    <input class="input" name="name" required />
                </label>
                <label>Mô tả
                    <input class="input" name="description" />
                </label>
                <label>Thứ tự hiển thị
                    <input class="input" type="number" name="displayOrder" value="0" required />
                </label>
                <label>Hình ảnh (URL)
                    <input class="input" name="image" placeholder="http://..." />
                </label>
                <div class="actions">
                    <a class="btn btn-ghost" href="#">Hủy</a>
                    <button class="btn" type="submit">Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- SỬA -->
    <div id="modal-edit" class="modal">
        <a href="#" class="modal-overlay" aria-label="Đóng"></a>
        <div class="modal-body">
            <h3>Sửa danh mục</h3>
            <form class="form" id="form-edit" action="categories" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="edit-id">
                <label>Tên danh mục
                    <input class="input" name="name" id="edit-name" required />
                </label>
                <label>Mô tả
                    <input class="input" name="description" id="edit-desc" />
                </label>
                <label>Thứ tự hiển thị
                    <input class="input" type="number" name="displayOrder" id="edit-order" required />
                </label>
                <label>Hình ảnh (URL)
                    <input class="input" name="image" id="edit-img" placeholder="http://..." />
                </label>
                <div class="actions">
                    <a class="btn btn-ghost" href="#">Hủy</a>
                    <button class="btn" type="submit">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <!-- XÓA -->
    <div id="modal-delete" class="modal modal-sm">
        <a href="#" class="modal-overlay" aria-label="Đóng"></a>
        <div class="modal-body">
            <h3>Xóa danh mục?</h3>
            <p>Bạn có chắc chắn muốn xóa danh mục này không? Các sản phẩm thuộc danh mục này sẽ có thể bị ảnh hưởng.</p>
            <form action="categories" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="delete-id">
                <div class="actions">
                    <a class="btn btn-ghost" href="#">Hủy</a>
                    <button class="btn btn-danger" type="submit">Xóa vĩnh viễn</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
    <script>
        // Check all functionality
        document.getElementById('check-all').addEventListener('change', function () {
            const checks = document.querySelectorAll('.cat-check');
            checks.forEach(c => c.checked = this.checked);
        });

        // Edit button handler
        document.getElementById('btn-edit').addEventListener('click', function (e) {
            const checks = document.querySelectorAll('.cat-check:checked');

            if (checks.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn một danh mục để sửa!');
                return;
            }

            if (checks.length > 1) {
                e.preventDefault();
                alert('Chỉ được chọn 1 danh mục để sửa!');
                return;
            }

            const tr = checks[0].closest('tr');
            const data = tr.dataset;

            document.getElementById('edit-id').value = data.id;
            document.getElementById('edit-name').value = data.name;
            document.getElementById('edit-desc').value = data.desc;
            document.getElementById('edit-order').value = data.order;
            document.getElementById('edit-img').value = data.img;
        });

        // Delete button handler
        document.getElementById('btn-delete').addEventListener('click', function (e) {
            const checks = document.querySelectorAll('.cat-check:checked');

            if (checks.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn một danh mục để xóa!');
                return;
            }

            if (checks.length > 1) {
                e.preventDefault();
                alert('Vui lòng chỉ chọn 1 danh mục để xóa!');
                return;
            }

            const tr = checks[0].closest('tr');
            const id = tr.dataset.id;
            document.getElementById('delete-id').value = id;
        });
    </script>
</body>

</html>
