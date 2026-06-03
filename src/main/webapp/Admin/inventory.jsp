<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <title>MedHome Admin — Kho hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css?v=2" />
    <style>
        .tab-nav { display:flex; gap:4px; margin-bottom:20px; border-bottom:2px solid #e2e8f0; padding-bottom:0; }
        .tab-nav a { padding:10px 20px; text-decoration:none; color:#64748b; font-weight:600; font-size:14px; border-radius:8px 8px 0 0; transition:all .2s; }
        .tab-nav a:hover { background:#f1f5f9; color:#0f172a; }
        .tab-nav a.active { background:#1f8fe5; color:#fff; }
        .tab-nav a i { margin-right:6px; }
        .inv-row { display:flex; gap:12px; align-items:end; margin-bottom:10px; }
        .inv-row label { flex:1; }
        .inv-row label select,
        .inv-row label input { width:100%; }
        .inv-remove { color:#ef4444; cursor:pointer; padding:8px; }
        .inv-add-row { color:#1f8fe5; cursor:pointer; font-weight:600; }
        .badge-low { background:#fef3c7; color:#92400e; padding:2px 8px; border-radius:4px; font-size:12px; }
        .badge-ok { background:#d1fae5; color:#065f46; padding:2px 8px; border-radius:4px; font-size:12px; }
        .badge-out { background:#fee2e2; color:#991b1b; padding:2px 8px; border-radius:4px; font-size:12px; }
        .qty-pos { color:#059669; font-weight:600; }
        .qty-neg { color:#dc2626; font-weight:600; }
        .search-product { position:relative; }
        .search-product input { width:100%; }
        .product-dropdown { position:absolute; top:100%; left:0; right:0; max-height:200px; overflow-y:auto; background:#fff; border:1px solid #e2e8f0; border-radius:6px; z-index:100; display:none; box-shadow:0 4px 12px rgba(0,0,0,.1); }
        .product-dropdown .pd-item { padding:8px 12px; cursor:pointer; display:flex; justify-content:space-between; border-bottom:1px solid #f1f5f9; }
        .product-dropdown .pd-item:hover { background:#f1f5f9; }
        .product-dropdown .pd-item .pd-stock { font-size:12px; color:#64748b; }
    </style>
</head>

<body>

    <!-- HEADER -->
    <header class="site-header">
        <button id="btn-toggle" class="hamburger" aria-label="Mở/đóng menu" aria-controls="sidebar"
            aria-expanded="true">☰</button>
        <a href="overview" class="logo">HKH</a>
        <form class="searchbar" action="#" role="search">
            <input type="text" placeholder="Tìm nhanh..." />
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
                <a class="menu-item" href="products">Sản phẩm</a>
                <a class="menu-item" href="categories">Danh mục</a>
                <a class="menu-item" href="promocodes">Khuyến mãi</a>
                <a class="menu-item" href="orders">Đơn hàng</a>
                <a class="menu-item active" href="inventory">Kho hàng
                    <c:if test="${lowStockCount > 0}">
                        <span class="badge danger" style="float:right;">${lowStockCount}</span>
                    </c:if>
                </a>
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

            <h2>Quản lý kho hàng</h2>

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

            <!-- Tab Navigation -->
            <div class="tab-nav">
                <a class="${currentTab == 'list' ? 'active' : ''}" href="inventory?tab=list"><i class="fa-solid fa-list"></i> Lịch sử</a>
                <a class="${currentTab == 'import' ? 'active' : ''}" href="inventory?tab=import"><i class="fa-solid fa-arrow-down"></i> Nhập kho</a>
                <a class="${currentTab == 'export' ? 'active' : ''}" href="inventory?tab=export"><i class="fa-solid fa-arrow-up"></i> Xuất kho</a>
                <a class="${currentTab == 'adjust' ? 'active' : ''}" href="inventory?tab=adjust"><i class="fa-solid fa-scale-balanced"></i> Kiểm kê</a>
            </div>

            <!-- Tab: Danh sách lịch sử -->
            <c:if test="${currentTab == 'list'}">
                <section class="card">
                    <c:if test="${empty transactions}">
                        <p style="padding:20px; text-align:center; color:#64748b;">Chưa có giao dịch nào.</p>
                    </c:if>
                    <c:if test="${not empty transactions}">
                        <div class="table-wrap">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mã</th>
                                        <th>Loại</th>
                                        <th>Ghi chú</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${transactions}">
                                        <tr>
                                            <td>#${t.id}</td>
                                            <td><span class="badge ${t.type == 'import' || t.type == 'order_cancel_return' ? 'ok' : 'danger'}">${t.typeVietnamese}</span></td>
                                            <td>${t.note}</td>
                                            <td><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td><a class="btn btn-ghost" href="inventory?tab=detail&id=${t.id}">Chi tiết</a></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </section>
            </c:if>

            <!-- Tab: Chi tiết giao dịch -->
            <c:if test="${currentTab == 'detail'}">
                <c:if test="${not empty transaction}">
                    <section class="card" style="padding:20px;">
                        <h3>Giao dịch #${transaction.id}</h3>
                        <p><strong>Loại:</strong> ${transaction.typeVietnamese}</p>
                        <p><strong>Ghi chú:</strong> ${transaction.note}</p>
                        <p><strong>Ngày:</strong> <fmt:formatDate value="${transaction.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                        <c:if test="${not empty transaction.referenceId}">
                            <p><strong>Tham chiếu:</strong> Đơn hàng #${transaction.referenceId}</p>
                        </c:if>

                        <h4 style="margin-top:16px;">Chi tiết sản phẩm</h4>
                        <div class="table-wrap">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Số lượng</th>
                                        <th>Tồn sau</th>
                                        <th>Ghi chú</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${transaction.items}">
                                        <tr>
                                            <td>${item.productName}</td>
                                            <td class="${item.quantityChange > 0 ? 'qty-pos' : 'qty-neg'}">${item.quantityFormatted}</td>
                                            <td>${item.currentStock}</td>
                                            <td>${item.note}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <a class="btn btn-ghost" href="inventory?tab=list" style="margin-top:12px;">← Quay lại</a>
                    </section>
                </c:if>
                <c:if test="${empty transaction}">
                    <p>Không tìm thấy giao dịch.</p>
                    <a class="btn btn-ghost" href="inventory?tab=list">← Quay lại</a>
                </c:if>
            </c:if>

            <!-- Tab: Nhập kho -->
            <c:if test="${currentTab == 'import'}">
                <section class="card" style="padding:20px;">
                    <form class="form" action="inventory" method="post">
                        <input type="hidden" name="action" value="import">

                        <div id="import-rows">
                            <div class="inv-row">
                                <label>Sản phẩm
                                    <div class="search-product">
                                        <input class="input" type="text" name="productSearch" placeholder="Gõ tên sản phẩm..." autocomplete="off" data-index="0" />
                                        <input type="hidden" name="productId" value="" />
                                        <div class="product-dropdown" data-index="0"></div>
                                    </div>
                                </label>
                                <label>Số lượng
                                    <input class="input" type="number" name="quantity" min="1" required />
                                </label>
                                <span class="inv-remove" onclick="this.closest('.inv-row').remove()"><i class="fa-solid fa-trash-can"></i></span>
                            </div>
                        </div>

                        <span class="inv-add-row" onclick="addImportRow()"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</span>

                        <label style="margin-top:12px; display:block;">Ghi chú
                            <textarea class="input" name="note" rows="2" placeholder="Lý do nhập kho..."></textarea>
                        </label>

                        <div class="actions" style="margin-top:12px;">
                            <a class="btn btn-ghost" href="inventory?tab=list">Hủy</a>
                            <button class="btn" type="submit">Xác nhận nhập kho</button>
                        </div>
                    </form>
                </section>
            </c:if>

            <!-- Tab: Xuất kho -->
            <c:if test="${currentTab == 'export'}">
                <section class="card" style="padding:20px;">
                    <form class="form" action="inventory" method="post">
                        <input type="hidden" name="action" value="export">

                        <div id="export-rows">
                            <div class="inv-row">
                                <label>Sản phẩm
                                    <div class="search-product">
                                        <input class="input" type="text" name="productSearch" placeholder="Gõ tên sản phẩm..." autocomplete="off" data-index="0" />
                                        <input type="hidden" name="productId" value="" />
                                        <div class="product-dropdown" data-index="0"></div>
                                    </div>
                                </label>
                                <label>Số lượng
                                    <input class="input" type="number" name="quantity" min="1" required />
                                </label>
                                <span class="inv-remove" onclick="this.closest('.inv-row').remove()"><i class="fa-solid fa-trash-can"></i></span>
                            </div>
                        </div>

                        <span class="inv-add-row" onclick="addExportRow()"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</span>

                        <label style="margin-top:12px; display:block;">Ghi chú
                            <textarea class="input" name="note" rows="2" placeholder="Lý do xuất kho..."></textarea>
                        </label>

                        <div class="actions" style="margin-top:12px;">
                            <a class="btn btn-ghost" href="inventory?tab=list">Hủy</a>
                            <button class="btn" type="submit">Xác nhận xuất kho</button>
                        </div>
                    </form>
                </section>
            </c:if>

            <!-- Tab: Kiểm kê -->
            <c:if test="${currentTab == 'adjust'}">
                <section class="card" style="padding:20px;">
                    <form class="form" action="inventory" method="post">
                        <input type="hidden" name="action" value="adjust">

                        <div id="adjust-rows">
                            <div class="inv-row">
                                <label>Sản phẩm
                                    <div class="search-product">
                                        <input class="input" type="text" name="productSearch" placeholder="Gõ tên sản phẩm..." autocomplete="off" data-index="0" />
                                        <input type="hidden" name="productId" value="" />
                                        <div class="product-dropdown" data-index="0"></div>
                                    </div>
                                </label>
                                <label>Tồn mới
                                    <input class="input" type="number" name="newStock" min="0" required />
                                </label>
                                <span class="inv-remove" onclick="this.closest('.inv-row').remove()"><i class="fa-solid fa-trash-can"></i></span>
                            </div>
                        </div>

                        <span class="inv-add-row" onclick="addAdjustRow()"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</span>

                        <label style="margin-top:12px; display:block;">Ghi chú
                            <textarea class="input" name="note" rows="2" placeholder="Lý do kiểm kê..."></textarea>
                        </label>

                        <div class="actions" style="margin-top:12px;">
                            <a class="btn btn-ghost" href="inventory?tab=list">Hủy</a>
                            <button class="btn" type="submit">Xác nhận kiểm kê</button>
                        </div>
                    </form>
                </section>
            </c:if>

        </main>

    </div>

    <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
    <script>
        // Product data from server
        const allProducts = [
            <c:forEach var="p" items="${products}" varStatus="loop">
                { id: ${p.id}, name: "<c:out value='${p.name}' />", stock: ${p.stock} }${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        function initProductSearch(container, rowIndex) {
            const input = container.querySelector('input[name="productSearch"]');
            const hidden = container.querySelector('input[name="productId"]');
            const dropdown = container.querySelector('.product-dropdown');

            input.addEventListener('input', function() {
                const q = this.value.toLowerCase().trim();
                dropdown.innerHTML = '';
                if (!q) { dropdown.style.display = 'none'; return; }

                const matches = allProducts.filter(p =>
                    p.name.toLowerCase().includes(q)
                ).slice(0, 15);

                if (matches.length === 0) {
                    dropdown.style.display = 'none';
                    return;
                }

                matches.forEach(p => {
                    const div = document.createElement('div');
                    div.className = 'pd-item';
                    div.innerHTML = '<span>' + p.name + '</span><span class="pd-stock">Tồn: ' + p.stock + '</span>';
                    div.addEventListener('click', function() {
                        input.value = p.name;
                        hidden.value = p.id;
                        dropdown.style.display = 'none';
                    });
                    dropdown.appendChild(div);
                });
                dropdown.style.display = 'block';
            });

            input.addEventListener('blur', function() {
                setTimeout(() => { dropdown.style.display = 'none'; }, 200);
            });

            input.addEventListener('focus', function() {
                if (this.value.trim()) this.dispatchEvent(new Event('input'));
            });
        }

        function createProductSearchRow(index) {
            const div = document.createElement('div');
            div.className = 'search-product';
            div.innerHTML = '<input class="input" type="text" name="productSearch" placeholder="Gõ tên sản phẩm..." autocomplete="off" data-index="' + index + '" />' +
                '<input type="hidden" name="productId" value="" />' +
                '<div class="product-dropdown" data-index="' + index + '"></div>';
            return div;
        }

        function addImportRow() {
            const container = document.getElementById('import-rows');
            const idx = container.children.length;
            const row = document.createElement('div');
            row.className = 'inv-row';
            row.innerHTML = '<label>Sản phẩm' + createProductSearchRow(idx).innerHTML + '</label>' +
                '<label>Số lượng<input class="input" type="number" name="quantity" min="1" required /></label>' +
                '<span class="inv-remove" onclick="this.closest(\'.inv-row\').remove()"><i class="fa-solid fa-trash-can"></i></span>';
            container.appendChild(row);
            initProductSearch(row, idx);
        }

        function addExportRow() {
            const container = document.getElementById('export-rows');
            const idx = container.children.length;
            const row = document.createElement('div');
            row.className = 'inv-row';
            row.innerHTML = '<label>Sản phẩm' + createProductSearchRow(idx).innerHTML + '</label>' +
                '<label>Số lượng<input class="input" type="number" name="quantity" min="1" required /></label>' +
                '<span class="inv-remove" onclick="this.closest(\'.inv-row\').remove()"><i class="fa-solid fa-trash-can"></i></span>';
            container.appendChild(row);
            initProductSearch(row, idx);
        }

        function addAdjustRow() {
            const container = document.getElementById('adjust-rows');
            const idx = container.children.length;
            const row = document.createElement('div');
            row.className = 'inv-row';
            row.innerHTML = '<label>Sản phẩm' + createProductSearchRow(idx).innerHTML + '</label>' +
                '<label>Tồn mới<input class="input" type="number" name="newStock" min="0" required /></label>' +
                '<span class="inv-remove" onclick="this.closest(\'.inv-row\').remove()"><i class="fa-solid fa-trash-can"></i></span>';
            container.appendChild(row);
            initProductSearch(row, idx);
        }

        // Init existing rows
        document.querySelectorAll('.search-product').forEach(el => {
            const idx = el.querySelector('input[data-index]')?.dataset.index || 0;
            initProductSearch(el.parentElement, parseInt(idx));
        });
    </script>

</body>
</html>
