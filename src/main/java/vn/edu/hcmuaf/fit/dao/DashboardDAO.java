package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {
    private static volatile DashboardDAO instance;

    public static DashboardDAO getInstance() {
        if (instance == null) {
            synchronized (DashboardDAO.class) {
                if (instance == null) {
                    instance = new DashboardDAO();
                }
            }
        }
        return instance;
    }

    /**
     * Lấy doanh thu của 6 tháng gần nhất có phát sinh đơn hàng.
     * Trả về mảng 2 phần tử: [Tên tháng (Tháng MM/YYYY), Doanh thu]
     */
    public List<String[]> getMonthlyRevenueLast6Months() {
        List<String[]> data = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(OrderDate, 'Tháng %m/%Y') as MonthYear, SUM(TotalAmount) as Revenue " +
                     "FROM orders " +
                     "WHERE Status != 'Cancelled' " +
                     "GROUP BY DATE_FORMAT(OrderDate, '%Y-%m'), MonthYear " +
                     "ORDER BY DATE_FORMAT(OrderDate, '%Y-%m') ASC " +
                     "LIMIT 6";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(new String[]{rs.getString("MonthYear"), String.valueOf(rs.getDouble("Revenue"))});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    /**
     * Lấy số lượng sản phẩm theo từng danh mục.
     * Trả về mảng 2 phần tử: [Tên danh mục, Số lượng sản phẩm]
     */
    public List<String[]> getProductsCountByCategory() {
        List<String[]> data = new ArrayList<>();
        String sql = "SELECT c.CategoryName, COUNT(pc.ProductID) as ProductCount " +
                     "FROM categories c " +
                     "LEFT JOIN product_categories pc ON c.CategoryID = pc.CategoryID " +
                     "GROUP BY c.CategoryID, c.CategoryName " +
                     "ORDER BY ProductCount DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(new String[]{rs.getString("CategoryName"), String.valueOf(rs.getInt("ProductCount"))});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    /**
     * Lấy thống kê số lượng lịch hẹn theo trạng thái (New, Confirmed, Completed, Cancelled).
     * Trả về mảng 2 phần tử: [Trạng thái, Số lượng]
     */
    public List<String[]> getAppointmentsCountByStatus() {
        List<String[]> data = new ArrayList<>();
        String sql = "SELECT Status, COUNT(*) as StatusCount " +
                     "FROM appointments " +
                     "GROUP BY Status";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.add(new String[]{rs.getString("Status"), String.valueOf(rs.getInt("StatusCount"))});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }
}
