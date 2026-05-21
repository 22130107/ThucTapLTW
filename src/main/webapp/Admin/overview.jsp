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
            <!-- Chart.js CDN -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                    <a class="topbtn" href="#" title="Tài khoản"><i class="fa-solid fa-user"></i></a>
                </nav>

            </header>


            <!-- LAYOUT -->
            <div class="layout">

                <!-- SIDEBAR -->
                <aside id="sidebar" class="sidebar" aria-hidden="false">

                    <div class="sidebar-title">Quản trị</div>

                    <nav class="menu">
                        <a class="menu-item active" href="overview">Tổng quan</a>
                        <a class="menu-item" href="accounts">Tài khoản</a>
                        <a class="menu-item" href="products">Sản phẩm</a>
                        <a class="menu-item" href="orders">Đơn hàng</a>
                    </nav>
                </aside>

                <!-- CONTENT -->
                <main class="content">

                    <h2>Bảng điều khiển</h2>

                    <!-- KPIs -->
                    <section class="stats">

                        <div class="stat-card">
                            <h3>Sản phẩm</h3>
                            <p class="value">${totalProducts}</p>
                            <p class="sub">Tổng số sản phẩm</p>
                        </div>

                        <div class="stat-card">
                            <h3>Đơn hàng</h3>
                            <p class="value">${totalOrders}</p>
                            <p class="sub">Tổng đơn hàng</p>
                        </div>


                        <div class="stat-card">
                            <h3>Tài khoản</h3>
                            <p class="value">${totalAccounts}</p>
                            <p class="sub">Thành viên đăng ký</p>
                        </div>

                    </section>

                    <!-- CHARTS SECTION -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px; margin-bottom: 24px;">
                        
                        <!-- Doanh thu -->
                        <section class="card" style="padding: 24px; margin-bottom: 0;">
                            <h3 style="margin-bottom: 16px; font-size: 16px; font-weight: 700; color: var(--text);">Doanh thu 6 tháng gần đây</h3>
                            <div style="height: 300px; position: relative;">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </section>

                        <!-- Sản phẩm theo danh mục -->
                        <section class="card" style="padding: 24px; margin-bottom: 0;">
                            <h3 style="margin-bottom: 16px; font-size: 16px; font-weight: 700; color: var(--text);">Số lượng sản phẩm theo danh mục</h3>
                            <div style="height: 300px; position: relative;">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </section>

                    </div>



                </main>

            </div>

            <script src="${pageContext.request.contextPath}/Admin/app.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    // 1. Revenue Chart
                    const revCtx = document.getElementById('revenueChart').getContext('2d');
                    
                    let revenueLabels = [
                        <c:forEach var="item" items="${revenueData}" varStatus="loop">
                            "${item[0]}"${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];
                    let revenueValues = [
                        <c:forEach var="item" items="${revenueData}" varStatus="loop">
                            ${item[1]}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    // Fallback mock data if DB has no sales yet
                    if (revenueLabels.length === 0) {
                        revenueLabels = ["Tháng 12/2025", "Tháng 01/2026", "Tháng 02/2026", "Tháng 03/2026", "Tháng 04/2026", "Tháng 05/2026"];
                        revenueValues = [12500000, 15000000, 18500000, 22000000, 28000000, 35000000];
                    }

                    new Chart(revCtx, {
                        type: 'bar',
                        data: {
                            labels: revenueLabels,
                            datasets: [{
                                label: 'Doanh thu',
                                data: revenueValues,
                                backgroundColor: 'rgba(16, 185, 129, 0.85)', /* Teal matching user requirements */
                                borderColor: '#10b981',
                                borderWidth: 1,
                                borderRadius: 6,
                                barPercentage: 0.55
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: '#0f172a',
                                    titleFont: { family: 'Outfit', size: 13 },
                                    bodyFont: { family: 'Outfit', size: 13 },
                                    callbacks: {
                                        label: function(context) {
                                            let label = context.dataset.label || '';
                                            if (label) {
                                                label += ': ';
                                            }
                                            if (context.parsed.y !== null) {
                                                label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                            }
                                            return label;
                                        }
                                    }
                                }
                            },
                            scales: {
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: { family: 'Outfit', size: 12, weight: '500' },
                                        color: '#64748b'
                                    }
                                },
                                y: {
                                    grid: {
                                        color: '#e2e8f0'
                                    },
                                    ticks: {
                                        font: { family: 'Outfit', size: 12 },
                                        color: '#64748b',
                                        callback: function(value) {
                                            if (value >= 1000000) {
                                                return (value / 1000000) + 'M';
                                            }
                                            return value;
                                        }
                                    }
                                }
                            }
                        }
                    });

                    // 2. Category Chart
                    const catCtx = document.getElementById('categoryChart').getContext('2d');
                    
                    let categoryLabels = [
                        <c:forEach var="item" items="${categoryData}" varStatus="loop">
                            "${item[0]}"${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];
                    let categoryValues = [
                        <c:forEach var="item" items="${categoryData}" varStatus="loop">
                            ${item[1]}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    // Fallback mock data if DB has no relations
                    if (categoryLabels.length === 0) {
                        categoryLabels = ["Y tế gia đình", "Y tế chuyên dụng", "Chăm sóc sắc đẹp", "Combo khuyến mãi", "Thực phẩm chức năng", "Đồ dùng mẹ & bé"];
                        categoryValues = [45, 25, 35, 15, 20, 17];
                    }

                    new Chart(catCtx, {
                        type: 'doughnut',
                        data: {
                            labels: categoryLabels,
                            datasets: [{
                                data: categoryValues,
                                backgroundColor: [
                                    '#1f8fe5', '#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#06b6d4'
                                ],
                                borderWidth: 2,
                                borderColor: '#ffffff'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'right',
                                    labels: {
                                        font: { family: 'Outfit', size: 12, weight: '500' },
                                        color: '#0f172a',
                                        boxWidth: 12
                                    }
                                },
                                tooltip: {
                                    backgroundColor: '#0f172a',
                                    titleFont: { family: 'Outfit', size: 13 },
                                    bodyFont: { family: 'Outfit', size: 13 }
                                }
                            },
                            cutout: '65%'
                        }
                    });
                });
            </script>

        </body>

        </html>