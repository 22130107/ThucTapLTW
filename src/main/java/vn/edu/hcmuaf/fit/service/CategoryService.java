package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.model.Category;

import java.util.List;

public class CategoryService {
    private static final CategoryService instance = new CategoryService();

    private CategoryService() {
    }

    public static CategoryService getInstance() {
        return instance;
    }

    public List<Category> getAll() {
        return CategoryDAO.getInstance().getAll();
    }

    public Category getById(int id) {
        return CategoryDAO.getInstance().getById(id);
    }
}
