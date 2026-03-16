package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.Order;

public class OrderService {
    private static final OrderService instance = new OrderService();

    private OrderService() {
    }

    public static OrderService getInstance() {
        return instance;
    }

    public boolean placeOrder(int customerId, String recipientName, String shippingAddress, String paymentMethod) {
        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            return false;
        }

        Order order = new Order();
        order.setCustomerId(customerId);
        order.setTotalAmount(cart.getTotalPrice());
        order.setStatus("Pending");
        order.setRecipientName(recipientName);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);

        int orderId = OrderDAO.getInstance().createOrder(order, cart);
        if (orderId != -1) {

            CartService.getInstance().clearCart(customerId);
            return true;
        }
        return false;
    }
}
