package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductDAO {
    private static ProductDAO instance;

    private ProductDAO() {
    }

    public static ProductDAO getInstance() {
        if (instance == null) {
            instance = new ProductDAO();
        }
        return instance;
    }


    public Product getProductById(int id) {
        Product p = null;
        String query = "SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                       "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                       "pd.Price, pd.OldPrice, pd.StockQuantity, pd.DetailDescription " +
                       "FROM products p " +
                       "JOIN productdetails pd ON p.ProductID = pd.ProductID " +
                       "WHERE p.ProductID = ?";

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = new Product();
                
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("ProductName"));
                p.setBrand(rs.getString("Brand"));
                p.setImg(rs.getString("ImageURL"));
                p.setRating(rs.getDouble("Rating"));
                p.setReviews(rs.getInt("ReviewCount"));
                p.setBadge(rs.getString("Badge"));
                p.setInstallment(rs.getBoolean("IsInstallment"));
                p.setSold(rs.getInt("SoldQuantity"));

                p.setPrice(rs.getDouble("Price"));
                p.setOldPrice(rs.getDouble("OldPrice"));
                p.setStock(rs.getInt("StockQuantity"));
                p.setDescription(rs.getString("DetailDescription"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }
}