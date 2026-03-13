package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.CartItem;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.service.ProductService;

import java.sql.*;

public class CartDAO {
    private static CartDAO instance;

    private CartDAO() {
    }

    public static CartDAO getInstance() {
        if (instance == null) {
            instance = new CartDAO();
        }
        return instance;
    }

    // Get Cart by CustomerID
    public Cart getCartByCustomerId(int customerId) {
        Cart cart = new Cart();
        String sqlCart = "SELECT CartID FROM carts WHERE CustomerID = ?";
        String sqlItems = "SELECT ProductID, Quantity FROM cartitems WHERE CartID = ? AND IsActive = 1";

        try (Connection conn = DBConnect.get()) {
            if (conn == null) return cart;
            int cartId = -1;
            try (PreparedStatement psCart = conn.prepareStatement(sqlCart)) {
                psCart.setInt(1, customerId);
                try (ResultSet rsCart = psCart.executeQuery()) {
                    if (rsCart.next()) {
                        cartId = rsCart.getInt("CartID");
                    } else {
                        return cart; // Empty cart if no record found
                    }
                }
            }

            try (PreparedStatement psItems = conn.prepareStatement(sqlItems)) {
                psItems.setInt(1, cartId);
                try (ResultSet rsItems = psItems.executeQuery()) {
                    while (rsItems.next()) {
                        int productId = rsItems.getInt("ProductID");
                        int quantity = rsItems.getInt("Quantity");
                        Product product = ProductService.getInstance().getProductById(productId);
                        if (product != null) {
                            cart.getData().put(productId, new CartItem(product, quantity));
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }

    // Create Cart for Customer
    public int createCart(int customerId) {
        String sql = "INSERT INTO carts (CustomerID) VALUES (?)";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return -1;
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Get CartID by CustomerID (Helper)
    public int getCartId(int customerId) {
        String sql = "SELECT CartID FROM carts WHERE CustomerID = ?";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return -1;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        return rs.getInt("CartID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Add or Update Item in DB
    public void addItem(int cartId, int productId, int quantity, double price) {
        // Check if item exists (active or deleted)
        String checkSql = "SELECT Quantity, IsActive FROM cartitems WHERE CartID = ? AND ProductID = ?";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, cartId);
                psCheck.setInt(2, productId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        int currentQty = rs.getInt("Quantity");
                        boolean isActive = rs.getBoolean("IsActive");
                        String updateSql = "UPDATE cartitems SET Quantity = ?, IsActive = 1 WHERE CartID = ? AND ProductID = ?";
                        try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                            psUpdate.setInt(1, isActive ? currentQty + quantity : quantity);
                            psUpdate.setInt(2, cartId);
                            psUpdate.setInt(3, productId);
                            psUpdate.executeUpdate();
                        }
                    } else {
                        String insertSql = "INSERT INTO cartitems (CartID, ProductID, Quantity, Price, IsActive) VALUES (?, ?, ?, ?, 1)";
                        try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                            psInsert.setInt(1, cartId);
                            psInsert.setInt(2, productId);
                            psInsert.setInt(3, quantity);
                            psInsert.setDouble(4, price);
                            psInsert.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateItemQuantity(int cartId, int productId, int quantity) {
        String sql = "UPDATE cartitems SET Quantity = ?, IsActive = 1 WHERE CartID = ? AND ProductID = ?";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, cartId);
                ps.setInt(3, productId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeItem(int cartId, int productId) {
        // Soft delete: set IsActive = 0 instead of DELETE
        String sql = "UPDATE cartitems SET IsActive = 0 WHERE CartID = ? AND ProductID = ?";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void clearCart(int cartId) {
        String sql = "UPDATE cartitems SET IsActive = 0 WHERE CartID = ?";
        try (Connection conn = DBConnect.get()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
