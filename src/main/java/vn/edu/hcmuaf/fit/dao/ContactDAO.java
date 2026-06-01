package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.ContactRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {

    private static final String INSERT =
        "INSERT INTO contact_requests (fullname, phone, email, subject, message, status) " +
        "VALUES (?, ?, ?, ?, ?, 'NEW')";

    private static final String SELECT_ALL =
        "SELECT * FROM contact_requests ORDER BY created_at DESC";

    private static final String UPDATE_STATUS =
        "UPDATE contact_requests SET status = ? WHERE id = ?";

    /** Lưu yêu cầu liên hệ mới. Trả về true nếu thành công. */
    public boolean save(ContactRequest req) {
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            ps.setString(1, req.getFullname());
            ps.setString(2, req.getPhone());
            ps.setString(3, req.getEmail() != null ? req.getEmail() : "");
            ps.setString(4, req.getSubject() != null ? req.getSubject() : "");
            ps.setString(5, req.getMessage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Lấy tất cả yêu cầu (dành cho trang Admin). */
    public List<ContactRequest> findAll() {
        List<ContactRequest> list = new ArrayList<>();
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ContactRequest r = new ContactRequest();
                r.setId(rs.getInt("id"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                ContactRequest full = new ContactRequest(
                    rs.getString("fullname"),
                    rs.getString("phone"),
                    rs.getString("email"),
                    rs.getString("subject"),
                    rs.getString("message")
                );
                full.setId(r.getId());
                full.setStatus(rs.getString("status"));
                full.setCreatedAt(r.getCreatedAt());
                list.add(full);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Cập nhật trạng thái (NEW → READ → REPLIED). */
    public boolean updateStatus(int id, String status) {
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STATUS)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
