package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class UserDAO {

    public User getUserByUsername(String username) {
        String query = "SELECT * FROM accounts WHERE Username = ? AND Status = 'Active'";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("AccountID"),
                            rs.getString("Username"),
                            rs.getString("PasswordHash"),
                            rs.getString("Email"),
                            rs.getString("Role"),
                            rs.getString("Status"),
                            rs.getTimestamp("CreatedAt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkUserExist(String username) {
        String query = "SELECT AccountID FROM accounts WHERE Username = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmailExist(String email) {
        String query = "SELECT AccountID FROM accounts WHERE Email = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Register new user account and associated customer record
    public void register(String username, String password, String email) {
        String queryAccount = "INSERT INTO accounts (Username, PasswordHash, Email, Role, Status) VALUES (?, ?, ?, 'Customer', 'Active')";
        String queryCustomer = "INSERT INTO customers (AccountID) VALUES (?)";
        try (Connection conn = DBConnect.get()) {
            int accountID = -1;
            try (PreparedStatement ps = conn.prepareStatement(queryAccount, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, email);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        accountID = rs.getInt(1);
                    }
                }
            }

            if (accountID != -1) {
                try (PreparedStatement psCustomer = conn.prepareStatement(queryCustomer)) {
                    psCustomer.setInt(1, accountID);
                    psCustomer.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getCustomerIdByAccountId(int accountId) {
        String query = "SELECT CustomerID FROM customers WHERE AccountID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CustomerID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public String getPasswordById(int accountID) {
        String query = "SELECT PasswordHash FROM accounts WHERE AccountID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("PasswordHash");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean changePassword(int accountID, String newPasswordHash) {
        String query = "UPDATE accounts SET PasswordHash = ? WHERE AccountID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByEmail(String email) {
        String query = "SELECT * FROM accounts WHERE Email = ? AND Status = 'Active'";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("AccountID"),
                            rs.getString("Username"),
                            rs.getString("PasswordHash"),
                            rs.getString("Email"),
                            rs.getString("Role"),
                            rs.getString("Status"),
                            rs.getTimestamp("CreatedAt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void registerGoogle(String email, String name, String avatarUrl) {
        String username = email.split("@")[0];
        String randomPass = vn.edu.hcmuaf.fit.service.UserService.getInstance().hashPassword(
                "GOOGLE_LOGIN_" + System.currentTimeMillis());
        register(username, randomPass, email);
    }
}
