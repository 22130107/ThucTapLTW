package vn.edu.hcmuaf.fit.controller.product;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CategoryServlet", value = "/api/categories")
public class CategoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = CategoryService.getInstance().getAll();
        String json = new Gson().toJson(categories);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}
