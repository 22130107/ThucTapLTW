package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.OrderShippingGhnDAO;
import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.OrderShippingGhn;
import vn.edu.hcmuaf.fit.service.OrderService;
import vn.edu.hcmuaf.fit.util.GhnStatusMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminOrderController", value = "/admin/orders")
public class AdminOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q        = request.getParameter("q");
        String status   = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo   = request.getParameter("dateTo");
        String priceMin = request.getParameter("priceMin");
        String priceMax = request.getParameter("priceMax");

        OrderDAO dao = OrderDAO.getInstance();
        List<Order> list;

        boolean hasFilter = isNotBlank(q) || isNotBlank(status) || isNotBlank(dateFrom)
                || isNotBlank(dateTo) || isNotBlank(priceMin) || isNotBlank(priceMax);

        list = hasFilter
                ? dao.filter(q, status, dateFrom, dateTo, priceMin, priceMax)
                : dao.getAll();

        // Gắn thêm thông tin GHN (mã vận đơn, trạng thái GHN tiếng Việt) cho từng đơn
        Map<Integer, OrderShippingGhn> ghnMap = buildGhnMap(list);

        request.setAttribute("listO",        list);
        request.setAttribute("ghnMap",       ghnMap);
        request.setAttribute("msgName",      q);
        request.setAttribute("msgStatus",    status);
        request.setAttribute("msgDateFrom",  dateFrom);
        request.setAttribute("msgDateTo",    dateTo);
        request.setAttribute("msgPriceMin",  priceMin);
        request.setAttribute("msgPriceMax",  priceMax);

        request.getRequestDispatcher("/Admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);

        } else if ("syncGhn".equals(action)) {
            // Sync thủ công — admin bấm nút "Đồng bộ GHN"
            OrderService.getInstance().syncGhnStatuses();
            response.sendRedirect("orders");

        } else {
            doGet(request, response);
        }
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    orderId = Integer.parseInt(request.getParameter("id"));
        String status  = request.getParameter("status");

        if ("Processing".equals(status)) {
            // Xác nhận đơn → tạo vận đơn GHN
            OrderService.getInstance().confirmOrderAndCreateGhn(orderId);
            OrderDAO.getInstance().updateStatus(orderId, status);

        } else if ("Cancelled".equals(status)) {
            // Chỉ cho hủy khi đơn đang Pending
            vn.edu.hcmuaf.fit.model.Order order = OrderDAO.getInstance().getById(orderId);
            if (order != null && "Pending".equals(order.getStatus())) {
                OrderDAO.getInstance().updateStatus(orderId, status);
            }
        }
        // Các trạng thái khác (Shipping, Completed) do GHN sync — không xử lý ở đây

        response.sendRedirect("orders");
    }

    /**
     * Xây dựng map orderId → OrderShippingGhn để JSP hiển thị mã vận đơn
     * và trạng thái GHN mà không cần query từng dòng.
     */
    private Map<Integer, OrderShippingGhn> buildGhnMap(List<Order> orders) {
        Map<Integer, OrderShippingGhn> map = new HashMap<>();
        OrderShippingGhnDAO ghnDAO = OrderShippingGhnDAO.getInstance();
        for (Order o : orders) {
            OrderShippingGhn ghn = ghnDAO.getByOrderId(o.getOrderId());
            if (ghn != null) {
                map.put(o.getOrderId(), ghn);
            }
        }
        return map;
    }

    private static boolean isNotBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }
}
