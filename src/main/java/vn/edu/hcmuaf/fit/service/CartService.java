package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.model.Cart;
import vn.edu.hcmuaf.fit.model.Product;

public class CartService {
    private static final CartService instance = new CartService();

    private CartService() {
    }

    public static CartService getInstance() {
        return instance;
    }

    public Cart getCart(int customerId) {
        return CartDAO.getInstance().getCartByCustomerId(customerId);
    }

    public void addToCart(int customerId, int productId, int quantity) {
        CartDAO dao = CartDAO.getInstance();
        int cartId = dao.getCartId(customerId);
        if (cartId == -1) {
            cartId = dao.createCart(customerId);
        }

        Product product = ProductService.getInstance().getProductById(productId);
        if (product != null) {
            dao.addItem(cartId, productId, quantity, product.getPrice());
        }
    }

    public void updateCart(int customerId, int productId, int quantity) {
        CartDAO dao = CartDAO.getInstance();
        int cartId = dao.getCartId(customerId);
        if (cartId != -1) {
            if (quantity <= 0) {
                dao.removeItem(cartId, productId);
            } else {
                dao.updateItemQuantity(cartId, productId, quantity);
            }
        }
    }

    public void removeProduct(int customerId, int productId) {
        CartDAO dao = CartDAO.getInstance();
        int cartId = dao.getCartId(customerId);
        if (cartId != -1) {
            dao.removeItem(cartId, productId);
        }
    }

    public void clearCart(int customerId) {
        CartDAO dao = CartDAO.getInstance();
        int cartId = dao.getCartId(customerId);
        if (cartId != -1) {
            dao.clearCart(cartId);
        }
    }
}
