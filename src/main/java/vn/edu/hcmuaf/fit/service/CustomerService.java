package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.CustomerDAO;
import vn.edu.hcmuaf.fit.model.Customer;

public class CustomerService {
    private static final CustomerService instance = new CustomerService();

    public static CustomerService getInstance() {
        return instance;
    }

    private CustomerService() {
    }

    public boolean updateCustomerInfo(int accountId, String fullName, String phone, String address) {

        return new CustomerDAO().updateCustomerInfo(accountId, fullName, phone, address);
    }

    public Customer getCustomerByAccountId(int accountId) {
        return new CustomerDAO().getCustomerByAccountId(accountId);
    }
}