package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int customerId;
    private Timestamp orderDate;
    private double totalAmount;
    private String status; // Enum: Pending, Processing, Shipping, Completed, Cancelled
    private String paymentMethod;
    private String recipientName;
    private String shippingAddress;

    public Order() {
    }

    public Order(int orderId, int customerId, Timestamp orderDate, double totalAmount, String status,
                 String paymentMethod, String recipientName, String shippingAddress) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.recipientName = recipientName;
        this.shippingAddress = shippingAddress;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }


    public String getStatusVietnamese() {
        if (status == null) return "Không xác định";
        switch (status) {
            case "Pending":    return "Chờ xác nhận";
            case "Processing": return "Đã xác nhận";
            case "Shipping":   return "Đang giao";
            case "Completed":  return "Đã giao";
            case "Cancelled":  return "Đã hủy";
            default:           return status;
        }
    }


    public String getStatusCssClass() {
        if (status == null) return "secondary";
        switch (status) {
            case "Pending":    return "warning";   // Vàng
            case "Processing": return "primary";   // Xanh dương
            case "Shipping":   return "info";      // Xanh lơ
            case "Completed":  return "success";   // Xanh lá
            case "Cancelled":  return "danger";    // Đỏ
            default:           return "secondary";
        }
    }
}