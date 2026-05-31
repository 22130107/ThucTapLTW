package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.util.HtmlSanitizer;

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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public List<Product> getAdminProducts(String search, String brand, String status, String priceRange, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        Connection conn = DBConnect.get();
        if (conn == null) return list;

        StringBuilder sql = new StringBuilder("SELECT p.ProductID, p.ProductName, p.Brand, p.ImageURL, " +
                "p.Rating, p.ReviewCount, p.Badge, p.IsInstallment, p.SoldQuantity, " +
                "d.Price, d.OldPrice, d.StockQuantity " +
                "FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE d.StockQuantity >= 0 ");

        appendAdminFilterSql(sql, search, brand, status, priceRange);
        sql.append("ORDER BY p.ProductID DESC ");
        sql.append("LIMIT ? OFFSET ?");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int index = setAdminFilterParameters(ps, search, brand, status, priceRange);
            if (limit <= 0) limit = 15;
            if (offset < 0) offset = 0;
            ps.setInt(index++, limit);
            ps.setInt(index, offset);

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
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public int countProductsAdmin(String search, String brand, String status, String priceRange) {
        int total = 0;
        Connection conn = DBConnect.get();
        if (conn == null) return total;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products p " +
                "JOIN productdetails d ON p.ProductID = d.ProductID " +
                "WHERE d.StockQuantity >= 0 ");

        appendAdminFilterSql(sql, search, brand, status, priceRange);

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            setAdminFilterParameters(ps, search, brand, status, priceRange);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return total;
    }

    public List<String> getAllBrands() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT Brand FROM products WHERE Brand IS NOT NULL AND Brand != '' ORDER BY Brand";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (conn == null) return brands;
            while (rs.next()) {
                brands.add(rs.getString("Brand"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    public int getProductCategoryId(int productId) {
        String sql = "SELECT CategoryID FROM product_categories WHERE ProductID = ? LIMIT 1";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return 0;
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CategoryID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean addProduct(Product p) {
        String sql1 = "INSERT INTO products (ProductName, Brand, ImageURL, CreatedAt) VALUES (?, ?, ?, NOW())";
        String sql2 = "INSERT INTO productdetails (ProductID, Price, StockQuantity, DetailDescription) VALUES (?, ?, ?, ?)";
        String sql3 = "INSERT INTO product_categories (ProductID, CategoryID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnect.get();
            if (conn == null) return false;
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
                    ps2.setString(4, HtmlSanitizer.sanitize(p.getDescription()));
                    ps2.executeUpdate();

                    if (p.getCategoryId() > 0) {
                        PreparedStatement ps3 = conn.prepareStatement(sql3);
                        ps3.setInt(1, productId);
                        ps3.setInt(2, p.getCategoryId());
                        ps3.executeUpdate();
                    }

                    conn.commit();
                    return true;
                }
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql1 = "UPDATE products SET ProductName=?, Brand=?, ImageURL=? WHERE ProductID=?";
        String sql2 = "UPDATE productdetails SET Price=?, StockQuantity=?, DetailDescription=? WHERE ProductID=?";
        String sql3Del = "DELETE FROM product_categories WHERE ProductID=?";
        String sql3Ins = "INSERT INTO product_categories (ProductID, CategoryID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnect.get();
            if (conn == null) return false;
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
            ps2.setString(3, HtmlSanitizer.sanitize(p.getDescription()));
            ps2.setInt(4, p.getId());
            ps2.executeUpdate();

            PreparedStatement ps3Del = conn.prepareStatement(sql3Del);
            ps3Del.setInt(1, p.getId());
            ps3Del.executeUpdate();

            if (p.getCategoryId() > 0) {
                PreparedStatement ps3Ins = conn.prepareStatement(sql3Ins);
                ps3Ins.setInt(1, p.getId());
                ps3Ins.setInt(2, p.getCategoryId());
                ps3Ins.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public boolean deleteProduct(int id) {
        String sql = "UPDATE productdetails SET StockQuantity = -1 WHERE ProductID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn == null) return false;
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean bulkDeleteProducts(java.util.List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return false;

        StringBuilder sql = new StringBuilder("UPDATE productdetails SET StockQuantity = -1 WHERE ProductID IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ", ?");
        }
        sql.append(")");

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (conn == null) return false;
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (conn == null) return 0;
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void appendAdminFilterSql(StringBuilder sql, String search, String brand, String status, String priceRange) {
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.ProductName LIKE ? OR p.ProductID = ?) ");
        }

        if (brand != null && !brand.isEmpty()) {
            sql.append("AND p.Brand = ? ");
        }

        if (status != null && !status.isEmpty()) {
            if ("Còn hàng".equals(status)) {
                sql.append("AND d.StockQuantity > 0 ");
            } else if ("Hết hàng".equals(status)) {
                sql.append("AND d.StockQuantity = 0 ");
            }
        }

        if (priceRange != null && !priceRange.isEmpty()) {
            try {
                String[] parts = priceRange.split("-");
                if (parts.length >= 1 && !parts[0].isEmpty()) Double.parseDouble(parts[0]);
                if (parts.length >= 2 && !parts[1].isEmpty()) Double.parseDouble(parts[1]);
                sql.append("AND d.Price >= ? AND d.Price <= ? ");
            } catch (NumberFormatException e) {
            }
        }
    }

    private int setAdminFilterParameters(PreparedStatement ps, String search, String brand, String status, String priceRange) throws SQLException {
        int index = 1;

        if (search != null && !search.trim().isEmpty()) {
            ps.setString(index++, "%" + search + "%");
            int idTry = -1;
            try { idTry = Integer.parseInt(search.replace("SP", "")); } catch (Exception e) {}
            ps.setInt(index++, idTry);
        }

        if (brand != null && !brand.isEmpty()) {
            ps.setString(index++, brand);
        }

        if (priceRange != null && !priceRange.isEmpty()) {
            try {
                String[] parts = priceRange.split("-");
                double minPrice = 0;
                double maxPrice = Double.MAX_VALUE;
                if (parts.length >= 1 && !parts[0].isEmpty()) minPrice = Double.parseDouble(parts[0]);
                if (parts.length >= 2 && !parts[1].isEmpty()) maxPrice = Double.parseDouble(parts[1]);
                ps.setDouble(index++, minPrice);
                ps.setDouble(index++, maxPrice);
            } catch (NumberFormatException e) {
            }
        }

        return index;
    }
}
