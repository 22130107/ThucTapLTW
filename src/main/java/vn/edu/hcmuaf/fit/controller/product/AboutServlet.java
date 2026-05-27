package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AboutServlet", value = "/about")
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load categories for the header sidebar
        List<Category> categories = CategoryService.getInstance().getAll();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/About/about.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
