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
                        <td><strong>${p.code}</strong></td>
                        <td>${p.type eq 'percent' ? 'Phần trăm' : 'Tiền cố định'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.type eq 'percent'}"><fmt:formatNumber value="${p.amount}" maxFractionDigits="1"/>%</c:when>
                                <c:otherwise><fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="₫"/></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${p.usedCount} / ${p.usageLimit == 0 ? '∞' : p.usageLimit}</td>
                        <td>
                            <span class="badge ${p.active ? 'ok' : 'secondary'}">${p.active ? 'Bật' : 'Tắt'}</span>
                        </td>
                        <td>
                            <button class="btn btn-ghost" type="button"
                                onclick="openEdit(${p.id},'${p.code}','${p.type}',${p.amount},${p.minOrderValue},'${p.startAt}','${p.endAt}',${p.usageLimit},${p.active},'${p.appliesTo}')">
                                <i class="fa-solid fa-pen"></i> Sửa
                            </button>
                            <form action="promocodes" method="post" style="display:inline">
                                <input type="hidden" name="csrf_token" value="${csrfToken}" />
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="${p.id}" />
                                <button class="btn btn-danger" type="submit"
                                        onclick="return confirm('Xóa mã ${p.code}?')">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </button>
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
            <h3><i class="fa-solid fa-plus"></i> Tạo mã khuyến mãi</h3>
            <form action="promocodes" method="post" class="form">
                <input type="hidden" name="csrf_token" value="${csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <label>Mã code <span style="color:red">*</span>
                    <input class="input" name="code" required placeholder="VD: SUMMER2024" style="text-transform:uppercase"/>
                </label>
                <label>Loại giảm giá
                    <select name="type" class="input">
                        <option value="percent">Phần trăm (%)</option>
                        <option value="fixed">Tiền cố định (₫)</option>
                    </select>
                </label>
                <label>Giá trị <span style="color:red">*</span>
                    <input class="input" name="amount" type="number" min="0" step="0.01" required placeholder="VD: 10 hoặc 50000"/>
                </label>
                <label>Đơn hàng tối thiểu (₫)
                    <input class="input" name="minOrderValue" type="number" min="0" value="0"/>
                </label>
                <label>Ngày bắt đầu
                    <input type="datetime-local" name="startAt" class="input" />
                </label>
                <label>Ngày kết thúc
                    <input type="datetime-local" name="endAt" class="input" />
                </label>
                <label>Giới hạn lượt dùng (0 = không giới hạn)
                    <input class="input" name="usageLimit" type="number" min="0" value="0"/>
                </label>
                <label>Áp dụng cho
                    <select name="appliesTo" class="input">
                        <option value="all">Tất cả</option>
                        <option value="category">Danh mục</option>
                        <option value="product">Sản phẩm</option>
                    </select>
                </label>
                <label>ID danh mục / sản phẩm (nếu cần)
                    <input class="input" name="appliesToId" type="number" placeholder="Để trống nếu áp dụng tất cả"/>
                </label>
                <label style="flex-direction:row; align-items:center; gap:8px;">
                    <input type="checkbox" name="active" checked /> Kích hoạt ngay
                </label>
                <div class="actions">
                    <a class="btn btn-ghost" href="#">Hủy</a>
                    <button class="btn" type="submit"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="modal-edit" class="modal">
        <a href="#" class="modal-overlay" aria-label="Đóng"></a>
        <div class="modal-body">
            <h3><i class="fa-solid fa-pen"></i> Sửa mã khuyến mãi</h3>
            <form action="promocodes" method="post" class="form" id="form-edit">
                <input type="hidden" name="csrf_token" value="${csrfToken}" />
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" id="edit-id" />
                <label>Mã code <span style="color:red">*</span>
                    <input class="input" name="code" id="edit-code" required style="text-transform:uppercase"/>
                </label>
                <label>Loại giảm giá
                    <select name="type" class="input" id="edit-type">
                        <option value="percent">Phần trăm (%)</option>
                        <option value="fixed">Tiền cố định (₫)</option>
                    </select>
                </label>
                <label>Giá trị <span style="color:red">*</span>
                    <input class="input" name="amount" id="edit-amount" type="number" min="0" step="0.01" required/>
                </label>
                <label>Đơn hàng tối thiểu (₫)
                    <input class="input" name="minOrderValue" id="edit-minOrder" type="number" min="0"/>
                </label>
                <label>Ngày bắt đầu
                    <input type="datetime-local" name="startAt" class="input" id="edit-startAt"/>
                </label>
                <label>Ngày kết thúc
                    <input type="datetime-local" name="endAt" class="input" id="edit-endAt"/>
                </label>
                <label>Giới hạn lượt dùng (0 = không giới hạn)
                    <input class="input" name="usageLimit" id="edit-usageLimit" type="number" min="0"/>
                </label>
                <label>Áp dụng cho
                    <select name="appliesTo" class="input" id="edit-appliesTo">
                        <option value="all">Tất cả</option>
                        <option value="category">Danh mục</option>
                        <option value="product">Sản phẩm</option>
                    </select>
                </label>
                <label style="flex-direction:row; align-items:center; gap:8px;">
                    <input type="checkbox" name="active" id="edit-active" /> Kích hoạt
                </label>
                <div class="actions">
                    <a class="btn btn-ghost" href="#">Hủy</a>
                    <button class="btn" type="submit"><i class="fa-solid fa-floppy-disk"></i> Cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
    <script>
        function openEdit(id, code, type, amount, minOrder, startAt, endAt, usageLimit, active, appliesTo) {
            document.getElementById('edit-id').value        = id;
            document.getElementById('edit-code').value      = code;
            document.getElementById('edit-type').value      = type;
            document.getElementById('edit-amount').value    = amount;
            document.getElementById('edit-minOrder').value  = minOrder;
            document.getElementById('edit-usageLimit').value = usageLimit;
            document.getElementById('edit-active').checked  = (active === true || active === 'true');
            document.getElementById('edit-appliesTo').value = appliesTo;

            // Format dates for datetime-local input (yyyy-MM-ddTHH:mm)
            function fmtDate(d) {
                if (!d || d === 'null') return '';
                try {
                    const dt = new Date(d);
                    if (isNaN(dt)) return '';
                    return dt.toISOString().slice(0, 16);
                } catch(e) { return ''; }
            }
            document.getElementById('edit-startAt').value = fmtDate(startAt);
            document.getElementById('edit-endAt').value   = fmtDate(endAt);

            window.location.hash = 'modal-edit';
        }
    </script>

</main>
</body>
</html>
