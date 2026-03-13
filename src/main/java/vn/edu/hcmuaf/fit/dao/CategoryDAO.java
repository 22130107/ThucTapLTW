package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private static CategoryDAO instance;

    private CategoryDAO() {
    }

    public static CategoryDAO getInstance() {
        if (instance == null) {
            instance = new CategoryDAO();
        }
        return instance;
    }

    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, Description, DisplayOrder, Image FROM categories ORDER BY DisplayOrder ASC";

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryID(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setDescription(rs.getString("Description"));
                c.setDisplayOrder(rs.getInt("DisplayOrder"));
                c.setImage(rs.getString("Image"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getById(int id) {
        Category c = null;
        String sql = "SELECT CategoryID, CategoryName, Description, DisplayOrder, Image FROM categories WHERE CategoryID = ?";

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new Category();
                    c.setCategoryID(rs.getInt("CategoryID"));
                    c.setCategoryName(rs.getString("CategoryName"));
                    c.setDescription(rs.getString("Description"));
                    c.setDisplayOrder(rs.getInt("DisplayOrder"));
                    c.setImage(rs.getString("Image"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return c;
    }
}
