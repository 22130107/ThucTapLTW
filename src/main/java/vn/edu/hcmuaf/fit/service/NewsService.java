package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.model.NewsArticle;
import java.util.*;
import java.util.stream.Collectors;

public class NewsService {

    private static final NewsService INSTANCE = new NewsService();
    public static NewsService getInstance() { return INSTANCE; }

    private final List<NewsArticle> ALL = new ArrayList<>();
    public static final int PAGE_SIZE = 6;

    private static final String FRAG_DEFAULT = "/News/content/article-default.jsp";

    private NewsService() { initData(); }

    public List<NewsArticle> getPage(int page, String cat) {
        List<NewsArticle> src = filter(cat);
        int from = (page - 1) * PAGE_SIZE;
        if (from >= src.size()) return Collections.emptyList();
        return src.subList(from, Math.min(from + PAGE_SIZE, src.size()));
    }

    public int getTotalPages(String cat) {
        return (int) Math.ceil((double) filter(cat).size() / PAGE_SIZE);
    }

    public int getTotalCount(String cat) { return filter(cat).size(); }

    public List<NewsArticle> getFeatured() {
        return ALL.stream().filter(NewsArticle::isFeatured)
                .sorted(Comparator.comparingInt(NewsArticle::getViews).reversed())
                .limit(5).collect(Collectors.toList());
    }

    public NewsArticle getById(int id) {
        return ALL.stream().filter(a -> a.getId() == id).findFirst().orElse(null);
    }

    public Map<String, Integer> getCategoryCounts() {
        Map<String, Integer> m = new LinkedHashMap<>();
        String[] cats = {"meo-suc-khoe","huong-dan","tin-y-te","canh-bao","khuyen-nghi","tre-em"};
        for (String c : cats)
            m.put(c, (int) ALL.stream().filter(a -> a.getCategory().equals(c)).count());
        return m;
    }

    private List<NewsArticle> filter(String cat) {
        if (cat == null || cat.isEmpty() || cat.equals("all")) return new ArrayList<>(ALL);
        return ALL.stream().filter(a -> a.getCategory().equals(cat)).collect(Collectors.toList());
    }

    private String frag(int id) {
        return "/News/content/article-" + id + ".jsp";
    }

    private void initData() {
        ALL.add(new NewsArticle(1,
            "Hướng dẫn sử dụng máy đo huyết áp tại nhà đúng cách",
            "Tư thế ngồi đúng, thời điểm đo lý tưởng và những lưu ý quan trọng giúp kết quả đo huyết áp tại nhà chính xác nhất.",
            frag(1),
            "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80",
            "25/05/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Huyết áp","Máy đo huyết áp","Hướng dẫn"},4821,true));

        ALL.add(new NewsArticle(2,
            "Dấu hiệu sớm của bệnh tăng huyết áp nhiều người bỏ qua",
            "Nhức đầu, chóng mặt, ù tai, mờ mắt… là những triệu chứng thường bị xem nhẹ. Bác sĩ khuyến nghị kiểm tra ngay.",
            frag(2),
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80",
            "20/05/2026","canh-bao","Cảnh báo bệnh mùa","warning","Cảnh báo",
            new String[]{"Huyết áp","Cảnh báo","Bác sĩ"},3560,true));

        ALL.add(new NewsArticle(3,
            "Nên mua máy xông khí dung loại nào cho trẻ nhỏ?",
            "So sánh máy xông khí nén và lưới siêu âm – tiêu chí an toàn, độ ồn, kích thước hạt thuốc phù hợp cho bé.",
            frag(3),
            "https://images.unsplash.com/photo-1584515933487-779824d29309?w=800&q=80",
            "18/05/2026","tre-em","Sức khỏe trẻ em","new","Mới",
            new String[]{"Khí dung","Trẻ em","Mẹo hay"},2147,true));

        ALL.add(new NewsArticle(4,
            "Cách chọn xe lăn phù hợp cho người cao tuổi và người khuyết tật",
            "Tiêu chí trọng lượng, chiều rộng ghế, loại bánh và tính năng gấp gọn giúp bạn chọn đúng xe lăn.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800&q=80",
            "15/05/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Xe lăn","Người cao tuổi"},1893,false));

        ALL.add(new NewsArticle(5,
            "Giường y tế đa năng – giải pháp chăm sóc bệnh nhân tại nhà",
            "Giường y tế điều chỉnh điện giúp người thân chăm sóc bệnh nhân dễ dàng hơn, giảm nguy cơ loét tỳ đè.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800&q=80",
            "12/05/2026","meo-suc-khoe","Mẹo chăm sóc sức khỏe","useful","Hữu ích",
            new String[]{"Giường y tế","Phục hồi"},1650,false));

        ALL.add(new NewsArticle(6,
            "Chỉ số SpO2 bao nhiêu là nguy hiểm? Khi nào cần đến bệnh viện?",
            "SpO2 dưới 94% là dấu hiệu cần theo dõi sát. Bài viết giải thích ý nghĩa từng mức chỉ số.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=800&q=80",
            "10/05/2026","canh-bao","Cảnh báo bệnh mùa","warning","Cảnh báo",
            new String[]{"SpO2","Oxy máu","Cảnh báo"},2904,true));

        ALL.add(new NewsArticle(7,
            "5 thói quen buổi sáng giúp kiểm soát đường huyết hiệu quả",
            "Uống nước ấm, đi bộ nhẹ, ăn sáng đúng giờ – những thói quen đơn giản giúp ổn định đường huyết cả ngày.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80",
            "08/05/2026","meo-suc-khoe","Mẹo chăm sóc sức khỏe","useful","Hữu ích",
            new String[]{"Tiểu đường","Đường huyết","Mẹo hay"},1420,false));

        ALL.add(new NewsArticle(8,
            "Máy đo đường huyết nào chính xác nhất hiện nay?",
            "So sánh top 5 máy đo đường huyết bán chạy nhất: Accu-Chek, OneTouch, Contour – ưu nhược điểm từng loại.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=800&q=80",
            "05/05/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Đường huyết","Máy đo","So sánh"},1180,false));

        ALL.add(new NewsArticle(9,
            "Cảnh báo: Bệnh tay chân miệng tăng mạnh vào mùa hè",
            "Số ca mắc tay chân miệng tăng 40% so với cùng kỳ. Phụ huynh cần nhận biết sớm và phòng ngừa đúng cách.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80",
            "03/05/2026","canh-bao","Cảnh báo bệnh mùa","warning","Cảnh báo",
            new String[]{"Tay chân miệng","Trẻ em","Mùa hè"},2210,false));

        ALL.add(new NewsArticle(10,
            "Bác sĩ khuyến nghị: Nên đo huyết áp mấy lần mỗi ngày?",
            "Theo khuyến nghị của Hội Tim mạch Việt Nam, người cao huyết áp nên đo 2 lần/ngày vào buổi sáng và tối.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=800&q=80",
            "01/05/2026","khuyen-nghi","Khuyến nghị bác sĩ","doctor","Khuyến nghị bác sĩ",
            new String[]{"Huyết áp","Bác sĩ","Khuyến nghị"},1760,false));

        ALL.add(new NewsArticle(11,
            "Hướng dẫn vệ sinh và bảo quản máy xông khí dung đúng cách",
            "Vệ sinh mặt nạ, ống dẫn và buồng thuốc sau mỗi lần dùng giúp máy hoạt động bền lâu và an toàn.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1584515933487-779824d29309?w=800&q=80",
            "28/04/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Khí dung","Vệ sinh","Bảo quản"},980,false));

        ALL.add(new NewsArticle(12,
            "Trẻ sơ sinh bị sốt cao – khi nào cần dùng máy hạ sốt?",
            "Sốt trên 38.5°C kéo dài hơn 2 ngày cần can thiệp. Hướng dẫn sử dụng máy hạ sốt an toàn cho bé.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&q=80",
            "25/04/2026","tre-em","Sức khỏe trẻ em","warning","Cảnh báo",
            new String[]{"Trẻ sơ sinh","Sốt","Máy hạ sốt"},1340,false));

        ALL.add(new NewsArticle(13,
            "Tin y tế: WHO cảnh báo về biến thể cúm mới tại châu Á",
            "Tổ chức Y tế Thế giới phát cảnh báo về biến thể cúm H3N2 mới có khả năng lây lan nhanh.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80",
            "22/04/2026","tin-y-te","Tin y tế mới","new","Mới",
            new String[]{"Cúm","WHO","Tin tức"},2050,false));

        ALL.add(new NewsArticle(14,
            "Bộ Y tế khuyến cáo tiêm vaccine cúm trước mùa mưa",
            "Tiêm vaccine cúm hàng năm là biện pháp phòng ngừa hiệu quả nhất, đặc biệt với người cao tuổi và trẻ nhỏ.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80",
            "20/04/2026","khuyen-nghi","Khuyến nghị bác sĩ","doctor","Khuyến nghị bác sĩ",
            new String[]{"Vaccine","Cúm","Phòng bệnh"},1590,false));

        ALL.add(new NewsArticle(15,
            "Mẹo giảm đau lưng khi nằm giường bệnh lâu ngày",
            "Thay đổi tư thế mỗi 2 giờ, dùng đệm chống loét và tập vật lý trị liệu nhẹ giúp giảm đau hiệu quả.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800&q=80",
            "18/04/2026","meo-suc-khoe","Mẹo chăm sóc sức khỏe","useful","Hữu ích",
            new String[]{"Đau lưng","Giường bệnh","Mẹo hay"},870,false));

        ALL.add(new NewsArticle(16,
            "Cách đọc kết quả đo huyết áp: Chỉ số nào là bình thường?",
            "Huyết áp bình thường là 120/80 mmHg. Bài viết giải thích chi tiết chỉ số tâm thu, tâm trương và nhịp tim.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80",
            "15/04/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Huyết áp","Chỉ số","Hướng dẫn"},2340,false));

        ALL.add(new NewsArticle(17,
            "Bệnh sốt xuất huyết: Dấu hiệu nguy hiểm cần nhập viện ngay",
            "Xuất huyết dưới da, nôn ra máu, đau bụng dữ dội là dấu hiệu sốt xuất huyết nặng cần cấp cứu.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80",
            "12/04/2026","canh-bao","Cảnh báo bệnh mùa","warning","Cảnh báo",
            new String[]{"Sốt xuất huyết","Cảnh báo","Mùa mưa"},3120,false));

        ALL.add(new NewsArticle(18,
            "Dinh dưỡng cho người bệnh tiểu đường: Nên và không nên ăn gì?",
            "Chế độ ăn ít đường, nhiều chất xơ và protein giúp kiểm soát đường huyết ổn định suốt cả ngày.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80",
            "10/04/2026","meo-suc-khoe","Mẹo chăm sóc sức khỏe","useful","Hữu ích",
            new String[]{"Tiểu đường","Dinh dưỡng","Ăn uống"},1890,false));

        ALL.add(new NewsArticle(19,
            "Tin y tế: Phát hiện thuốc mới điều trị ung thư phổi giai đoạn sớm",
            "Nghiên cứu mới từ Đại học Harvard cho thấy thuốc ức chế PD-L1 hiệu quả 78% ở giai đoạn 1–2.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80",
            "08/04/2026","tin-y-te","Tin y tế mới","new","Mới",
            new String[]{"Ung thư","Thuốc mới","Nghiên cứu"},1450,false));

        ALL.add(new NewsArticle(20,
            "Bác sĩ khuyến nghị: Tầm soát ung thư đại tràng từ tuổi 45",
            "Nội soi đại tràng định kỳ mỗi 10 năm từ tuổi 45 giúp phát hiện sớm và điều trị hiệu quả.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=800&q=80",
            "05/04/2026","khuyen-nghi","Khuyến nghị bác sĩ","doctor","Khuyến nghị bác sĩ",
            new String[]{"Ung thư đại tràng","Tầm soát","Bác sĩ"},1230,false));

        ALL.add(new NewsArticle(21,
            "Trẻ em và màn hình: Bao nhiêu giờ/ngày là an toàn cho mắt?",
            "WHO khuyến nghị trẻ dưới 2 tuổi không dùng màn hình, trẻ 2–5 tuổi tối đa 1 giờ/ngày.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&q=80",
            "02/04/2026","tre-em","Sức khỏe trẻ em","useful","Hữu ích",
            new String[]{"Trẻ em","Mắt","Màn hình"},1670,false));

        ALL.add(new NewsArticle(22,
            "Hướng dẫn sử dụng máy đo đường huyết tại nhà cho người mới",
            "Cách lấy máu đầu ngón tay, hiệu chỉnh máy và đọc kết quả chính xác – hướng dẫn từng bước chi tiết.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=800&q=80",
            "30/03/2026","huong-dan","Hướng dẫn dùng thiết bị","guide","Hướng dẫn",
            new String[]{"Đường huyết","Hướng dẫn","Người mới"},760,false));

        ALL.add(new NewsArticle(23,
            "Cảnh báo: Lạm dụng thuốc hạ sốt có thể gây hại gan",
            "Paracetamol quá liều gây tổn thương gan nghiêm trọng. Bác sĩ cảnh báo không dùng quá 4g/ngày.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80",
            "28/03/2026","canh-bao","Cảnh báo bệnh mùa","warning","Cảnh báo",
            new String[]{"Thuốc hạ sốt","Gan","Cảnh báo"},2780,false));

        ALL.add(new NewsArticle(24,
            "Mẹo chăm sóc người cao tuổi bị loãng xương tại nhà",
            "Bổ sung canxi, vitamin D, tập thể dục nhẹ và tránh té ngã là những biện pháp quan trọng nhất.",
            FRAG_DEFAULT,
            "https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800&q=80",
            "25/03/2026","meo-suc-khoe","Mẹo chăm sóc sức khỏe","useful","Hữu ích",
            new String[]{"Loãng xương","Người cao tuổi","Canxi"},1050,false));
    }
}
