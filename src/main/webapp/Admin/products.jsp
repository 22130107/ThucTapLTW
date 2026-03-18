<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <title>MedHome Admin — Sản phẩm</title>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css?v=2" />
            </head>

            <body>

                <!-- HEADER -->
                <header class="site-header">
                    <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar"
                        aria-expanded="true">☰</button>
                    <a href="overview" class="logo">HKH</a>
                    <form class="searchbar" action="#" role="search">
                        <input type="text" placeholder="Tìm sản phẩm..." />
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
                            <a class="menu-item active" href="products">🧰 Sản phẩm</a>
                            <a class="menu-item" href="orders">🧾 Đơn hàng</a>
                            <a class="menu-item" href="appointments">💹 Lịch Khám</a>
                        </nav>
                    </aside>

                    <!-- CONTENT -->
                    <main class="content">

                        <h2>Quản lý sản phẩm</h2>

                        <!-- BỘ LỌC -->
                        <section class="card" style="padding:12px; margin:10px 0 14px;">
                            <form class="form" action="products" method="get"
                                style="display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:10px; align-items:end;">
                                <label>
                                    Tên / Mã
                                    <input class="input" type="text" name="q" value="${msgName}"
                                        placeholder="Ví dụ: HEM-7120, nhiệt kế..." />
                                </label>
                                <label>
                                    Thương hiệu
                                    <select class="input" name="brand">
                                        <option value="">Tất cả</option>
                                        <option ${msgBrand=='Omron' ? 'selected' : '' }>Omron</option>
                                        <option ${msgBrand=='Microlife' ? 'selected' : '' }>Microlife</option>
                                        <option ${msgBrand=='Khác' ? 'selected' : '' }>Khác</option>
                                    </select>
                                </label>
                                <label>
                                    Trạng thái
                                    <select class="input" name="status">
                                        <option value="">Tất cả</option>
                                        <option ${msgStatus=='Còn hàng' ? 'selected' : '' }>Còn hàng</option>
                                        <option ${msgStatus=='Hết hàng' ? 'selected' : '' }>Hết hàng</option>
                                    </select>
                                </label>
                                <label>
                                    Khoảng giá (₫)
                                    <input class="input" type="text" name="price" value="${msgPrice}"
                                        placeholder="vd: 100000-1000000" />
                                </label>
                                <div class="actions" style="margin:0;">
                                    <button class="btn btn-ghost" type="submit">Lọc</button>
                                    <a class="btn btn-ghost" href="products">Reset</a>
                                </div>
                            </form>
                        </section>

                        <!-- ACTIONS -->
                        <div class="actions">
                            <a class="btn" href="#modal-add">+ Thêm sản phẩm</a>
                            <a class="btn btn-ghost" href="#modal-edit" id="btn-edit">Sửa</a>
                            <a class="btn btn-danger" href="#modal-delete" id="btn-delete">Xóa</a>
                        </div>

                        <!-- BẢNG SẢN PHẨM -->
                        <section class="card">
                            <div class="table-wrap">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><input type="checkbox" aria-label="Chọn tất cả" /></th>
                                            <th>Mã</th>
                                            <th>Hình ảnh</th>
                                            <th>Tên</th>
                                            <th>Thương hiệu</th>
                                            <th>Giá (₫)</th>
                                            <th>Tồn kho</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listP}" var="p">
                                            <tr data-id="${p.id}" data-name="${p.name}" data-img="${p.img}"
                                                data-brand="${p.brand}" data-price="${p.price}" data-stock="${p.stock}"
                                                data-description="${p.description}">
                                                <td><input type="checkbox" aria-label="Chọn" /></td>
                                                <td>SP${p.id}</td>
                                                <td>
                                                    <img src="${p.img}" alt=""
                                                        style="width:40px; height:40px; object-fit:contain; border:1px solid #eee; border-radius:4px;">
                                                </td>
                                                <td>${p.name}</td>
                                                <td>${p.brand}</td>
                                                <td>
                                                    <fmt:formatNumber value="${p.price}" type="currency"
                                                        currencySymbol="" />
                                                </td>
                                                <td>${p.stock}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.stock > 0}">
                                                            <span class="badge ok">Còn hàng</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge danger">Hết hàng</span>
                                                        </c:otherwise>
                                                    </c:choose>
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

                <!-- MODALS CRUD -->

                <!-- THÊM -->
                <div id="modal-add" class="modal">
                    <a href="#" class="modal-overlay" aria-label="Đóng"></a>
                    <div class="modal-body">
                        <h3>Thêm sản phẩm</h3>
                        <form class="form" action="products" method="post">
                            <input type="hidden" name="action" value="add">
                            <label>Tên
                                <input class="input" name="name" required />
                            </label>
                            <label>Hình ảnh (URL)
                                <div style="display:flex; gap:10px;">
                                    <input class="input" name="img" id="add-img" placeholder="http://..." />
                                    <button type="button" class="btn btn-ghost"
                                        onclick="document.getElementById('upload-add').click()">Tải ảnh</button>
                                    <input type="file" id="upload-add" style="display:none"
                                        onchange="uploadImage(this, 'add-img', 'preview-add')">
                                </div>
                                <img id="preview-add"
                                    style="max-height:100px; margin-top:10px; border-radius:4px; display:none; border: 1px solid #ddd;"
                                    src="" alt="Preview">
                            </label>
                            <label>Thương hiệu
                                <input class="input" name="brand" />
                            </label>
                            <label>Giá (₫)
                                <input class="input" type="number" name="price" min="0" step="1000" required />
                            </label>
                            <label>Tồn kho
                                <input class="input" type="number" name="stock" min="0" required />
                            </label>
                            <label>Mô tả chi tiết
                                <textarea class="input" name="description" id="desc-add" rows="3"></textarea>
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
                        <h3>Sửa sản phẩm</h3>
                        <form class="form" id="form-edit" action="products" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="edit-id">
                            <label>Tên
                                <input class="input" name="name" id="edit-name" required />
                            </label>
                            <label>Hình ảnh (URL)
                                <div style="display:flex; gap:10px;">
                                    <input class="input" name="img" id="edit-img" placeholder="http://..." />
                                    <button type="button" class="btn btn-ghost"
                                        onclick="document.getElementById('upload-edit').click()">Tải ảnh</button>
                                    <input type="file" id="upload-edit" style="display:none"
                                        onchange="uploadImage(this, 'edit-img', 'preview-edit')">
                                </div>
                                <img id="preview-edit"
                                    style="max-height:100px; margin-top:10px; border-radius:4px; display:none; border: 1px solid #ddd;"
                                    src="" alt="Preview">
                            </label>
                            <label>Thương hiệu
                                <input class="input" name="brand" id="edit-brand" />
                            </label>
                            <label>Giá (₫)
                                <input class="input" type="number" name="price" id="edit-price" min="0" step="1000"
                                    required />
                            </label>
                            <label>Tồn kho
                                <input class="input" type="number" name="stock" id="edit-stock" min="0" required />
                            </label>
                            <label>Mô tả chi tiết
                                <textarea class="input" name="description" id="edit-desc" rows="3"></textarea>
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
                        <h3>Xóa sản phẩm?</h3>
                        <p>Bạn có chắc chắn muốn xóa sản phẩm này không? Hành động này không thể hoàn tác.</p>
                        <form action="products" method="post">
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
                <!-- CKEditor 4 CDN -->
                <script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>
                <script>
                    // Init CKEditor for Add Modal
                    CKEDITOR.replace('desc-add', {
                        height: 200,
                        removePlugins: 'exportpdf',
                        versionCheck: false,
                        uploadUrl: '${pageContext.request.contextPath}/api/upload',
                        filebrowserUploadUrl: '${pageContext.request.contextPath}/api/upload',
                        filebrowserImageUploadUrl: '${pageContext.request.contextPath}/api/upload'
                    });

                    // Init CKEditor for Edit Modal
                    CKEDITOR.replace('edit-desc', {
                        height: 200,
                        removePlugins: 'exportpdf',
                        versionCheck: false,
                        uploadUrl: '${pageContext.request.contextPath}/api/upload',
                        filebrowserUploadUrl: '${pageContext.request.contextPath}/api/upload',
                        filebrowserImageUploadUrl: '${pageContext.request.contextPath}/api/upload'
                    });

                    // Function to handle Main Image Upload
                    function uploadImage(fileInput, targetId, previewId) {
                        const file = fileInput.files[0];
                        if (!file) return;

                        const formData = new FormData();
                        formData.append("upload", file);

                        // Show loading state
                        const target = document.getElementById(targetId);
                        const originalPlaceholder = target.placeholder;
                        target.placeholder = "Đang tải lên...";

                        fetch('${pageContext.request.contextPath}/api/upload', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.uploaded) {
                                    target.value = data.url;

                                    // Show preview
                                    if (previewId) {
                                        const img = document.getElementById(previewId);
                                        img.src = data.url;
                                        img.style.display = 'block';
                                    }

                                    alert("Upload ảnh thành công!");
                                } else {
                                    alert("Lỗi: " + (data.error ? data.error.message : 'Unknown error'));
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert("Lỗi kết nối khi upload file");
                            })
                            .finally(() => {
                                target.placeholder = originalPlaceholder;
                                fileInput.value = ''; // Reset input
                            });
                    }

                    document.getElementById('btn-edit').addEventListener('click', function (e) {
                        // Find checked checkboxes in table body
                        const checks = document.querySelectorAll('tbody input[type="checkbox"]:checked');

                        if (checks.length === 0) {
                            e.preventDefault();
                            alert('Vui lòng chọn một sản phẩm để sửa!');
                            return;
                        }

                        if (checks.length > 1) {
                            e.preventDefault();
                            alert('Chỉ được chọn 1 sản phẩm để sửa!');
                            return;
                        }

                        // Get data
                        const tr = checks[0].closest('tr');
                        const data = tr.dataset;

                        // Fill form
                        if (data.id) document.getElementById('edit-id').value = data.id;
                        if (data.name) document.getElementById('edit-name').value = data.name;
                        if (data.img) {
                            document.getElementById('edit-img').value = data.img;
                            // Show existing image preview
                            const imgPreview = document.getElementById('preview-edit');
                            imgPreview.src = data.img;
                            imgPreview.style.display = 'block';
                        } else {
                            // Hide preview if no image
                            document.getElementById('preview-edit').style.display = 'none';
                        }
                        if (data.brand) document.getElementById('edit-brand').value = data.brand;
                        if (data.price) document.getElementById('edit-price').value = data.price;
                        if (data.stock) document.getElementById('edit-stock').value = data.stock;

                        // Set CKEditor data
                        if (data.description) {
                            CKEDITOR.instances['edit-desc'].setData(data.description);
                        }
                    });
                    document.getElementById('btn-delete').addEventListener('click', function (e) {
                        const checks = document.querySelectorAll('tbody input[type="checkbox"]:checked');

                        if (checks.length === 0) {
                            e.preventDefault();
                            alert('Vui lòng chọn một sản phẩm để xóa!');
                            return;
                        }

                        if (checks.length > 1) {
                            e.preventDefault();
                            alert('Vui lòng chỉ chọn 1 sản phẩm để xóa!');
                            return;
                        }

                        const tr = checks[0].closest('tr');
                        const id = tr.dataset.id;
                        document.getElementById('delete-id').value = id;
                    });
                </script>
            </body>

            </html>