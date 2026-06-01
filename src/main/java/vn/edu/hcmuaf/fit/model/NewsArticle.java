package vn.edu.hcmuaf.fit.model;

public class NewsArticle {
    private int id;
    private String title;
    private String excerpt;
    private String contentFragment; // JSP fragment path e.g. /News/content/article-1.jsp
    private String imageUrl;
    private String date;
    private String category;
    private String categoryLabel;
    private String badgeType;
    private String badgeLabel;
    private String[] tags;
    private int views;
    private boolean featured;

    public NewsArticle() {}

    public NewsArticle(int id, String title, String excerpt, String contentFragment,
                       String imageUrl, String date, String category, String categoryLabel,
                       String badgeType, String badgeLabel, String[] tags, int views, boolean featured) {
        this.id = id; this.title = title; this.excerpt = excerpt;
        this.contentFragment = contentFragment;
        this.imageUrl = imageUrl; this.date = date; this.category = category;
        this.categoryLabel = categoryLabel; this.badgeType = badgeType; this.badgeLabel = badgeLabel;
        this.tags = tags; this.views = views; this.featured = featured;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getExcerpt() { return excerpt; }
    public String getContentFragment() { return contentFragment; }
    public String getImageUrl() { return imageUrl; }
    public String getDate() { return date; }
    public String getCategory() { return category; }
    public String getCategoryLabel() { return categoryLabel; }
    public String getBadgeType() { return badgeType; }
    public String getBadgeLabel() { return badgeLabel; }
    public String[] getTags() { return tags; }
    public int getViews() { return views; }
    public boolean isFeatured() { return featured; }
    public String getSlug() { return "bai-viet-" + id; }
}
