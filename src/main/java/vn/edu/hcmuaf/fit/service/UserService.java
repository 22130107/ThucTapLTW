package vn.edu.hcmuaf.fit.service;

import at.favre.lib.crypto.bcrypt.BCrypt;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;

public class UserService {
    private static final UserService instance = new UserService();

    public static UserService getInstance() {
        return instance;
    }

    private UserService() {
    }

    public User checkLogin(String username, String password) {
        UserDAO dao = new UserDAO();
        User user = dao.getUserByUsername(username);
        if (user == null) return null;

        boolean matched = BCrypt.verifyer()
                .verify(password.toCharArray(), user.getPasswordHash())
                .verified;
        return matched ? user : null;
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

        if (currentHashInDB == null) return false;

        boolean oldPasswordMatches = BCrypt.verifyer()
                .verify(oldPassword.toCharArray(), currentHashInDB)
                .verified;

        if (!oldPasswordMatches) return false;

        return dao.changePassword(accountID, hashPassword(newPassword));
    }

    public String hashPassword(String password) {
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }
}
