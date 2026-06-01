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

@WebServlet(name = "NewsDetailServlet", value = "/news-detail")
public class NewsDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idParam); } catch (Exception ignored) {}

        NewsService ns = NewsService.getInstance();
        NewsArticle article = ns.getById(id);

        if (article == null) {
            response.sendRedirect(request.getContextPath() + "/news");
            return;
        }

        List<NewsArticle> featured     = ns.getFeatured();
        Map<String, Integer> catCounts = ns.getCategoryCounts();
        List<Category> categories      = CategoryService.getInstance().getAll();

        // Related: same category, exclude current
        List<NewsArticle> related = ns.getPage(1, article.getCategory())
                .stream()
                .filter(a -> a.getId() != article.getId())
                .limit(3)
                .collect(java.util.stream.Collectors.toList());

        request.setAttribute("article",    article);
        request.setAttribute("featured",   featured);
        request.setAttribute("catCounts",  catCounts);
        request.setAttribute("categories", categories);
        request.setAttribute("related",    related);

        request.getRequestDispatcher("/News/news-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { doGet(request, response); }
}
