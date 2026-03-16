package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UserService {
    private static final UserService instance = new UserService();

    public static UserService getInstance() {
        return instance;
    }

    private UserService() {
    }

    public User checkLogin(String username, String password) {
        return new UserDAO().checkLogin(username, hashPassword(password));
    }

    public boolean checkUserExist(String username) {
        return new UserDAO().checkUserExist(username);
    }

    public boolean checkEmailExist(String email) {
        return new UserDAO().checkEmailExist(email);
    }

    public void register(String username, String password, String email) {
        new UserDAO().register(username, hashPassword(password), email);
    }

    public boolean changePassword(int accountID, String oldPassword, String newPassword) {
        UserDAO dao = new UserDAO();

        String currentHashInDB = dao.getPasswordById(accountID);

        String oldPasswordInputHash = hashPassword(oldPassword);

        if (currentHashInDB == null || !currentHashInDB.equals(oldPasswordInputHash)) {
            return false;
        }

        String newPasswordHash = hashPassword(newPassword);

        return dao.changePassword(accountID, newPasswordHash);
    }

    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
