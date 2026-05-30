package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.model.Category;

import java.util.List;

public class CategoryService {
    private static final CategoryService instance = new CategoryService();

    private CategoryService() {}

    public static CategoryService getInstance() { return instance; }

    public List<Category> getAll() { return CategoryDAO.getInstance().getAll(); }

    public Category getById(int id) { return CategoryDAO.getInstance().getById(id); }

    public boolean add(Category c) { return CategoryDAO.getInstance().insert(c); }

    public boolean update(Category c) { return CategoryDAO.getInstance().update(c); }

    public boolean delete(int id) { return CategoryDAO.getInstance().delete(id); }
}
