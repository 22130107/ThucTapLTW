package vn.edu.hcmuaf.fit.model;

import vn.edu.hcmuaf.fit.service.ProductService;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> data = new HashMap<>();

    public void add(int productId, int quantity) {
        if (data.containsKey(productId)) {
            CartItem item = data.get(productId);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            Product product = ProductService.getInstance().getProductById(productId);
            if (product != null) {
                data.put(productId, new CartItem(product, quantity));
            }
        }
    }

    public void update(int productId, int quantity) {
        if (quantity <= 0) {
            data.remove(productId);
        } else if (data.containsKey(productId)) {
            data.get(productId).setQuantity(quantity);
        }
    }

    public void remove(int productId) {
        data.remove(productId);
    }

    public Map<Integer, CartItem> getData() {
        return data;
    }

    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : data.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : data.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }
}
