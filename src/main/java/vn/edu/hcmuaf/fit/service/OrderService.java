package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.OrderShippingDAO;
import vn.edu.hcmuaf.fit.dao.OrderShippingGhnDAO;
import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.OrderItem;
import vn.edu.hcmuaf.fit.model.OrderShipping;
import vn.edu.hcmuaf.fit.model.OrderShippingGhn;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.util.GhnClient;
import vn.edu.hcmuaf.fit.util.GhnConfig;
import vn.edu.hcmuaf.fit.util.GhnStatusMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import java.util.List;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.Order;

public class OrderService {
    private static final OrderService instance = new OrderService();

    private OrderService() {
    }

    public static OrderService getInstance() {
        return instance;
    }

    public boolean placeOrder(int customerId, String recipientName, String recipientPhone, String shippingAddress,
                              int toDistrictId, String toWardCode, String paymentMethod) {
        Cart cart = CartService.getInstance().getCart(customerId);
        if (cart == null || cart.getData().isEmpty()) {
            System.out.println("[OrderService] placeOrder failed: cart null or empty for customerId=" + customerId);
            return false;
        }

        Order order = new Order();
        order.setCustomerId(customerId);
        order.setTotalAmount(cart.getTotalPrice());
        order.setStatus("Pending");
        order.setRecipientName(recipientName);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);

        System.out.println("[OrderService] Creating order for customerId=" + customerId
                + " toDistrictId=" + toDistrictId + " toWardCode=" + toWardCode);

        int orderId = OrderDAO.getInstance().createOrder(order, cart, recipientPhone, toDistrictId, toWardCode);
        System.out.println("[OrderService] createOrder returned orderId=" + orderId);

        if (orderId != -1) {
            CartService.getInstance().clearCart(customerId);
            return true;
        }
        return false;
    }

    public boolean confirmOrderAndCreateGhn(int orderId) {
        OrderDAO orderDAO = OrderDAO.getInstance();
        OrderShippingGhnDAO ghnDAO = OrderShippingGhnDAO.getInstance();

        OrderShippingGhn existing = ghnDAO.getByOrderId(orderId);
        if (existing != null && existing.getGhnOrderCode() != null && !existing.getGhnOrderCode().isEmpty()) {
            return true;
        }

        vn.edu.hcmuaf.fit.model.Order order = orderDAO.getById(orderId);
        if (order == null) return false;

        OrderShipping shipping = OrderShippingDAO.getInstance().getByOrderId(orderId);
        if (shipping == null) return false;

        JsonObject payload = buildGhnPayload(orderId, order, shipping);
        if (payload == null) return false;

        try {
            GhnClient.GhnCreateResult result = GhnClient.createOrder(payload);
            String orderCode = result.getOrderCode();
            if (result.getCode() == 200 && orderCode != null) {
                ghnDAO.upsert(orderId, orderCode, "created", result.getRawResponse());
                return true;
            }
            ghnDAO.upsert(orderId, orderCode, "create_failed", result.getRawResponse());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void syncGhnStatuses() {
        OrderShippingGhnDAO ghnDAO = OrderShippingGhnDAO.getInstance();
        OrderDAO orderDAO = OrderDAO.getInstance();

        for (OrderShippingGhn ghn : ghnDAO.getActiveGhnOrders()) {
            if (ghn.getGhnOrderCode() == null || ghn.getGhnOrderCode().isEmpty()) continue;
            try {
                GhnClient.GhnStatusResult result = GhnClient.getOrderDetail(ghn.getGhnOrderCode());
                if (result.getCode() == 200 && result.getStatus() != null) {
                    // Chỉ cập nhật khi trạng thái GHN thực sự thay đổi
                    if (!result.getStatus().equals(ghn.getGhnStatus())) {
                        ghnDAO.upsert(ghn.getOrderId(), ghn.getGhnOrderCode(),
                                result.getStatus(), result.getRawResponse());
                        String mapped = GhnStatusMapper.toOrderStatus(result.getStatus());
                        if (mapped != null) {
                            orderDAO.updateStatus(ghn.getOrderId(), mapped);
                        }
                    }
                }
                // Nếu code != 200 hoặc status null → bỏ qua, không ghi đè dữ liệu cũ
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private JsonObject buildGhnPayload(int orderId, vn.edu.hcmuaf.fit.model.Order order, OrderShipping shipping) {
        JsonObject payload = new JsonObject();
        payload.addProperty("payment_type_id", GhnConfig.PAYMENT_TYPE_ID());
        payload.addProperty("note", "Don hang #" + orderId);
        payload.addProperty("required_note", "KHONGCHOXEMHANG");

        payload.addProperty("return_phone", GhnConfig.FROM_PHONE());
        payload.addProperty("return_address", GhnConfig.FROM_ADDRESS());
        payload.addProperty("return_district_id", GhnConfig.FROM_DISTRICT_ID());
        payload.addProperty("return_ward_code", GhnConfig.FROM_WARD_CODE());

        payload.addProperty("from_name", GhnConfig.FROM_NAME());
        payload.addProperty("from_phone", GhnConfig.FROM_PHONE());
        payload.addProperty("from_address", GhnConfig.FROM_ADDRESS());
        payload.addProperty("from_district_id", GhnConfig.FROM_DISTRICT_ID());
        payload.addProperty("from_ward_code", GhnConfig.FROM_WARD_CODE());

        payload.addProperty("to_name", order.getRecipientName());
        payload.addProperty("to_phone", shipping.getRecipientPhone());
        payload.addProperty("to_address", order.getShippingAddress());
        payload.addProperty("to_ward_code", shipping.getToWardCode());
        payload.addProperty("to_district_id", shipping.getToDistrictId());

        payload.addProperty("client_order_code", "ORDER-" + orderId);
        payload.addProperty("service_type_id", GhnConfig.SERVICE_TYPE_ID());

        double codAmount = "COD".equalsIgnoreCase(order.getPaymentMethod()) ? order.getTotalAmount() : 0;
        payload.addProperty("cod_amount", codAmount);
        payload.addProperty("content", "Don hang #" + orderId);

        List<OrderItem> items = OrderDAO.getInstance().getItems(orderId);
        if (items == null || items.isEmpty()) return null;

        int totalQuantity = 0;
        JsonArray jsonItems = new JsonArray();
        for (OrderItem item : items) {
            Product product = ProductDAO.getInstance().getProductById(item.getProductId());
            String name = product != null ? product.getName() : ("Product #" + item.getProductId());

            JsonObject jsonItem = new JsonObject();
            jsonItem.addProperty("name", name);
            jsonItem.addProperty("quantity", item.getQuantity());
            jsonItem.addProperty("price", item.getPriceAtOrder());
            jsonItem.addProperty("weight", GhnConfig.DEFAULT_WEIGHT());
            jsonItems.add(jsonItem);

            totalQuantity += item.getQuantity();
        }

        int totalWeight = Math.max(GhnConfig.DEFAULT_WEIGHT(), GhnConfig.DEFAULT_WEIGHT() * totalQuantity);
        payload.addProperty("weight", totalWeight);
        payload.addProperty("length", GhnConfig.DEFAULT_LENGTH());
        payload.addProperty("width", GhnConfig.DEFAULT_WIDTH());
        payload.addProperty("height", GhnConfig.DEFAULT_HEIGHT());
        payload.add("items", jsonItems);

        return payload;
    }
}
