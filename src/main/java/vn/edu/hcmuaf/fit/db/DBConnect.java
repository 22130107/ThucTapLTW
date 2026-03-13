package vn.edu.hcmuaf.fit.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    private static final String URL  = "jdbc:mysql://localhost:3306/dataweb?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASS = "12345";

    public static Connection get() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("LOG: Database Connection Failed!");
            System.err.println("LOG: URL used: " + URL);
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        Connection conn = get();
        if (conn != null) {
            System.out.println("Kết nối thành công!");
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Kết nối thất bại!");
        }
    }
}
