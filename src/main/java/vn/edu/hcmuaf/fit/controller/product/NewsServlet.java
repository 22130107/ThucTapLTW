package vn.edu.hcmuaf.fit.controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.model.Category;
import vn.edu.hcmuaf.fit.model.NewsArticle;
import vn.edu.hcmuaf.fit.service.CategoryService;
import vn.edu.hcmuaf.fit.service.NewsService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "NewsServlet", value = "/news")
public class NewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Params ---
        String catParam  = request.getParameter("cat");
        String pageParam = request.getParameter("page");
        if (catParam  == null) catParam  = "all";
        int page = 1;
        try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        NewsService ns = NewsService.getInstance();
        int totalPages = ns.getTotalPages(catParam);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<NewsArticle> articles      = ns.getPage(page, catParam);
        List<NewsArticle> featured      = ns.getFeatured();
        Map<String, Integer> catCounts  = ns.getCategoryCounts();
        List<Category>      categories  = CategoryService.getInstance().getAll();

        request.setAttribute("articles",    articles);
        request.setAttribute("featured",    featured);
        request.setAttribute("catCounts",   catCounts);
        request.setAttribute("categories",  categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("currentCat",  catParam);
        request.setAttribute("totalCount",  ns.getTotalCount(catParam));

        request.getRequestDispatcher("/News/news.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { doGet(request, response); }
}
