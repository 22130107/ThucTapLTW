package vn.edu.hcmuaf.fit.model;

import java.io.Serializable;

public class Category implements Serializable {
    private int categoryID;
    private String categoryName;
    private String description;
    private int displayOrder;
    private String image;

    public Category() {
    }

    public Category(int categoryID, String categoryName, String description, int displayOrder, String image) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
        this.displayOrder = displayOrder;
        this.image = image;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getSlug() {
        if (categoryName == null) return "";
        String slug = java.text.Normalizer.normalize(categoryName.toLowerCase(), java.text.Normalizer.Form.NFD)
                .replaceAll("[\\u0300-\\u036f]", "")
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");
        return slug;
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryID=" + categoryID +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                ", displayOrder=" + displayOrder +
                ", image='" + image + '\'' +
                '}';
    }
}
