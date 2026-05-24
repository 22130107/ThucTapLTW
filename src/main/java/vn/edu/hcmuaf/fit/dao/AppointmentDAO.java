package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Appointment;
import vn.edu.hcmuaf.fit.model.Appointment.AppointmentStatus;
import vn.edu.hcmuaf.fit.model.Appointment.AppointmentType;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    private static volatile AppointmentDAO instance;

    public static AppointmentDAO getInstance() {
        if (instance == null) {
            synchronized (AppointmentDAO.class) {
                if (instance == null) {
                    instance = new AppointmentDAO();
                }
            }
        }
        return instance;
    }

    public List<Appointment> getAll() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, c.FullName, c.PhoneNumber, p.ProductName " +
                     "FROM appointments a " +
                     "LEFT JOIN customers c ON a.CustomerID = c.CustomerID " +
                     "LEFT JOIN products p ON a.ProductID = p.ProductID " +
                     "ORDER BY a.AppointmentDateTime DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> filter(String keyword, String type, String status, String dateFrom, String dateTo) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, c.FullName, c.PhoneNumber, p.ProductName " +
                "FROM appointments a " +
                "LEFT JOIN customers c ON a.CustomerID = c.CustomerID " +
                "LEFT JOIN products p ON a.ProductID = p.ProductID " +
                "WHERE 1=1"
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.FullName LIKE ? OR c.PhoneNumber LIKE ? OR a.AppointmentID = ?)");
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.AppointmentType = ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.Status = ?");
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND a.AppointmentDateTime >= ?");
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND a.AppointmentDateTime <= ?");
        }

        sql.append(" ORDER BY a.AppointmentDateTime DESC");

        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                int idVal = -1;
                try {
                    idVal = Integer.parseInt(keyword.trim().replaceAll("[^0-9]", ""));
                } catch (NumberFormatException ignored) {}
                ps.setInt(idx++, idVal);
            }
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(idx++, type.trim());
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.trim());
            }
            if (dateFrom != null && !dateFrom.trim().isEmpty()) {
                ps.setString(idx++, dateFrom.trim() + " 00:00:00");
            }
            if (dateTo != null && !dateTo.trim().isEmpty()) {
                ps.setString(idx++, dateTo.trim() + " 23:59:59");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTotalToday() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE DATE(AppointmentDateTime) = CURDATE()";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countNewToday() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE DATE(AppointmentDateTime) = CURDATE() AND Status = 'New'";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countConfirmedTotal() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE Status = 'Confirmed'";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM appointments";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateStatus(int appointmentId, String newStatus) {
        String sql = "UPDATE appointments SET Status = ? WHERE AppointmentID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentID(rs.getInt("AppointmentID"));
        a.setCustomerID(rs.getInt("CustomerID"));
        int prodId = rs.getInt("ProductID");
        if (!rs.wasNull()) {
            a.setProductID(prodId);
        }
        Timestamp ts = rs.getTimestamp("AppointmentDateTime");
        if (ts != null) {
            a.setAppointmentDateTime(ts.toLocalDateTime());
        }
        a.setAppointmentType(AppointmentType.fromString(rs.getString("AppointmentType")));
        a.setAddress(rs.getString("Address"));
        a.setStatus(AppointmentStatus.fromString(rs.getString("Status")));
        a.setAdminNote(rs.getString("AdminNote"));

        // Transient fields
        a.setCustomerName(rs.getString("FullName"));
        a.setCustomerPhone(rs.getString("PhoneNumber"));
        a.setProductName(rs.getString("ProductName"));
        return a;
    }
}
