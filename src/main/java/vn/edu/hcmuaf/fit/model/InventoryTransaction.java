package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;
import java.util.List;

public class InventoryTransaction {
    private int id;
    private String type;
    private Integer referenceId;
    private String note;
    private Integer createdBy;
    private Timestamp createdAt;
    private List<InventoryTransactionItem> items;

    public InventoryTransaction() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Integer getReferenceId() { return referenceId; }
    public void setReferenceId(Integer referenceId) { this.referenceId = referenceId; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<InventoryTransactionItem> getItems() { return items; }
    public void setItems(List<InventoryTransactionItem> items) { this.items = items; }

    public String getTypeVietnamese() {
        if (type == null) return "";
        switch (type) {
            case "import": return "Nhập kho";
            case "export": return "Xuất kho";
            case "adjust": return "Kiểm kê";
            case "order_export": return "Xuất theo đơn hàng";
            case "order_cancel_return": return "Hoàn lại đơn hủy";
            default: return type;
        }
    }
}
