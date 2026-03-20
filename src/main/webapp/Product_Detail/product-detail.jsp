<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <title>${product.name} | Chi tiết sản phẩm</title>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Product_Detail/CSS/ProductDetail.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Product/HomeProduct.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Product_Detail/CSS/view.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/Product_Detail/CSS/inforProduct.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/footer/footer.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/style/header/header.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            </head>

            <body>
                <jsp:include page="/style/header/header.jsp" />

                <div class="container">
                    <div class="product">
                        <div class="product-gallery" id="gallery">
                            <div class="main-image" aria-live="polite">
                                <img id="mainImg" src="${product.img}" alt="${product.name}">
                            </div>
                            <div class="thumb-row">
                                <button class="btn-nav" id="btnPrev" aria-label="Ảnh trước">&larr;</button>
                                <div class="thumb-viewport">
                                    <div class="thumbs" id="thumbs" role="list">
                                        <div class="thumb is-active" role="listitem" data-index="0">
                                            <img src="${product.img}" alt="${product.name}">
                                        </div>
                                    </div>
                                </div>
                                <button class="btn-nav" id="btnNext" aria-label="Ảnh sau">&rarr;</button>
                            </div>
                        </div>

                        <div class="detail">
                            <section id="product-panel" class="product-panel">
                                <h1 class="prod-title">${product.name}</h1>
                                <div class="divider"></div>

                                <div class="price-wrap">
                                    <div class="price-new" id="price-new">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" />
                                    </div>
                                    <c:if test="${product.oldPrice > product.price}">
                                        <div class="price-old" id="price-old">
                                            <fmt:formatNumber value="${product.oldPrice}" type="currency"
                                                currencySymbol="đ" />
                                        </div>
                                        <div class="price-off" id="price-off">
                                            -
                                            <fmt:formatNumber value="${(1 - product.price / product.oldPrice) * 100}"
                                                maxFractionDigits="0" />%
                                        </div>
                                    </c:if>
                                    <div class="vat-note">(Đã gồm VAT)</div>
                                </div>

                                <div class="grid">
                                    <div class="label">Chọn kho hàng:</div>
                                    <div class="seg" role="tablist" aria-label="Kho hàng">
                                        <button class="seg-btn active" data-region="north" role="tab"
                                            aria-selected="true">Miền Bắc</button>
                                        <button class="seg-btn" data-region="south" role="tab"
                                            aria-selected="false">Miền Nam: +200.000đ</button>
                                    </div>

                                    <div class="label">Trạng thái:</div>
                                    <div class="status">${product.stock > 0 ? "Còn hàng" : "Hết hàng"}</div>
                                </div>

                                <div class="qty-row">
                                    <div class="label">Chọn số lượng:</div>
                                    <div class="qty" aria-label="Số lượng">
                                        <button class="qty-minus" aria-label="Giảm">−</button>
                                        <input id="qtyInput" class="qty-input" type="text" value="1" readonly>
                                        <button class="qty-plus" aria-label="Tăng">+</button>
                                    </div>
                                    <button id="btnAddToCart" class="add-cart"><i class="fa-solid fa-cart-plus"></i> Cho
                                        vào giỏ</button>
                                </div>

                                <div class="actions">
                                    <button id="btnBuyNow" class="btn btn-buy"><i
                                            class="fa-solid fa-cart-shopping"></i>Đặt mua</button>
                                    <button class="btn btn-call"><i class="fa-solid fa-headset"></i>Tư vấn</button>
                                    <button class="btn btn-credit"><i class="fa-solid fa-coins"></i>Trả góp</button>
                                </div>

                                <div class="benefits">
                                    <div class="benefit"><i class="fa-solid fa-truck-fast"></i>Miễn phí giao hàng trong
                                        nội thành Hà Nội và nội thành TP. Hồ Chí Minh. <a href="#"
                                            style="margin-left:6px;color:#0ea5e9;text-decoration:none;">(Xem thêm)</a>
                                    </div>
                                    <div class="benefit"><i class="fa-solid fa-file-invoice"></i>Được hàng trăm ngàn
                                        Doanh nghiệp tại Việt Nam lựa chọn: đầy đủ hóa đơn, hợp đồng, không chi phí ẩn
                                        <a href="#" style="margin-left:6px;color:#0ea5e9;text-decoration:none;">(Xem
                                            thêm)</a>
                                    </div>
                                    <div class="benefit"><i class="fa-solid fa-shield-heart"></i>Bảo hành toàn quốc. <a
                                            href="#" style="margin-left:6px;color:#0ea5e9;text-decoration:none;">(Xem
                                            trung tâm bảo hành)</a></div>
                                </div>
                            </section>
                        </div>

                        <div class="product-info">
                            <article class="product-card">
                                <div id="descWrap" class="collapse-wrap">
                                    ${product.description}
                                </div>
                                <div class="toggle-btn-wrap">
                                    <button id="toggleDesc" class="toggle-btn">Xem tất cả ▼</button>
                                </div>
                            </article>
                        </div>

                        <div id="viewed-root">
                            <aside class="viewed-panel viewed--compact" aria-labelledby="viewed-title">
                                <div class="viewed-header">
                                    <h3 id="viewed-title">Sản phẩm khác</h3>
                                    <a class="btn-view-all" href="${pageContext.request.contextPath}/catalog">Xem tất
                                        cả</a>
                                </div>
                                <ul class="viewed-list" role="list">
                                    <c:forEach var="rp" items="${relatedProducts}">
                                        <li class="viewed-item">
                                            <div class="viewed-thumb">
                                                <c:if test="${not empty rp.badge}">
                                                    <span class="badge-sale">-${rp.badge}</span>
                                                </c:if>
                                                <img src="${rp.img}" alt="${rp.name}" loading="lazy">
                                            </div>
                                            <div class="viewed-info">
                                                <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}"
                                                    class="viewed-name">${rp.name}</a>
                                                <div class="viewed-price">
                                                    <span class="price-now">
                                                        <fmt:formatNumber value="${rp.price}" type="currency"
                                                            currencySymbol="đ" />
                                                    </span>
                                                    <c:if test="${rp.oldPrice > rp.price}">
                                                        <s class="price-old">
                                                            <fmt:formatNumber value="${rp.oldPrice}" type="currency"
                                                                currencySymbol="đ" />
                                                        </s>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </aside>
                        </div>
                    </div>

                    <div class="content">
                        <section class="feature-strip">
                            <div class="feature">
                                <img class="feature-icon" src="https://meta.vn/images/icons/dich-vu-uy-tin-icon.svg"
                                    alt="Uy tín">
                                <span class="feature-text">Dịch vụ uy tín</span>
                            </div>
                            <div class="feature">
                                <img class="feature-icon" src="https://meta.vn/images/icons/doi-tra-hang-icon.svg"
                                    alt="Đổi trả 7 ngày">
                                <span class="feature-text">Đổi trả trong 7 ngày</span>
                            </div>
                            <div class="feature">
                                <img class="feature-icon"
                                    src="https://meta.vn/images/icons/giao-hang-toan-quoc-icon.svg"
                                    alt="Giao toàn quốc">
                                <span class="feature-text">Giao hàng toàn quốc</span>
                            </div>
                        </section>
                        <div class="ft-row ft-health">
                            <div class="ft-col">
                                <h4>Liên hệ & hỗ trợ</h4>
                                <ul class="ft-list">
                                    <li class="ft-flag"><strong>Miền Bắc & Trung</strong></li>
                                    <li>Mua hàng: <a class="tel" href="tel:02435686969">(024) 3568 6969</a></li>
                                    <li>Bảo hành: <a class="tel" href="tel:02435681234">(024) 3568 1234</a></li>
                                    <li class="ft-flag"><strong>Miền Nam</strong></li>
                                    <li>Mua hàng: <a class="tel" href="tel:02838336666">(028) 3833 6666</a></li>
                                    <li>Bảo hành: <a class="tel" href="tel:02838331234">(028) 3833 1234</a></li>
                                </ul>
                            </div>
                            <div class="ft-col">
                                <h4>Hỗ trợ khách hàng</h4>
                                <ul class="ft-links">
                                    <li><a href="#">Chính sách đổi trả & bảo hành</a></li>
                                    <li><a href="#">Hướng dẫn thanh toán</a></li>
                                </ul>
                            </div>
                            <div class="ft-col">
                                <h4>Về MEDITECH</h4>
                                <ul class="ft-links">
                                    <li><a href="#">Giới thiệu</a></li>
                                    <li><a href="#">Liên hệ hợp tác</a></li>
                                </ul>
                            </div>
                            <div class="ft-col">
                                <h4>Kết nối với chúng tôi</h4>
                                <ul class="ft-social">
                                    <li><a href="#">Facebook</a></li>
                                    <li><a href="#">Youtube</a></li>
                                </ul>
                            </div>
                        </div>

                        <script>
                            const PRODUCT_PRICE = ${ product.price };
                            const PRODUCT_ID = ${ product.id };

                            // Cart Logic
                            function addToCart(callback) {
                                const qty = document.getElementById("qtyInput").value;
                                const url = "${pageContext.request.contextPath}/add-to-cart";

                                fetch(url, {
                                    method: "POST",
                                    headers: {
                                        "Content-Type": "application/x-www-form-urlencoded"
                                    },
                                    body: "id=" + PRODUCT_ID + "&quantity=" + qty
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.status === "success") {
                                            // Update badge
                                            const badges = document.querySelectorAll(".cart-badge");
                                            badges.forEach(b => b.textContent = data.totalQuantity);

                                            // Update mini-cart total price
                                            const miniCartTotal = document.getElementById("mini-cart-total");
                                            if (miniCartTotal && data.totalPrice !== undefined) {
                                                miniCartTotal.textContent = new Intl.NumberFormat('vi-VN', {
                                                    style: 'currency',
                                                    currency: 'VND'
                                                }).format(data.totalPrice);
                                            }

                                            // Update mini-cart list using DOM manipulation
                                            const miniCartList = document.getElementById("mini-cart-list");
                                            if (miniCartList && data.cartItems) {
                                                miniCartList.innerHTML = '';

                                                if (data.cartItems.length === 0) {
                                                    const emptyLi = document.createElement('li');
                                                    emptyLi.className = 'mini-cart-item';
                                                    emptyLi.style.justifyContent = 'center';
                                                    emptyLi.innerHTML = '<span>Giỏ hàng trống</span>';
                                                    miniCartList.appendChild(emptyLi);
                                                } else {
                                                    data.cartItems.forEach(item => {
                                                        const li = document.createElement('li');
                                                        li.className = 'mini-cart-item';

                                                        const img = document.createElement('img');
                                                        img.src = item.product.img;
                                                        img.alt = item.product.name;
                                                        img.className = 'mini-cart-thumb';

                                                        const infoDiv = document.createElement('div');
                                                        infoDiv.className = 'mini-cart-info';

                                                        const titleDiv = document.createElement('div');
                                                        titleDiv.className = 'mini-cart-title';
                                                        titleDiv.textContent = item.product.name;

                                                        const metaDiv = document.createElement('div');
                                                        metaDiv.className = 'mini-cart-meta';

                                                        const qtySpan = document.createElement('span');
                                                        qtySpan.className = 'qty';
                                                        qtySpan.textContent = item.quantity + ' x';

                                                        const priceSpan = document.createElement('span');
                                                        priceSpan.className = 'mini-cart-price';
                                                        priceSpan.textContent = new Intl.NumberFormat('vi-VN', {
                                                            style: 'currency',
                                                            currency: 'VND'
                                                        }).format(item.product.price);

                                                        metaDiv.appendChild(qtySpan);
                                                        metaDiv.appendChild(priceSpan);

                                                        infoDiv.appendChild(titleDiv);
                                                        infoDiv.appendChild(metaDiv);

                                                        const totalPriceDiv = document.createElement('div');
                                                        totalPriceDiv.className = 'mini-cart-price';
                                                        totalPriceDiv.textContent = new Intl.NumberFormat('vi-VN', {
                                                            style: 'currency',
                                                            currency: 'VND'
                                                        }).format(item.totalPrice);

                                                        li.appendChild(img);
                                                        li.appendChild(infoDiv);
                                                        li.appendChild(totalPriceDiv);
                                                        miniCartList.appendChild(li);
                                                    });
                                                }
                                            }

                                            if (callback) {
                                                callback();
                                            } else {
                                                alert("Đã thêm sản phẩm vào giỏ hàng!");
                                            }
                                        } else {
                                            alert("Lỗi: " + data.message);
                                        }
                                    })
                                    .catch(err => {
                                        console.error(err);
                                        alert("Đã có lỗi xảy ra, vui lòng thử lại.");
                                    });
                            }

                            document.getElementById("btnAddToCart").addEventListener("click", () => {
                                addToCart();
                            });

                            document.getElementById("btnBuyNow").addEventListener("click", () => {
                                addToCart(() => {
                                    window.location.href = "${pageContext.request.contextPath}/cart";
                                });
                            });

                            // Inline inforProduct.js logic
                            document.addEventListener("DOMContentLoaded", () => {
                                const container = document.querySelector(".product-info");
                                if (!container) return;

                                const wrap = container.querySelector("#descWrap");
                                if (!wrap) return;

                                const btn = container.querySelector("#toggleDesc");
                                if (!btn) return;

                                let expanded = false;
                                setCollapsed(false);

                                btn.addEventListener("click", () => {
                                    expanded = !expanded;
                                    setCollapsed(expanded);
                                });

                                window.addEventListener("resize", () => {
                                    if (expanded) wrap.style.maxHeight = wrap.scrollHeight + "px";
                                });

                                function setCollapsed(open) {
                                    if (open) {
                                        wrap.classList.add("expanded");
                                        wrap.style.maxHeight = wrap.scrollHeight + "px";
                                        btn.textContent = "Thu gọn ▲";
                                    } else {
                                        wrap.classList.remove("expanded");
                                        wrap.style.maxHeight = "300px";
                                        btn.textContent = "Xem tất cả ▼";
                                    }
                                }
                            });
                        </script>
                        <script src="${pageContext.request.contextPath}/style/header/header.js"></script>
                        <script src="${pageContext.request.contextPath}/Product_Detail/JS/product_detail.js"></script>

            </body>

            </html>