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
                <a class="${currentTab == 'dashboard' ? 'active' : ''}" href="inventory?tab=dashboard"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
                <a class="${currentTab == 'list' ? 'active' : ''}" href="inventory?tab=list"><i class="fa-solid fa-list"></i> Lịch sử</a>
                <a class="${currentTab == 'import' ? 'active' : ''}" href="inventory?tab=import"><i class="fa-solid fa-arrow-down"></i> Nhập kho</a>
                <a class="${currentTab == 'export' ? 'active' : ''}" href="inventory?tab=export"><i class="fa-solid fa-arrow-up"></i> Xuất kho</a>
                <a class="${currentTab == 'adjust' ? 'active' : ''}" href="inventory?tab=adjust"><i class="fa-solid fa-scale-balanced"></i> Kiểm kê</a>
            </div>

            <!-- Tab: Dashboard (Quản lý tồn kho) -->
            <c:if test="${currentTab == 'dashboard'}">
                <style>
                    .dash-stats { display: flex; gap: 20px; margin-bottom: 24px; flex-wrap: wrap; }
                    .stat-card { 
                        flex: 1; min-width: 200px; background: #fff; border-radius: 12px; 
                        padding: 20px; display: flex; align-items: center; gap: 16px; 
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); 
                        border: 1px solid #f1f5f9;
                    }
                    .stat-icon { 
                        width: 48px; height: 48px; border-radius: 12px; 
                        display: flex; align-items: center; justify-content: center; font-size: 20px; 
                    }
                    .ic-variants { background: #e0e7ff; color: #4f46e5; }
                    .ic-stock { background: #dcfce7; color: #16a34a; }
                    .ic-low { background: #fef9c3; color: #ca8a04; }
                    .ic-out { background: #fee2e2; color: #dc2626; }
                    .ic-value { background: #f3e8ff; color: #9333ea; }
                    
                    .stat-info p { margin: 0; font-size: 13px; color: #64748b; font-weight: 500; }
                    .stat-info h3 { margin: 4px 0 0; font-size: 22px; color: #0f172a; font-weight: 700; }

                    .filter-bar {
                        display: flex; gap: 12px; background: #fff; padding: 16px; border-radius: 12px;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 20px; align-items: center;
                        flex-wrap: wrap; border: 1px solid #f1f5f9;
                    }
                    .filter-bar .search-box { flex: 1; min-width: 250px; position: relative; }
                    .filter-bar .search-box i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
                    .filter-bar .search-box input { width: 100%; padding: 10px 10px 10px 38px; border: 1px solid #e2e8f0; border-radius: 8px; outline: none; transition: border .2s; }
                    .filter-bar .search-box input:focus { border-color: #3b82f6; }
                    
                    .filter-bar select { padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px; outline: none; background: #f8fafc; color: #475569; }
                    .filter-bar .btn-filter { background: #4f46e5; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; display: flex; align-items: center; gap: 8px; }
                    .filter-bar .btn-reset { background: transparent; color: #64748b; border: 1px solid #e2e8f0; padding: 10px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; display: flex; align-items: center; gap: 8px; }

                    .inv-table-wrap { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); overflow: hidden; border: 1px solid #f1f5f9; }
                    .inv-table { width: 100%; border-collapse: collapse; text-align: left; }
                    .inv-table th { background: #f8fafc; padding: 14px 16px; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid #e2e8f0; }
                    .inv-table td { padding: 16px; font-size: 14px; color: #334155; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
                    
                    .row-out { background-color: #fff1f2; }
                    .row-low { background-color: #fefce8; }
                    
                    .text-out { color: #dc2626 !important; font-weight: 700; }
                    .text-low { color: #d97706 !important; font-weight: 700; }
                    .text-ok { color: #16a34a !important; font-weight: 600; }

                    .prod-cell { display: flex; align-items: center; gap: 12px; }
                    .prod-img { width: 40px; height: 40px; border-radius: 6px; object-fit: cover; border: 1px solid #e2e8f0; }
                    .prod-name { font-weight: 500; color: #0f172a; max-width: 250px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
                    
                    .badge-status { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
                    .badge-status.out { background: #fee2e2; color: #991b1b; }
                    .badge-status.low { background: #fef3c7; color: #92400e; }
                    .badge-status.ok { background: #dcfce7; color: #065f46; }

                    .btn-action { background: #fff; border: 1px solid #e2e8f0; padding: 6px 12px; border-radius: 6px; color: #475569; font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
                    .btn-action:hover { border-color: #cbd5e1; background: #f8fafc; color: #0f172a; }
                </style>

                <div class="dash-stats">
                    <div class="stat-card" style="border-left: 4px solid #4f46e5;">
                        <div class="stat-icon ic-variants"><i class="fa-solid fa-boxes-stacked"></i></div>
                        <div class="stat-info">
                            <p>Tổng biến thể</p>
                            <h3><fmt:formatNumber value="${statTotalVariants}" /></h3>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid #16a34a;">
                        <div class="stat-icon ic-stock"><i class="fa-solid fa-cubes"></i></div>
                        <div class="stat-info">
                            <p>Tổng tồn kho</p>
                            <h3><fmt:formatNumber value="${statTotalStock}" /></h3>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid #ca8a04;">
                        <div class="stat-icon ic-low"><i class="fa-solid fa-triangle-exclamation"></i></div>
                        <div class="stat-info">
                            <p>Sắp hết hàng</p>
                            <h3><fmt:formatNumber value="${statLowStock}" /></h3>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid #dc2626;">
                        <div class="stat-icon ic-out"><i class="fa-solid fa-circle-xmark"></i></div>
                        <div class="stat-info">
                            <p>Hết hàng</p>
                            <h3><fmt:formatNumber value="${statOutOfStock}" /></h3>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid #9333ea;">
                        <div class="stat-icon ic-value"><i class="fa-solid fa-coins"></i></div>
                        <div class="stat-info">
                            <p>Giá trị tồn kho</p>
                            <h3><fmt:formatNumber value="${statInventoryValue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></h3>
                        </div>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" id="searchInput" placeholder="Tìm tên sản phẩm..." onkeyup="filterTable()">
                    </div>
                    <select id="categoryFilter" onchange="filterTable()">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryName}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                    <select id="brandFilter" onchange="filterTable()">
                        <option value="">Tất cả thương hiệu</option>
                    </select>
                    <select id="statusFilter" onchange="filterTable()">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Còn hàng">Còn hàng</option>
                        <option value="Sắp hết">Sắp hết</option>
                        <option value="Hết hàng">Hết hàng</option>
                    </select>
                    <button class="btn-filter" onclick="filterTable()"><i class="fa-solid fa-filter"></i> Lọc</button>
                    <button class="btn-reset" onclick="resetFilters()"><i class="fa-solid fa-rotate-right"></i> Reset</button>
                </div>

                <div class="inv-table-wrap">
                    <table class="inv-table" id="inventoryTable">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Thương hiệu</th>
                                <th>Biến thể</th>
                                <th>Tồn kho</th>
                                <th>Ngưỡng tối thiểu</th>
                                <th>Đã bán</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <c:set var="rowClass" value="" />
                                <c:set var="textClass" value="text-ok" />
                                <c:set var="badgeClass" value="ok" />
                                <c:set var="statusText" value="Còn hàng" />
                                
                                <c:choose>
                                    <c:when test="${p.stock == 0}">
                                        <c:set var="rowClass" value="row-out" />
                                        <c:set var="textClass" value="text-out" />
                                        <c:set var="badgeClass" value="out" />
                                        <c:set var="statusText" value="Hết hàng" />
                                    </c:when>
                                    <c:when test="${p.stock <= 5}">
                                        <c:set var="rowClass" value="row-low" />
                                        <c:set var="textClass" value="text-low" />
                                        <c:set var="badgeClass" value="low" />
                                        <c:set var="statusText" value="Sắp hết" />
                                    </c:when>
                                </c:choose>

                                <c:set var="catName" value="" />
                                <c:forEach var="cat" items="${categories}">
                                    <c:if test="${cat.categoryID == p.categoryId}">
                                        <c:set var="catName" value="${cat.categoryName}" />
                                    </c:if>
                                </c:forEach>

                                <tr class="${rowClass}">
                                    <td>
                                        <div class="prod-cell">
                                            <img src="${p.img}" alt="${p.name}" class="prod-img" onerror="this.src='https://via.placeholder.com/40'">
                                            <span class="prod-name" title="${p.name}">${p.name}</span>
                                        </div>
                                    </td>
                                    <td class="col-category">${catName}</td>
                                    <td class="col-brand">${p.brand}</td>
                                    <td><span style="color: #94a3b8; font-size: 13px;">-</span></td>
                                    <td class="${textClass}">${p.stock}</td>
                                    <td style="color:#64748b;">5</td>
                                    <td style="color:#64748b;">${p.sold}</td>
                                    <td class="col-status"><span class="badge-status ${badgeClass}">${statusText}</span></td>
                                    <td>
                                        <c:url value="inventory" var="adjustUrl">
                                            <c:param name="tab" value="adjust"/>
                                            <c:param name="preselect" value="${p.name}"/>
                                        </c:url>
                                        <a href="${adjustUrl}" class="btn-action">
                                            <i class="fa-solid fa-pen-to-square"></i> Điều chỉnh
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        const table = document.getElementById("inventoryTable");
                        const rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
                        const brands = new Set();
                        for(let i=0; i<rows.length; i++) {
                            const brand = rows[i].querySelector(".col-brand").innerText.trim();
                            if(brand) brands.add(brand);
                        }
                        const brandFilter = document.getElementById("brandFilter");
                        brands.forEach(b => {
                            const opt = document.createElement("option");
                            opt.value = b;
                            opt.innerText = b;
                            brandFilter.appendChild(opt);
                        });
                    });

                    function filterTable() {
                        const search = document.getElementById("searchInput").value.toLowerCase();
                        const category = document.getElementById("categoryFilter").value.toLowerCase();
                        const brand = document.getElementById("brandFilter").value.toLowerCase();
                        const status = document.getElementById("statusFilter").value.toLowerCase();
                        
                        const table = document.getElementById("inventoryTable");
                        const rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
                        
                        for (let i = 0; i < rows.length; i++) {
                            const nameText = rows[i].querySelector(".prod-name").innerText.toLowerCase();
                            const catText = rows[i].querySelector(".col-category").innerText.toLowerCase();
                            const brandText = rows[i].querySelector(".col-brand").innerText.toLowerCase();
                            const statusText = rows[i].querySelector(".col-status").innerText.toLowerCase();
                            
                            const matchSearch = nameText.includes(search);
                            const matchCat = category === "" || catText.includes(category);
                            const matchBrand = brand === "" || brandText.includes(brand);
                            const matchStatus = status === "" || statusText.includes(status);
                            
                            if (matchSearch && matchCat && matchBrand && matchStatus) {
                                rows[i].style.display = "";
                            } else {
                                rows[i].style.display = "none";
                            }
                        }
                    }

                    function resetFilters() {
                        document.getElementById("searchInput").value = "";
                        document.getElementById("categoryFilter").value = "";
                        document.getElementById("brandFilter").value = "";
                        document.getElementById("statusFilter").value = "";
                        filterTable();
                    }
                </script>
            </c:if>

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

        // Handle preselect parameter
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const preselect = urlParams.get('preselect');
            const currentTab = urlParams.get('tab');
            
            if (preselect && currentTab === 'adjust') {
                const firstRowInput = document.querySelector('#adjust-rows input[name="productSearch"]');
                const firstRowHiddenId = document.querySelector('#adjust-rows input[name="productId"]');
                
                if (firstRowInput && firstRowHiddenId) {
                    firstRowInput.value = preselect;
                    const matchedProduct = allProducts.find(p => p.name === preselect);
                    if (matchedProduct) {
                        firstRowHiddenId.value = matchedProduct.id;
                        
                        // Focus on the new stock input so the user can type immediately
                        const stockInput = document.querySelector('#adjust-rows input[name="newStock"]');
                        if (stockInput) {
                            stockInput.focus();
                        }
                    }
                }
            }
        });
    </script>

</body>
</html>
