package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class OrderShippingGhn {
    private int orderId;
    private String ghnOrderCode;
    private String ghnStatus;
    private Timestamp lastSyncedAt;
    private String lastRawResponse;
    private Timestamp createdAt;

    public OrderShippingGhn() {
    }

    public OrderShippingGhn(int orderId, String ghnOrderCode, String ghnStatus, Timestamp lastSyncedAt,
                            String lastRawResponse, Timestamp createdAt) {
        this.orderId = orderId;
        this.ghnOrderCode = ghnOrderCode;
        this.ghnStatus = ghnStatus;
        this.lastSyncedAt = lastSyncedAt;
        this.lastRawResponse = lastRawResponse;
        this.createdAt = createdAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getGhnOrderCode() {
        return ghnOrderCode;
    }

    public void setGhnOrderCode(String ghnOrderCode) {
        this.ghnOrderCode = ghnOrderCode;
    }

    public String getGhnStatus() {
        return ghnStatus;
    }

    public void setGhnStatus(String ghnStatus) {
        this.ghnStatus = ghnStatus;
    }

    public Timestamp getLastSyncedAt() {
        return lastSyncedAt;
    }

    public void setLastSyncedAt(Timestamp lastSyncedAt) {
        this.lastSyncedAt = lastSyncedAt;
    }

    public String getLastRawResponse() {
        return lastRawResponse;
    }

    public void setLastRawResponse(String lastRawResponse) {
        this.lastRawResponse = lastRawResponse;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
