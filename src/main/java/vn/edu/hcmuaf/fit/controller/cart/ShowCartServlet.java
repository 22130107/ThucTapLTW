package vn.edu.hcmuaf.fit.controller.cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.service.CartService;

import java.io.IOException;

@WebServlet(name = "ShowCartServlet", value = "/cart")
public class ShowCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int customerId = new vn.edu.hcmuaf.fit.dao.UserDAO().getCustomerIdByAccountId(user.getAccountID());
        if (customerId == -1) {

            response.sendRedirect("login");
            return;
        }

        Cart cart = CartService.getInstance().getCart(customerId);
        session.setAttribute("cart", cart);

        request.getRequestDispatcher("/Cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
