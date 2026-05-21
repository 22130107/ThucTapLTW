<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!doctype html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <title>MedHome Admin — Tổng quan</title>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/admin.css" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                        <a class="menu-item active" href="overview">🏠 Tổng quan</a>
                        <a class="menu-item" href="accounts">👥 Tài khoản</a>
                        <a class="menu-item" href="products">🧰 Sản phẩm</a>
                            <a class="menu-item" href="orders">🧾 Đơn hàng</a>
                    </nav>
                </aside>

                <!-- CONTENT -->
                <main class="content">

                    <h2>Bảng điều khiển</h2>

                    <!-- KPIs -->
                    <section class="stats">

                        <div class="stat-card">
                            <h3>🧰 Sản phẩm</h3>
                            <p class="value">${totalProducts}</p>
                            <p class="sub">Tổng số sản phẩm</p>
                        </div>

                        <div class="stat-card">
                            <h3>🧾 Đơn hàng</h3>
                            <p class="value">${totalOrders}</p>
                            <p class="sub">Tổng đơn hàng</p>
                        </div>


                        <div class="stat-card">
                            <h3>👥 Tài khoản</h3>
                            <p class="value">${totalAccounts}</p>
                            <p class="sub">Thành viên đăng ký</p>
                        </div>

                    </section>

                    <!-- TÁC VỤ NHANH -->
                    <section class="card" style="padding:12px; margin:10px 0 14px;">

                        <div class="actions" style="margin:0; flex-wrap:wrap;">

                            <a class="btn" href="orders">+ Quản lý đơn hàng</a>
                            <a class="btn btn-ghost" href="products">Quản lý sản phẩm</a>

                        </div>

                    </section>

                    <footer class="foot">© 2025 MedHome Admin</footer>

                </main>

            </div>

            <script src="${pageContext.request.contextPath}/Admin/app.js"></script>

        </body>

        </html>