package vn.edu.hcmuaf.fit.controller.cart;

import com.google.gson.Gson;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AddToCartServlet", value = "/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String quantityParam = request.getParameter("quantity");

        Map<String, Object> jsonResponse = new HashMap<>();

        try {
            int id = Integer.parseInt(idParam);
            int quantity = Integer.parseInt(quantityParam);

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("auth");

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            String action = request.getParameter("action");
            if (action == null) {
                action = "add";
            }

            if (user != null) {

                int customerId = new vn.edu.hcmuaf.fit.dao.UserDAO().getCustomerIdByAccountId(user.getAccountID());

                if (action.equals("add")) {
                    CartService.getInstance().addToCart(customerId, id, quantity);
                } else if (action.equals("update")) {
                    CartService.getInstance().updateCart(customerId, id, quantity);
                } else if (action.equals("delete")) {
                    CartService.getInstance().removeProduct(customerId, id);
                }

                cart = CartService.getInstance().getCart(customerId);
                session.setAttribute("cart", cart);
            } else {

                if (action.equals("add")) {
                    cart.add(id, quantity);
                } else if (action.equals("update")) {
                    cart.update(id, quantity);
                } else if (action.equals("delete")) {
                    cart.remove(id);
                }
                session.setAttribute("cart", cart);
                vn.edu.hcmuaf.fit.util.CartCookieUtil.saveCartToCookie(response, cart);
            }

            jsonResponse.put("status", "success");
            jsonResponse.put("totalQuantity", cart.getTotalQuantity());
            jsonResponse.put("totalPrice", cart.getTotalPrice());
            jsonResponse.put("cartItems", cart.getData().values());
            jsonResponse.put("message", "Cart updated successfully");

        } catch (NumberFormatException e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Invalid product ID or quantity");
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
        }

        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}
