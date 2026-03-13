package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.db.DBConnect;
import vn.edu.hcmuaf.fit.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CustomerDAO {

    public List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();
        String query = "SELECT * FROM customers";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Customer(
                        rs.getInt("CustomerID"),
                        rs.getInt("AccountID"),
                        rs.getString("FullName"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Customer getById(int id) {
        String query = "SELECT * FROM customers WHERE CustomerID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("CustomerID"),
                            rs.getInt("AccountID"),
                            rs.getString("FullName"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Address"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public boolean updateCustomerInfo(int accountId, String fullName, String phone, String address) {
        String query = "UPDATE customers SET FullName = ?, PhoneNumber = ?, Address = ? WHERE AccountID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setInt(4, accountId);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public Customer getCustomerByAccountId(int accountId) {
        String query = "SELECT CustomerID, AccountID, FullName, PhoneNumber, Address FROM customers WHERE AccountID = ?";
        try (Connection conn = DBConnect.get();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("CustomerID"),
                            rs.getInt("AccountID"),
                            rs.getString("FullName"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Address"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
