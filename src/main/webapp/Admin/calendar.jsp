<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý lịch khám</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/calendar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css">

            </head>

            <body>
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
                <div class="layout">

                    <!-- End -->

                    <!-- SIDEBAR -->
                    <aside id="sidebar" class="sidebar" aria-hidden="false">

                        <div class="sidebar-title">Quản trị</div>
                        <nav class="menu">
                            <a class="menu-item" href="overview">🏠 Tổng quan</a>
                            <a class="menu-item" href="accounts">👥 Tài khoản</a>
                            <a class="menu-item" href="products">🧰 Sản phẩm</a>
                            <a class="menu-item" href="orders">🧾 Đơn hàng</a>
                            <a class="menu-item active" href="appointments">💹 Lịch Khám</a>
                        </nav>


                    </aside>

                    <div class="page-wrapper">
                        <div class="page-header">
                            <div>
                                <div class="page-title">
                                    <i class="fa-solid fa-calendar-check"></i>
                                    <span>Quản lý lịch khám</span>
                                </div>
                                <div class="page-subtitle">
                                    Theo dõi, lọc và quản lý các lịch hẹn khám bệnh của khách hàng.
                                </div>
                            </div>
                            <div class="page-actions">
                                <a class="btn btn-outline" href="appointments">
                                    <i class="fa-solid fa-arrow-rotate-right"></i>
                                    Làm mới
                                </a>
                                <!-- <button class="btn btn-primary">
                        <i class="fa-solid fa-plus"></i>
                        Thêm lịch khám
                    </button> -->
                            </div>
                        </div>

                        <!-- Thống kê nhanh -->
                        <div class="stats-row">
                            <div class="stat-card">
                                <div class="stat-label">Tổng lịch hôm nay</div>
                                <div class="stat-value">${todayTotal}</div>
                                <div class="stat-extra"><i class="fa-solid fa-circle"
                                        style="font-size: 8px; color: #ffb74d;"></i> ${todayNew} mới</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Đã xác nhận</div>
                                <div class="stat-value">${confirmedTotal}</div>
                                <div class="stat-extra">Đang chờ khám</div>
                            </div>
                        </div>

                        <!-- Bộ lọc -->
                        <div class="filter-card">
                            <form class="filter-row" action="appointments" method="get">
                                <div class="filter-group">
                                    <label>Từ ngày</label>
                                    <input type="date" class="filter-input" name="dateFrom" value="${msgDateFrom}">
                                </div>
                                <div class="filter-group">
                                    <label>Đến ngày</label>
                                    <input type="date" class="filter-input" name="dateTo" value="${msgDateTo}">
                                </div>

                                <div class="filter-group">
                                    <label>Trạng thái</label>
                                    <select class="filter-select" name="status">
                                        <option value="">Tất cả</option>
                                        <option ${msgStatus=='New' ? 'selected' : '' } value="New">Mới</option>
                                        <option ${msgStatus=='Confirmed' ? 'selected' : '' } value="Confirmed">Đã xác
                                            nhận</option>
                                        <option ${msgStatus=='Completed' ? 'selected' : '' } value="Completed">Đã khám
                                        </option>
                                        <option ${msgStatus=='Cancelled' ? 'selected' : '' } value="Cancelled">Đã hủy
                                        </option>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label>Hình thức khám</label>
                                    <select class="filter-select" name="type">
                                        <option value="">Tất cả</option>
                                        <option ${msgType=='AtClinic' ? 'selected' : '' } value="AtClinic">Tại phòng
                                            khám</option>
                                        <option ${msgType=='AtHome' ? 'selected' : '' } value="AtHome">Tại nhà</option>
                                    </select>
                                </div>

                                <div class="filter-search" style="flex: 1; margin: 0 15px;">
                                    <div class="search-box"
                                        style="display: flex; align-items: center; background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 0 10px; height: 38px; margin-top: 22px;">
                                        <input type="text" name="q" value="${msgKeyword}"
                                            placeholder="🔍 Tên, SĐT, Mã..."
                                            style="border: none; outline: none; flex: 1; font-size: 14px;">
                                        <button type="submit"
                                            style="background: none; border: none; color: #666; cursor: pointer;">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="filter-group" style="flex-direction: row; gap: 8px; align-items: flex-end;">
                                    <button class="btn btn-primary" type="submit"
                                        style="height: 38px; padding: 0 15px;">
                                        <i class="fa-solid fa-filter"></i> Lọc
                                    </button>
                                    <a class="btn btn-outline" href="appointments"
                                        style="height: 38px; padding: 0 15px; line-height: 36px;">
                                        <i class="fa-solid fa-rotate-left"></i> Reset
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Bảng lịch khám -->
                        <div class="table-card">
                            <div class="table-header">
                                <div class="table-header-title">Danh sách lịch khám</div>
                                <div class="table-header-info">Hiển thị ${listA.size()} lịch</div>
                            </div>

                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Mã lịch</th>
                                            <th>Bệnh nhân</th>
                                            <th>Dịch vụ</th>
                                            <th>Ngày khám</th>
                                            <th>Giờ</th>
                                            <!-- <th>Bác sĩ</th> -->
                                            <th>Hình thức</th>
                                            <th>Trạng thái</th>
                                            <th class="text-right">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listA}" var="a">
                                            <tr>
                                                <td>#LK${a.appointmentID}</td>
                                                <td>
                                                    <div class="patient-name">${a.customerName}</div>
                                                    <div class="patient-phone"><i class="fa-solid fa-phone"></i>
                                                        ${a.customerPhone}</div>
                                                </td>
                                                <td>
                                                    <div class="service-name">${a.productName != null ? a.productName :
                                                        'Khám tổng quát'}</div>
                                                </td>
                                                <td>
                                                    <fmt:parseDate value="${a.appointmentDateTime}"
                                                        pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <!-- LocalDatetime might need formatting handling -->
                                                    <!-- Since it's LocalDateTime, we might need custom tag or simpler formatting if supported, checking output first -->
                                                    ${a.appointmentDateTime.toLocalDate()}
                                                </td>
                                                <td>
                                                    ${a.appointmentDateTime.toLocalTime()}
                                                </td>
                                                <!-- <td>
                                        <div class="doctor-name">--</div>
                                    </td> -->
                                                <td>
                                                <td>
                                                    <c:choose>
                                                        <c:when
                                                            test="${a.appointmentType.value == 'AtClinic' || a.appointmentType == 'AT_CLINIC'}">
                                                            <span class="badge badge-info">
                                                                <i class="fa-solid fa-house-medical"></i> Tại phòng khám
                                                            </span>
                                                        </c:when>
                                                        <c:when
                                                            test="${a.appointmentType.value == 'AtHome' || a.appointmentType == 'AT_HOME'}">
                                                            <span class="badge badge-info">
                                                                <i class="fa-solid fa-house-user"></i> Tại nhà
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge">${a.appointmentType}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${a.status.value == 'New'}">
                                                            <span class="badge badge-warning"><i
                                                                    class="fa-solid fa-clock"></i> Mới</span>
                                                        </c:when>
                                                        <c:when test="${a.status.value == 'Confirmed'}">
                                                            <span class="badge badge-success"><i
                                                                    class="fa-solid fa-circle-check"></i> Đã xác
                                                                nhận</span>
                                                        </c:when>
                                                        <c:when test="${a.status.value == 'Completed'}">
                                                            <span class="badge badge-success"><i
                                                                    class="fa-solid fa-check"></i> Đã khám</span>
                                                        </c:when>
                                                        <c:when test="${a.status.value == 'Cancelled'}">
                                                            <span class="badge badge-danger"><i
                                                                    class="fa-solid fa-circle-xmark"></i> Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>${a.status}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-right">
                                                    <div class="cell-actions">
                                                        <form action="appointments" method="post"
                                                            style="display:inline;">
                                                            <input type="hidden" name="id" value="${a.appointmentID}">
                                                            <input type="hidden" name="action" value="updateStatus">

                                                            <c:choose>
                                                                <%-- New: Confirm or Cancel --%>
                                                                    <c:when test="${a.status.value == 'New'}">
                                                                        <button type="submit" name="status"
                                                                            value="Confirmed" class="btn-xs"
                                                                            title="Xác nhận"
                                                                            style="color: var(--ok); border-color: var(--ok);">
                                                                            <i class="fa-solid fa-check"></i>
                                                                        </button>
                                                                        <button type="submit" name="status"
                                                                            value="Cancelled"
                                                                            class="btn-xs btn-xs-danger" title="Hủy"
                                                                            onclick="return confirm('Hủy lịch này?');">
                                                                            <i class="fa-solid fa-xmark"></i>
                                                                        </button>
                                                                    </c:when>

                                                                    <%-- Confirmed: Complete or Cancel --%>
                                                                        <c:when test="${a.status.value == 'Confirmed'}">
                                                                            <button type="submit" name="status"
                                                                                value="Completed" class="btn-xs"
                                                                                style="color: var(--primary); border-color: var(--primary);"
                                                                                title="Đã khám xong">
                                                                                <i class="fa-solid fa-stethoscope"></i>
                                                                            </button>
                                                                            <button type="submit" name="status"
                                                                                value="Cancelled"
                                                                                class="btn-xs btn-xs-danger" title="Hủy"
                                                                                onclick="return confirm('Hủy lịch này?');">
                                                                                <i class="fa-solid fa-xmark"></i>
                                                                            </button>
                                                                        </c:when>

                                                                        <%-- Cancelled: Reset --%>
                                                                            <c:when
                                                                                test="${a.status.value == 'Cancelled'}">
                                                                                <button type="submit" name="status"
                                                                                    value="New" class="btn-xs"
                                                                                    title="Phục hồi (Reset)"
                                                                                    style="color: var(--text-muted);">
                                                                                    <i
                                                                                        class="fa-solid fa-rotate-left"></i>
                                                                                </button>
                                                                            </c:when>
                                                            </c:choose>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty listA}">
                                    <div style="padding: 20px; text-align: center; color: #666;">Không tìm thấy lịch
                                        khám nào.</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="${pageContext.request.contextPath}/Admin/app.js"></script>

            </body>

            </html>