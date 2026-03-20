<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- Lấy đối tượng User và Customer từ Session --%>
<c:set var="user" value="${sessionScope.auth}"/>
<c:set var="customer" value="${sessionScope.customer}"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%--<c:set var="currentPath" value="${pageContext.request.servletPath}"/>--%>
<c:set var="currentURI" value="${pageContext.request.requestURI}"/>

<c:if test="${not empty user}">
    <aside class="sidebar">
        <div class="profile">
                <%-- Hiển thị chữ cái đầu tiên cho Avatar --%>
            <div class="avatar">
                <c:choose>
                    <c:when test="${not empty customer.fullName}">
                        ${fn:substring(customer.fullName, 0, 1)}
                    </c:when>
                    <c:otherwise>
                        ${fn:substring(user.username, 0, 1)}
                    </c:otherwise>
                </c:choose>
            </div>
                <%-- Hiển thị Username --%>
            <p class="username">${user.username}</p>
        </div>

        <ul class="menu">

                <%-- MỤC 1: THÔNG TIN TÀI KHOẢN (Lien kết đến /update-profile) --%>
                <%-- Thêm class 'active' nếu đang ở trang Profile --%>
            <li class="${currentPath == '/update-profile' ? 'active' : ''}">
                <a href="${contextPath}/update-profile">
                    <i class="fa-regular fa-user"></i> Thông tin tài khoản
                </a>
            </li>

                <%--                &lt;%&ndash; MỤC 2: ĐỊA CHỈ &ndash;%&gt;--%>
                <%--            <li class="${currentPath == '/address' ? 'active' : ''}">--%>
                <%--                <a href="${contextPath}/address">--%>
                <%--                    <i class="fa-solid fa-location-dot"></i> Địa chỉ--%>
                <%--                </a>--%>
                <%--            </li>--%>

                <%-- MỤC 3: LỊCH SỬ MUA HÀNG --%>
            <li class="${fn:contains(currentURI, 'purchase-history') ? 'active' : ''}">
                <a href="${contextPath}/purchase-history">
                    <i class="fa-regular fa-clock"></i> Lịch sử mua hàng
                </a>
            </li>

                <%-- MỤC 4: SẢN PHẨM ĐÃ XEM --%>
            <li class="${fn:contains(currentURI, 'appointment-history') ? 'active' : ''}">
                <a href="${contextPath}/appointment-history">
                    <i class="fa-regular fa-eye"></i> Xem lịch đặt khám
                </a>
            </li>

                <%--                &lt;%&ndash; MỤC 5: ĐÁNH GIÁ CỦA TÔI &ndash;%&gt;--%>
                <%--            <li>--%>
                <%--                <a href="${contextPath}/my-ratings">--%>
                <%--                    <i class="fa-regular fa-star"></i> Đánh giá của tôi--%>
                <%--                </a>--%>
                <%--            </li>--%>

                <%-- MỤC 6: ĐĂNG XUẤT --%>
            <li>
                <a href="${contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </li>

        </ul>
    </aside>
</c:if>