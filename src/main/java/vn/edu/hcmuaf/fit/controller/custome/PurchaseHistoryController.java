package vn.edu.hcmuaf.fit.controller.custome;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PurchaseHistoryController", value = "/purchase-history")
public class PurchaseHistoryController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        Customer customer = (Customer) session.getAttribute("customer");

        if (user == null || customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = OrderDAO.getInstance();
        List<Order> orders = orderDAO.getOrdersByCustomerId(customer.getCustomerID());

        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();

        Map<Integer, Product> productsMap = new HashMap<>();

        ProductDAO productDAO = ProductDAO.getInstance();

        for (Order order : orders) {

            List<OrderItem> items = orderDAO.getOrderItemsByOrderId(order.getOrderId());

            orderItemsMap.put(order.getOrderId(), items);

            for (OrderItem item : items) {

                if (!productsMap.containsKey(item.getProductId())) {
                    Product p = productDAO.getProductById(item.getProductId());
                    if (p != null) {
                        productsMap.put(item.getProductId(), p);
                    }
                }
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.setAttribute("productsMap", productsMap);

        request.getRequestDispatcher("/Customer/Purchase_history/purchase_history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}