package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.PaymentTransaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentTransactionDAO {
    private static final Logger LOGGER = Logger.getLogger(PaymentTransactionDAO.class.getName());
    private static volatile PaymentTransactionDAO instance;

    public static PaymentTransactionDAO getInstance() {
        if (instance == null) {
            synchronized (PaymentTransactionDAO.class) {
                if (instance == null) instance = new PaymentTransactionDAO();
            }
        }
        return instance;
    }

    public int save(PaymentTransaction tx) {
        String sql = "INSERT INTO payment_transactions " +
                "(order_id, txn_ref, vnp_transaction_no, amount, bank_code, pay_date, " +
                " response_code, transaction_status, order_info, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, tx.getOrderId());
            ps.setString(2, tx.getTxnRef());
            ps.setString(3, tx.getVnpTransactionNo());
            ps.setLong(4, tx.getAmount());
            ps.setString(5, tx.getBankCode());
            ps.setString(6, tx.getPayDate());
            ps.setString(7, tx.getResponseCode());
            ps.setString(8, tx.getTransactionStatus());
            ps.setString(9, tx.getOrderInfo());
            ps.setString(10, tx.getStatus());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[PaymentTransactionDAO] save failed: " + e.getMessage(), e);
        }
        return -1;
    }

    public PaymentTransaction findByTxnRef(String txnRef) {
        String sql = "SELECT * FROM payment_transactions WHERE txn_ref = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, txnRef);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[PaymentTransactionDAO] findByTxnRef failed", e);
        }
        return null;
    }

    public List<PaymentTransaction> findByOrderId(int orderId) {
        List<PaymentTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM payment_transactions WHERE order_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[PaymentTransactionDAO] findByOrderId failed", e);
        }
        return list;
    }

    public PaymentTransaction findSuccessByOrderId(int orderId) {
        String sql = "SELECT * FROM payment_transactions " +
                "WHERE order_id = ? AND status = 'SUCCESS' " +
                "ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[PaymentTransactionDAO] findSuccessByOrderId failed", e);
        }
        return null;
    }

    private PaymentTransaction mapRow(ResultSet rs) throws SQLException {
        PaymentTransaction tx = new PaymentTransaction();
        tx.setId(rs.getInt("id"));
        tx.setOrderId(rs.getInt("order_id"));
        tx.setTxnRef(rs.getString("txn_ref"));
        tx.setVnpTransactionNo(rs.getString("vnp_transaction_no"));
        tx.setAmount(rs.getLong("amount"));
        tx.setBankCode(rs.getString("bank_code"));
        tx.setPayDate(rs.getString("pay_date"));
        tx.setResponseCode(rs.getString("response_code"));
        tx.setTransactionStatus(rs.getString("transaction_status"));
        tx.setOrderInfo(rs.getString("order_info"));
        tx.setStatus(rs.getString("status"));
        tx.setCreatedAt(rs.getTimestamp("created_at"));
        return tx;
    }
}