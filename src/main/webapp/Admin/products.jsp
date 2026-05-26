<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <title>MedHome Admin — Sản phẩm</title>
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
                    <form class="searchbar" action="#" role="search">
                        <input type="text" placeholder="Tìm sản phẩm..." />
                        <button type="submit">Tìm</button>
                    </form>
                    <nav class="header-right">
                        <a class="topbtn" href="#" title="Thông báo"><i class="fa-solid fa-bell"></i></a>
                        <span class="topbtn" style="cursor: default;">
                            <i class="fa-solid fa-user"></i> ${auth.username}
                        </span>
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
                            <a class="menu-item active" href="products">Sản phẩm</a>
                            <a class="menu-item" href="promocodes">Khuyến mãi</a>
                            <a class="menu-item" href="orders">Đơn hàng</a>
                        </nav>
                        <div class="sidebar-logout">
                            <a class="logout-btn" href="${pageContext.request.contextPath}/logout"
                               onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                            </a>
                        </div>
                    </aside>

                    <!-- CONTENT -->
                    <main class="content">

                        <h2>Quản lý sản phẩm</h2>

                        <c:if test="${not empty sessionScope.errorMsg}">
                            <div style="color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 12px; border-radius: 4px; margin: 10px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-triangle-exclamation"></i> <strong>Lỗi:</strong> ${sessionScope.errorMsg}
                            </div>
                            <c:remove var="errorMsg" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.successMsg}">
                            <div style="color: #0f5132; background-color: #d1e7dd; border: 1px solid #badbcc; padding: 12px; border-radius: 4px; margin: 10px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-circle-check"></i> <strong>Thành công:</strong> ${sessionScope.successMsg}
                            </div>
                            <c:remove var="successMsg" scope="session" />
                        </c:if>

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
                        <div class="actions" style="gap:8px; flex-wrap:wrap; align-items:center;">
                            <a class="btn" href="#modal-add">Thêm sản phẩm</a>
                            <a class="btn btn-ghost" href="#" id="btn-edit">Sửa</a>
                            <a class="btn btn-danger" href="#" id="btn-delete">Xóa</a>
                            <a class="btn btn-danger" href="#" id="btn-bulk-delete">Xóa đã chọn</a>
                            <span id="selection-count" style="font-size:0.95rem; color:#555;">Đã chọn 0 sản phẩm</span>
                        </div>

                        <!-- BẢNG SẢN PHẨM -->
                        <section class="card">
                            <div class="table-wrap">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><input id="select-all" type="checkbox" aria-label="Chọn tất cả" /></th>
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
                                            <tr data-id="${p.id}" data-name="${fn:escapeXml(p.name)}" data-img="${fn:escapeXml(p.img)}"
                                                data-brand="${fn:escapeXml(p.brand)}" data-price="${p.price}" data-stock="${p.stock}"
                                                data-description="${fn:escapeXml(p.description)}">
                                                <td><input class="bulk-select" type="checkbox" name="selectedIds" value="${p.id}" aria-label="Chọn" /></td>
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

                        <section class="card" style="margin-top:16px; padding:14px; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;">
                            <div style="color:#444;">Tổng <strong>${totalItems}</strong> sản phẩm</div>
                            <div class="pagination" style="display:flex; gap:6px; flex-wrap:wrap;">
                                <c:set var="queryPrefix" value="${not empty queryString ? queryString + '&' : ''}" />
                                <c:if test="${currentPage > 1}">
                                    <a class="btn btn-ghost" href="products?${queryPrefix}page=${currentPage-1}&size=${pageSize}">Trang trước</a>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a class="btn ${i == currentPage ? 'btn-primary' : 'btn btn-ghost'}" href="products?${queryPrefix}page=${i}&size=${pageSize}">${i}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a class="btn btn-ghost" href="products?${queryPrefix}page=${currentPage+1}&size=${pageSize}">Trang sau</a>
                                </c:if>
                            </div>
                        </section>

                    </main>

                </div>

                <!-- MODALS CRUD -->

                <!-- THÊM -->
                <div id="modal-add" class="modal">
                    <a href="#" class="modal-overlay" aria-label="Đóng"></a>
                    <div class="modal-body">
                        <h3>Thêm sản phẩm</h3>
                        <form class="form" action="products" method="post">
                            <input type="hidden" name="csrf_token" value="${csrfToken}" />
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
                            <input type="hidden" name="csrf_token" value="${csrfToken}" />
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
                            <input type="hidden" name="csrf_token" value="${csrfToken}" />
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="delete-id">
                            <div class="actions">
                                <a class="btn btn-ghost" href="#">Hủy</a>
                                <button class="btn btn-danger" type="submit">Xóa vĩnh viễn</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- XÓA NHIỀU -->
                <div id="modal-bulk-delete" class="modal modal-sm">
                    <a href="#" class="modal-overlay" aria-label="Đóng"></a>
                    <div class="modal-body">
                        <h3>Xóa các sản phẩm đã chọn?</h3>
                        <p>Bạn có chắc chắn muốn xóa những sản phẩm này không? Hành động này không thể hoàn tác.</p>
                        <form id="bulk-delete-form" action="products" method="post">
                            <input type="hidden" name="csrf_token" value="${csrfToken}" />
                            <input type="hidden" name="action" value="bulkDelete">
                            <div id="bulk-selected-inputs"></div>
                            <div class="actions">
                                <a class="btn btn-ghost" href="#">Hủy</a>
                                <button class="btn btn-danger" type="submit">Xóa tất cả</button>
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

                    document.getElementById('btn-bulk-delete').addEventListener('click', function (e) {
                        e.preventDefault();
                        const checks = document.querySelectorAll('tbody input.bulk-select:checked');
                        if (checks.length === 0) {
                            alert('Vui lòng chọn ít nhất một sản phẩm để xóa.');
                            return;
                        }
                        const container = document.getElementById('bulk-selected-inputs');
                        container.innerHTML = '';
                        checks.forEach((checkbox) => {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'selectedIds';
                            input.value = checkbox.value;
                            container.appendChild(input);
                        });
                        location.hash = '#modal-bulk-delete';
                    });

                    const selectAllCheckbox = document.getElementById('select-all');
                    const itemCheckboxes = document.querySelectorAll('tbody input.bulk-select');
                    const selectionCount = document.getElementById('selection-count');

                    function updateSelectionCount() {
                        const checkedCount = document.querySelectorAll('tbody input.bulk-select:checked').length;
                        selectionCount.textContent = `Đã chọn ${checkedCount} sản phẩm`;
                    }

                    selectAllCheckbox.addEventListener('change', function () {
                        itemCheckboxes.forEach(cb => cb.checked = selectAllCheckbox.checked);
                        updateSelectionCount();
                    });

                    itemCheckboxes.forEach(cb => cb.addEventListener('change', function () {
                        if (!this.checked) {
                            selectAllCheckbox.checked = false;
                        } else if (document.querySelectorAll('tbody input.bulk-select:not(:checked)').length === 0) {
                            selectAllCheckbox.checked = true;
                        }
                        updateSelectionCount();
                    }));

                    updateSelectionCount();
                </script>
            </body>

            </html>