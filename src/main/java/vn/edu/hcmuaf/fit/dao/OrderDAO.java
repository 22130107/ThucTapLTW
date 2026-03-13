package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.CartItem;
import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderDAO {
    private static OrderDAO instance;

    public OrderDAO() {
    }

    public static OrderDAO getInstance() {
        if (instance == null) {
            instance = new OrderDAO();
        }
        return instance;
    }

    public int createOrder(Order order, Cart cart) {
        int orderId = -1;
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return -1;
            try {
                conn.setAutoCommit(false); 

                String sqlOrder = "INSERT INTO orders (CustomerID, TotalAmount, Status, PaymentMethod, RecipientName, ShippingAddress) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                    psOrder.setInt(1, order.getCustomerId());
                    psOrder.setDouble(2, order.getTotalAmount());
                    psOrder.setString(3, order.getStatus());
                    psOrder.setString(4, order.getPaymentMethod());
                    psOrder.setString(5, order.getRecipientName());
                    psOrder.setString(6, order.getShippingAddress());
                    psOrder.executeUpdate();

                    try (ResultSet rsOrder = psOrder.getGeneratedKeys()) {
                        if (rsOrder.next()) {
                            orderId = rsOrder.getInt(1);
                        }
                    }
                }

                String sqlDetail = "INSERT INTO orderitems (OrderID, ProductID, Quantity, PriceAtOrder) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    for (Map.Entry<Integer, CartItem> entry : cart.getData().entrySet()) {
                        CartItem item = entry.getValue();
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, item.getProduct().getId());
                        psDetail.setInt(3, item.getQuantity());
                        psDetail.setDouble(4, item.getProduct().getPrice());
                        psDetail.addBatch();
                    }
                    psDetail.executeBatch();
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
        return orderId;
    }

    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders ORDER BY OrderDate DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        rs.getInt("CustomerID"),
                        rs.getTimestamp("OrderDate"),
                        rs.getDouble("TotalAmount"),
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("RecipientName"),
                        rs.getString("ShippingAddress")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE CustomerID = ? ORDER BY OrderDate DESC";

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Order(
                            rs.getInt("OrderID"),
                            rs.getInt("CustomerID"),
                            rs.getTimestamp("OrderDate"),
                            rs.getDouble("TotalAmount"),
                            rs.getString("Status"),
                            rs.getString("PaymentMethod"),
                            rs.getString("RecipientName"),
                            rs.getString("ShippingAddress")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getById(int id) {
        String query = "SELECT * FROM orders WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Order(
                            rs.getInt("OrderID"),
                            rs.getInt("CustomerID"),
                            rs.getTimestamp("OrderDate"),
                            rs.getDouble("TotalAmount"),
                            rs.getString("Status"),
                            rs.getString("PaymentMethod"),
                            rs.getString("RecipientName"),
                            rs.getString("ShippingAddress"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String query = "SELECT * FROM orderitems WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new OrderItem(
                            rs.getInt("OrderItemID"),
                            rs.getInt("OrderID"),
                            rs.getInt("ProductID"),
                            rs.getInt("Quantity"),
                            rs.getDouble("PriceAtOrder")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        return getItems(orderId);
    }

    public void updateStatus(int orderId, String status) {
        String query = "UPDATE orders SET Status = ? WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Order> filter(String keyword, String status, String dateFrom, String dateTo, String priceMin, String priceMax) {
        List<Order> list = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM orders WHERE 1=1");

        if (keyword != null && !keyword.isEmpty()) {
            query.append(" AND (RecipientName LIKE ? OR OrderID LIKE ?)");
        }
        if (status != null && !status.isEmpty()) {
            query.append(" AND Status = ?");
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            query.append(" AND OrderDate >= ?");
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            query.append(" AND OrderDate <= ?");
        }
        if (priceMin != null && !priceMin.isEmpty()) {
            query.append(" AND TotalAmount >= ?");
        }
        if (priceMax != null && !priceMax.isEmpty()) {
            query.append(" AND TotalAmount <= ?");
        }

        query.append(" ORDER BY OrderDate DESC");

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                ps.setString(index++, dateFrom + " 00:00:00");
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                ps.setString(index++, dateTo + " 23:59:59");
            }
            if (priceMin != null && !priceMin.isEmpty()) {
                ps.setString(index++, priceMin);
            }
            if (priceMax != null && !priceMax.isEmpty()) {
                ps.setString(index++, priceMax);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Order(
                            rs.getInt("OrderID"),
                            rs.getInt("CustomerID"),
                            rs.getTimestamp("OrderDate"),
                            rs.getDouble("TotalAmount"),
                            rs.getString("Status"),
                            rs.getString("PaymentMethod"),
                            rs.getString("RecipientName"),
                            rs.getString("ShippingAddress")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String query = "UPDATE orders SET Status = ? WHERE OrderID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isOrderOwnedByCustomer(int orderId, int customerId) {
        String query = "SELECT Count(*) FROM orders WHERE OrderID = ? AND CustomerID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelOrder(int orderId) {
        String query = "UPDATE orders SET Status = 'Cancelled' WHERE OrderID = ? AND Status = 'Pending'";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
