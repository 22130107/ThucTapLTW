package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class OrderShipping {
    private int orderId;
    private String recipientPhone;
    private int toDistrictId;
    private String toWardCode;
    private Timestamp createdAt;

    public OrderShipping() {
    }

    public OrderShipping(int orderId, String recipientPhone, int toDistrictId, String toWardCode, Timestamp createdAt) {
        this.orderId = orderId;
        this.recipientPhone = recipientPhone;
        this.toDistrictId = toDistrictId;
        this.toWardCode = toWardCode;
        this.createdAt = createdAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public int getToDistrictId() {
        return toDistrictId;
    }

    public void setToDistrictId(int toDistrictId) {
        this.toDistrictId = toDistrictId;
    }

    public String getToWardCode() {
        return toWardCode;
    }

    public void setToWardCode(String toWardCode) {
        this.toWardCode = toWardCode;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
