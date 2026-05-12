package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.OrderShipping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderShippingDAO {
    private static volatile OrderShippingDAO instance;

    public static OrderShippingDAO getInstance() {
        if (instance == null) {
            synchronized (OrderShippingDAO.class) {
                if (instance == null) {
                    instance = new OrderShippingDAO();
                }
            }
        }
        return instance;
    }

    public boolean insert(int orderId, String recipientPhone, int toDistrictId, String toWardCode) throws SQLException {
        String sql = "INSERT INTO order_shipping (OrderID, RecipientPhone, ToDistrictId, ToWardCode) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, recipientPhone);
            ps.setInt(3, toDistrictId);
            ps.setString(4, toWardCode);
            return ps.executeUpdate() > 0;
        }
    }

    public OrderShipping getByOrderId(int orderId) {
        String sql = "SELECT * FROM order_shipping WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new OrderShipping(
                            rs.getInt("OrderID"),
                            rs.getString("RecipientPhone"),
                            rs.getInt("ToDistrictId"),
                            rs.getString("ToWardCode"),
                            rs.getTimestamp("CreatedAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
