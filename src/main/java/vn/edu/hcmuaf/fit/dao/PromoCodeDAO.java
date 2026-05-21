package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.PromoCode;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PromoCodeDAO {

    public boolean create(PromoCode p) {
        String sql = "INSERT INTO promocodes (code,type,amount,start_at,end_at,usage_limit,used_count,active,min_order_value,applies_to,applies_to_id,created_by) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getAmount());
            if (p.getStartAt() != null) ps.setTimestamp(4, new Timestamp(p.getStartAt().getTime())); else ps.setNull(4, Types.TIMESTAMP);
            if (p.getEndAt() != null) ps.setTimestamp(5, new Timestamp(p.getEndAt().getTime())); else ps.setNull(5, Types.TIMESTAMP);
            ps.setInt(6, p.getUsageLimit());
            ps.setInt(7, p.getUsedCount());
            ps.setBoolean(8, p.isActive());
            ps.setDouble(9, p.getMinOrderValue());
            ps.setString(10, p.getAppliesTo());
            if (p.getAppliesToId() != null) ps.setInt(11, p.getAppliesToId()); else ps.setNull(11, Types.INTEGER);
            if (p.getCreatedBy() != null) ps.setInt(12, p.getCreatedBy()); else ps.setNull(12, Types.INTEGER);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) p.setId(rs.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(PromoCode p) {
        String sql = "UPDATE promocodes SET code=?,type=?,amount=?,start_at=?,end_at=?,usage_limit=?,used_count=?,active=?,min_order_value=?,applies_to=?,applies_to_id=? WHERE id=?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getAmount());
            if (p.getStartAt() != null) ps.setTimestamp(4, new Timestamp(p.getStartAt().getTime())); else ps.setNull(4, Types.TIMESTAMP);
            if (p.getEndAt() != null) ps.setTimestamp(5, new Timestamp(p.getEndAt().getTime())); else ps.setNull(5, Types.TIMESTAMP);
            ps.setInt(6, p.getUsageLimit());
            ps.setInt(7, p.getUsedCount());
            ps.setBoolean(8, p.isActive());
            ps.setDouble(9, p.getMinOrderValue());
            ps.setString(10, p.getAppliesTo());
            if (p.getAppliesToId() != null) ps.setInt(11, p.getAppliesToId()); else ps.setNull(11, Types.INTEGER);
            ps.setInt(12, p.getId());

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public PromoCode getById(int id) {
        String sql = "SELECT * FROM promocodes WHERE id = ?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public PromoCode findByCode(String code) {
        String sql = "SELECT * FROM promocodes WHERE code = ?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PromoCode> list(int offset, int limit) {
        List<PromoCode> list = new ArrayList<>();
        String sql = "SELECT * FROM promocodes ORDER BY id DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM promocodes";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM promocodes WHERE id = ?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean incrementUsedCount(int id) {
        String sql = "UPDATE promocodes SET used_count = used_count + 1 WHERE id = ?";
        try (Connection conn = DBConnect.get()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private PromoCode mapRow(ResultSet rs) throws SQLException {
        PromoCode p = new PromoCode();
        p.setId(rs.getInt("id"));
        p.setCode(rs.getString("code"));
        p.setType(rs.getString("type"));
        p.setAmount(rs.getDouble("amount"));
        Timestamp t = rs.getTimestamp("start_at"); if (t != null) p.setStartAt(new Date(t.getTime()));
        Timestamp t2 = rs.getTimestamp("end_at"); if (t2 != null) p.setEndAt(new Date(t2.getTime()));
        p.setUsageLimit(rs.getInt("usage_limit"));
        p.setUsedCount(rs.getInt("used_count"));
        p.setActive(rs.getBoolean("active"));
        p.setMinOrderValue(rs.getDouble("min_order_value"));
        p.setAppliesTo(rs.getString("applies_to"));
        int aid = rs.getInt("applies_to_id"); if (!rs.wasNull()) p.setAppliesToId(aid);
        int cb = rs.getInt("created_by"); if (!rs.wasNull()) p.setCreatedBy(cb);
        return p;
    }
}
