package vn.edu.hcmuaf.fit.model;

public class InventoryTransactionItem {
    private int id;
    private int transactionId;
    private int productId;
    private int quantityChange;
    private int currentStock;
    private String note;
    private String productName;

    public InventoryTransactionItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantityChange() { return quantityChange; }
    public void setQuantityChange(int quantityChange) { this.quantityChange = quantityChange; }

    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getQuantityFormatted() {
        if (quantityChange > 0) return "+" + quantityChange;
        return String.valueOf(quantityChange);
    }
}
