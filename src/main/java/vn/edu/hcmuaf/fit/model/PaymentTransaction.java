package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class PaymentTransaction {

    private int id;
    private int orderId;
    private String txnRef;
    private String vnpTransactionNo;
    private long amount;
    private String bankCode;
    private String payDate;
    private String responseCode;
    private String transactionStatus;
    private String orderInfo;
    private String status;
    private Timestamp createdAt;

    public PaymentTransaction() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getTxnRef() { return txnRef; }
    public void setTxnRef(String txnRef) { this.txnRef = txnRef; }

    public String getVnpTransactionNo() { return vnpTransactionNo; }
    public void setVnpTransactionNo(String v) { this.vnpTransactionNo = v; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getBankCode() { return bankCode; }
    public void setBankCode(String bankCode) { this.bankCode = bankCode; }

    public String getPayDate() { return payDate; }
    public void setPayDate(String payDate) { this.payDate = payDate; }

    public String getResponseCode() { return responseCode; }
    public void setResponseCode(String v) { this.responseCode = v; }

    public String getTransactionStatus() { return transactionStatus; }
    public void setTransactionStatus(String v) { this.transactionStatus = v; }

    public String getOrderInfo() { return orderInfo; }
    public void setOrderInfo(String orderInfo) { this.orderInfo = orderInfo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp t) { this.createdAt = t; }

    public boolean isSuccess() {
        return "SUCCESS".equalsIgnoreCase(status)
                || ("00".equals(responseCode) && "00".equals(transactionStatus));
    }
}