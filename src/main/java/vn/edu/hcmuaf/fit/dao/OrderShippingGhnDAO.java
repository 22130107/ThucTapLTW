package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.OrderShippingGhn;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderShippingGhnDAO {
    private static volatile OrderShippingGhnDAO instance;

    public static OrderShippingGhnDAO getInstance() {
        if (instance == null) {
            synchronized (OrderShippingGhnDAO.class) {
                if (instance == null) {
                    instance = new OrderShippingGhnDAO();
                }
            }
        }
        return instance;
    }

    public boolean upsert(int orderId, String ghnOrderCode, String ghnStatus, String rawResponse) {
        String sql = "INSERT INTO order_shipping_ghn (OrderID, GhnOrderCode, GhnStatus, LastSyncedAt, LastRawResponse) " +
                "VALUES (?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE GhnOrderCode = VALUES(GhnOrderCode), GhnStatus = VALUES(GhnStatus), " +
                "LastSyncedAt = VALUES(LastSyncedAt), LastRawResponse = VALUES(LastRawResponse)";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, ghnOrderCode);
            ps.setString(3, ghnStatus);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setString(5, rawResponse);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public OrderShippingGhn getByOrderId(int orderId) {
        String sql = "SELECT * FROM order_shipping_ghn WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new OrderShippingGhn(
                            rs.getInt("OrderID"),
                            rs.getString("GhnOrderCode"),
                            rs.getString("GhnStatus"),
                            rs.getTimestamp("LastSyncedAt"),
                            rs.getString("LastRawResponse"),
                            rs.getTimestamp("CreatedAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderShippingGhn> getActiveGhnOrders() {
        String sql = "SELECT g.* FROM order_shipping_ghn g " +
                "JOIN orders o ON g.OrderID = o.OrderID " +
                "WHERE o.Status IN ('Processing','Shipping')";
        List<OrderShippingGhn> list = new ArrayList<>();
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new OrderShippingGhn(
                        rs.getInt("OrderID"),
                        rs.getString("GhnOrderCode"),
                        rs.getString("GhnStatus"),
                        rs.getTimestamp("LastSyncedAt"),
                        rs.getString("LastRawResponse"),
                        rs.getTimestamp("CreatedAt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
