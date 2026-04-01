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