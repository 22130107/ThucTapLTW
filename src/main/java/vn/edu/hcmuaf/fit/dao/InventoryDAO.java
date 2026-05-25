package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.InventoryTransaction;
import vn.edu.hcmuaf.fit.model.InventoryTransactionItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {
    private static final InventoryDAO instance = new InventoryDAO();

    public static InventoryDAO getInstance() { return instance; }

    public int createTransaction(InventoryTransaction t, List<InventoryTransactionItem> items) {
        int transactionId = -1;
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return -1;
            try {
                conn.setAutoCommit(false);

                String sql = "INSERT INTO inventory_transactions (type, reference_id, note, created_by) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, t.getType());
                    if (t.getReferenceId() != null) ps.setInt(2, t.getReferenceId());
                    else ps.setNull(2, Types.INTEGER);
                    ps.setString(3, t.getNote());
                    if (t.getCreatedBy() != null) ps.setInt(4, t.getCreatedBy());
                    else ps.setNull(4, Types.INTEGER);
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) transactionId = rs.getInt(1);
                    }
                }

                if (transactionId == -1) {
                    conn.rollback();
                    return -1;
                }

                String sqlItem = "INSERT INTO inventory_transaction_items (transaction_id, product_id, quantity_change, current_stock, note) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sqlItem)) {
                    for (InventoryTransactionItem item : items) {
                        ps.setInt(1, transactionId);
                        ps.setInt(2, item.getProductId());
                        ps.setInt(3, item.getQuantityChange());
                        ps.setInt(4, item.getCurrentStock());
                        ps.setString(5, item.getNote());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return -1;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactionId;
    }

    public List<InventoryTransaction> getAllTransactions() {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM inventory_transactions ORDER BY created_at DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (conn == null) return list;
            while (rs.next()) {
                list.add(mapTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<InventoryTransaction> getTransactionsByProductId(int productId) {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT DISTINCT t.* FROM inventory_transactions t " +
                     "JOIN inventory_transaction_items i ON t.id = i.transaction_id " +
                     "WHERE i.product_id = ? ORDER BY t.created_at DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return list;
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransaction t = mapTransaction(rs);
                    t.setItems(getItemsByTransactionId(t.getId()));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public InventoryTransaction getById(int id) {
        String sql = "SELECT * FROM inventory_transactions WHERE id = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return null;
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryTransaction t = mapTransaction(rs);
                    t.setItems(getItemsByTransactionId(t.getId()));
                    return t;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<InventoryTransactionItem> getItemsByTransactionId(int transactionId) {
        List<InventoryTransactionItem> list = new ArrayList<>();
        String sql = "SELECT i.*, p.ProductName FROM inventory_transaction_items i " +
                     "LEFT JOIN products p ON i.product_id = p.ProductID " +
                     "WHERE i.transaction_id = ? ORDER BY i.id";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return list;
            ps.setInt(1, transactionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransactionItem item = new InventoryTransactionItem();
                    item.setId(rs.getInt("id"));
                    item.setTransactionId(rs.getInt("transaction_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantityChange(rs.getInt("quantity_change"));
                    item.setCurrentStock(rs.getInt("current_stock"));
                    item.setNote(rs.getString("note"));
                    item.setProductName(rs.getString("ProductName"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countLowStockProducts() {
        String sql = "SELECT COUNT(*) FROM productdetails WHERE StockQuantity >= 0 " +
                     "AND StockQuantity <= low_stock_threshold";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (conn == null) return 0;
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private InventoryTransaction mapTransaction(ResultSet rs) throws SQLException {
        InventoryTransaction t = new InventoryTransaction();
        t.setId(rs.getInt("id"));
        t.setType(rs.getString("type"));
        int refId = rs.getInt("reference_id");
        if (!rs.wasNull()) t.setReferenceId(refId);
        t.setNote(rs.getString("note"));
        int createdBy = rs.getInt("created_by");
        if (!rs.wasNull()) t.setCreatedBy(createdBy);
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }
}
