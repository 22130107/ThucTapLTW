package vn.edu.hcmuaf.fit.model;

import java.io.Serializable;

public class Product implements Serializable {
    private int id;
    private String name;
    private String brand;
    private String img;
    private double price;
    private double oldPrice;
    private double rating;
    private int reviews;
    private String badge;
    private boolean installment;
    private int sold;
    private String description;
    private int stock;

    public Product() {
    }

    public Product(int id, String name, String brand, String img, double price, double oldPrice, double rating,
            int reviews, String badge, boolean installment, int sold) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.img = img;
        this.price = price;
        this.oldPrice = oldPrice;
        this.rating = rating;
        this.reviews = reviews;
        this.badge = badge;
        this.installment = installment;
        this.sold = sold;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getOldPrice() {
        return oldPrice;
    }

    public void setOldPrice(double oldPrice) {
        this.oldPrice = oldPrice;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getReviews() {
        return reviews;
    }

    public void setReviews(int reviews) {
        this.reviews = reviews;
    }

    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public boolean isInstallment() {
        return installment;
    }

    public void setInstallment(boolean installment) {
        this.installment = installment;
    }

    public int getSold() {
        return sold;
    }

    public void setSold(int sold) {
        this.sold = sold;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }
}
