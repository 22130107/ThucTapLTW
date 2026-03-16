package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    private static final ProductService instance = new ProductService();

    private ProductService() {
    }

    public static ProductService getInstance() {
        return instance;
    }

    public List<Product> getAllProducts() {
        return getProducts(null, null, null, null, null);
    }

    public List<Product> getProducts(Integer categoryId, String[] brands, String priceRange, String sort,
            String search) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null)
            return list;

        StringBuilder sql = new StringBuilder("SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID ");

        if (categoryId != null) {
            sql.append("JOIN product_categories pc ON p.ProductID = pc.ProductID ");
        }

        sql.append("WHERE d.StockQuantity >= 0 AND 1=1 ");

        if (categoryId != null) {
            sql.append("AND pc.CategoryID = ? ");
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND p.ProductName LIKE ? ");
        }

        if (brands != null && brands.length > 0) {
            sql.append("AND p.Brand IN (");
            for (int i = 0; i < brands.length; i++) {
                sql.append(i == 0 ? "?" : ", ?");
            }
            sql.append(") ");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "p1":
                    sql.append("AND d.Price < 2000000 ");
                    break;
                case "p2":
                    sql.append("AND d.Price >= 2000000 AND d.Price < 4000000 ");
                    break;
                case "p3":
                    sql.append("AND d.Price >= 4000000 AND d.Price < 6000000 ");
                    break;
                case "p4":
                    sql.append("AND d.Price >= 6000000 ");
                    break;
            }
        }

        if (sort != null) {
            switch (sort) {
                case "priceAsc":
                    sql.append("ORDER BY d.Price ASC ");
                    break;
                case "priceDesc":
                    sql.append("ORDER BY d.Price DESC ");
                    break;
                case "newest":
                    sql.append("ORDER BY p.CreatedAt DESC ");
                    break;
                case "best":
                    sql.append("ORDER BY p.SoldQuantity DESC ");
                    break;
                default:
                    sql.append("ORDER BY p.ProductID DESC ");
            }
        } else {
            sql.append("ORDER BY p.ProductID DESC ");
        }

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int index = 1;

            if (categoryId != null) {
                ps.setInt(index++, categoryId);
            }

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search + "%");
            }

            if (brands != null && brands.length > 0) {
                for (String brand : brands) {
                    ps.setString(index++, brand);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
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
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Product getProductById(int id) {
        Product p = null;
        Connection conn = DBConnect.get();
        if (conn == null)
            return null;

        String sql = "SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice, d.DetailDescription, d.StockQuantity " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE p.ProductID = ? AND d.StockQuantity >= 0";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
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
                p.setDescription(rs.getString("DetailDescription"));
                p.setStock(rs.getInt("StockQuantity"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    public List<Product> getRelatedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null)
            return list;

        String sql = "SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE d.StockQuantity >= 0 " +
                "ORDER BY RAND() LIMIT ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
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
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null)
            return list;

        String sql = "SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE d.StockQuantity >= 0 " +
                "ORDER BY p.SoldQuantity DESC LIMIT ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
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
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategory(int categoryId, int limit) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null)
            return list;

        String sql = "SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "JOIN product_categories pc ON p.ProductID = pc.ProductID " +
                "WHERE pc.CategoryID = ? AND d.StockQuantity >= 0 " +
                "LIMIT ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
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
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> filterAdmin(String search, String brand, String status, String priceRange) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null)
            return list;

        StringBuilder sql = new StringBuilder("SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice, d.StockQuantity " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE d.StockQuantity >= 0 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.ProductName LIKE ? OR p.ProductID = ?) ");
        }

        if (brand != null && !brand.isEmpty()) {
            sql.append("AND p.Brand = ? ");
        }

        if (status != null && !status.isEmpty()) {
            if ("CÃƒÂ²n hÃƒÂ ng".equals(status)) {
                sql.append("AND d.StockQuantity > 0 ");
            } else if ("HÃ¡ÂºÂ¿t hÃƒÂ ng".equals(status)) {
                sql.append("AND d.StockQuantity = 0 ");
            }
        }

        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE;
        if (priceRange != null && !priceRange.isEmpty()) {
            try {
                String[] parts = priceRange.split("-");
                if (parts.length >= 1)
                    minPrice = Double.parseDouble(parts[0]);
                if (parts.length >= 2)
                    maxPrice = Double.parseDouble(parts[1]);
                sql.append("AND d.Price >= ? AND d.Price <= ? ");
            } catch (NumberFormatException e) {

            }
        }

        sql.append("ORDER BY p.ProductID DESC");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                int idTry = -1;
                try {
                    idTry = Integer.parseInt(search.replace("SP", ""));
                } catch (Exception e) {
                }
                ps.setInt(index++, idTry);
            }

            if (brand != null && !brand.isEmpty()) {
                ps.setString(index++, brand);
            }

            if (priceRange != null && !priceRange.isEmpty()) {
                if (minPrice != 0 || maxPrice != Double.MAX_VALUE) {
                    ps.setDouble(index++, minPrice);
                    ps.setDouble(index++, maxPrice);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
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
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addProduct(Product p) {
        Connection conn = DBConnect.get();
        if (conn == null)
            return false;

        String sql1 = "INSERT INTO products (ProductName, Brand, ImageURL, CreatedAt) VALUES (?, ?, ?, NOW())";
        String sql2 = "INSERT INTO productdetails (ProductID, Price, StockQuantity, DetailDescription) VALUES (?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement(sql1, PreparedStatement.RETURN_GENERATED_KEYS);
            ps1.setString(1, p.getName());
            ps1.setString(2, p.getBrand());
            ps1.setString(3, p.getImg());

            int affected = ps1.executeUpdate();
            if (affected > 0) {
                ResultSet rsKey = ps1.getGeneratedKeys();
                if (rsKey.next()) {
                    int productId = rsKey.getInt(1);

                    PreparedStatement ps2 = conn.prepareStatement(sql2);
                    ps2.setInt(1, productId);
                    ps2.setDouble(2, p.getPrice());
                    ps2.setInt(3, p.getStock());
                    ps2.setString(4, p.getDescription());

                    ps2.executeUpdate();

                    conn.commit();
                    return true;
                }
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        Connection conn = DBConnect.get();
        if (conn == null)
            return false;

        String sql1 = "UPDATE products SET ProductName=?, Brand=?, ImageURL=? WHERE ProductID=?";
        String sql2 = "UPDATE productdetails SET Price=?, StockQuantity=?, DetailDescription=? WHERE ProductID=?";

        try {
            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, p.getName());
            ps1.setString(2, p.getBrand());
            ps1.setString(3, p.getImg());
            ps1.setInt(4, p.getId());

            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setDouble(1, p.getPrice());
            ps2.setInt(2, p.getStock());
            ps2.setString(3, p.getDescription());
            ps2.setInt(4, p.getId());

            ps2.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean deleteProduct(int id) {
        Connection conn = DBConnect.get();
        if (conn == null)
            return false;

        String sql = "UPDATE productdetails SET StockQuantity = -1 WHERE ProductID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        Connection conn = DBConnect.get();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

