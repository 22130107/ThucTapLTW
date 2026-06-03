package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.InventoryDAO;
import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.InventoryTransaction;
import vn.edu.hcmuaf.fit.model.InventoryTransactionItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryService {
    private static final InventoryService instance = new InventoryService();

    public static InventoryService getInstance() { return instance; }

    public boolean importStock(List<ImportItem> items, String note, int createdBy) {
        InventoryTransaction t = new InventoryTransaction();
        t.setType("import");
        t.setNote(note);
        t.setCreatedBy(createdBy);

        List<InventoryTransactionItem> txItems = new ArrayList<>();
        for (ImportItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            int newStock = currentStock + item.getQuantity();

            if (!updateStock(item.getProductId(), currentStock + item.getQuantity())) {
                return false;
            }

            InventoryTransactionItem txItem = new InventoryTransactionItem();
            txItem.setProductId(item.getProductId());
            txItem.setQuantityChange(item.getQuantity());
            txItem.setCurrentStock(newStock);
            txItem.setNote(item.getNote());
            txItems.add(txItem);
        }

        int id = InventoryDAO.getInstance().createTransaction(t, txItems);
        return id != -1;
    }

    public boolean exportStock(List<ExportItem> items, String note, int createdBy) {
        for (ExportItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            if (currentStock < item.getQuantity()) return false;
        }

        InventoryTransaction t = new InventoryTransaction();
        t.setType("export");
        t.setNote(note);
        t.setCreatedBy(createdBy);

        List<InventoryTransactionItem> txItems = new ArrayList<>();
        for (ExportItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            int newStock = currentStock - item.getQuantity();

            if (!updateStock(item.getProductId(), newStock)) return false;

            InventoryTransactionItem txItem = new InventoryTransactionItem();
            txItem.setProductId(item.getProductId());
            txItem.setQuantityChange(-item.getQuantity());
            txItem.setCurrentStock(newStock);
            txItem.setNote(item.getNote());
            txItems.add(txItem);
        }

        int id = InventoryDAO.getInstance().createTransaction(t, txItems);
        return id != -1;
    }

    public boolean adjustStock(List<AdjustItem> items, String note, int createdBy) {
        InventoryTransaction t = new InventoryTransaction();
        t.setType("adjust");
        t.setNote(note);
        t.setCreatedBy(createdBy);

        List<InventoryTransactionItem> txItems = new ArrayList<>();
        for (AdjustItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            int quantityChange = item.getNewStock() - currentStock;

            if (!updateStock(item.getProductId(), item.getNewStock())) return false;

            InventoryTransactionItem txItem = new InventoryTransactionItem();
            txItem.setProductId(item.getProductId());
            txItem.setQuantityChange(quantityChange);
            txItem.setCurrentStock(item.getNewStock());
            txItem.setNote(item.getNote());
            txItems.add(txItem);
        }

        int id = InventoryDAO.getInstance().createTransaction(t, txItems);
        return id != -1;
    }

    public boolean deductStockForOrder(int orderId, List<OrderStockItem> items) {
        for (OrderStockItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            if (currentStock < item.getQuantity()) return false;
        }

        InventoryTransaction t = new InventoryTransaction();
        t.setType("order_export");
        t.setReferenceId(orderId);

        List<InventoryTransactionItem> txItems = new ArrayList<>();
        for (OrderStockItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            int newStock = currentStock - item.getQuantity();

            if (!updateStock(item.getProductId(), newStock)) return false;
            if (!incrementSold(item.getProductId(), item.getQuantity())) return false;

            InventoryTransactionItem txItem = new InventoryTransactionItem();
            txItem.setProductId(item.getProductId());
            txItem.setQuantityChange(-item.getQuantity());
            txItem.setCurrentStock(newStock);
            txItems.add(txItem);
        }

        int id = InventoryDAO.getInstance().createTransaction(t, txItems);
        return id != -1;
    }

    public boolean restoreStockForOrder(int orderId, List<OrderStockItem> items) {
        InventoryTransaction t = new InventoryTransaction();
        t.setType("order_cancel_return");
        t.setReferenceId(orderId);

        List<InventoryTransactionItem> txItems = new ArrayList<>();
        for (OrderStockItem item : items) {
            int currentStock = getCurrentStock(item.getProductId());
            int newStock = currentStock + item.getQuantity();

            if (!updateStock(item.getProductId(), newStock)) return false;
            if (!decrementSold(item.getProductId(), item.getQuantity())) return false;

            InventoryTransactionItem txItem = new InventoryTransactionItem();
            txItem.setProductId(item.getProductId());
            txItem.setQuantityChange(item.getQuantity());
            txItem.setCurrentStock(newStock);
            txItems.add(txItem);
        }

        int id = InventoryDAO.getInstance().createTransaction(t, txItems);
        return id != -1;
    }

    public boolean validateStock(int productId, int quantity) {
        int currentStock = getCurrentStock(productId);
        return currentStock >= quantity;
    }

    public int getCurrentStock(int productId) {
        String sql = "SELECT StockQuantity FROM productdetails WHERE ProductID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return 0;
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("StockQuantity");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private boolean updateStock(int productId, int newStock) {
        String sql = "UPDATE productdetails SET StockQuantity = ? WHERE ProductID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return false;
            ps.setInt(1, newStock);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean incrementSold(int productId, int quantity) {
        String sql = "UPDATE products SET SoldQuantity = SoldQuantity + ? WHERE ProductID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return false;
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean decrementSold(int productId, int quantity) {
        String sql = "UPDATE products SET SoldQuantity = GREATEST(0, SoldQuantity - ?) WHERE ProductID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return false;
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countLowStockProducts() {
        return InventoryDAO.getInstance().countLowStockProducts();
    }

    public List<InventoryTransaction> getAllTransactions() {
        return InventoryDAO.getInstance().getAllTransactions();
    }

    public InventoryTransaction getTransactionById(int id) {
        return InventoryDAO.getInstance().getById(id);
    }

    public List<InventoryTransaction> getTransactionsByProductId(int productId) {
        return InventoryDAO.getInstance().getTransactionsByProductId(productId);
    }

    public static class ImportItem {
        private int productId;
        private int quantity;
        private String note;

        public ImportItem(int productId, int quantity, String note) {
            this.productId = productId;
            this.quantity = quantity;
            this.note = note;
        }

        public int getProductId() { return productId; }
        public int getQuantity() { return quantity; }
        public String getNote() { return note; }
    }

    public static class ExportItem {
        private int productId;
        private int quantity;
        private String note;

        public ExportItem(int productId, int quantity, String note) {
            this.productId = productId;
            this.quantity = quantity;
            this.note = note;
        }

        public int getProductId() { return productId; }
        public int getQuantity() { return quantity; }
        public String getNote() { return note; }
    }

    public static class AdjustItem {
        private int productId;
        private int newStock;
        private String note;

        public AdjustItem(int productId, int newStock, String note) {
            this.productId = productId;
            this.newStock = newStock;
            this.note = note;
        }

        public int getProductId() { return productId; }
        public int getNewStock() { return newStock; }
        public String getNote() { return note; }
    }

    public static class OrderStockItem {
        private int productId;
        private int quantity;

        public OrderStockItem(int productId, int quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }

        public int getProductId() { return productId; }
        public int getQuantity() { return quantity; }
    }
}
