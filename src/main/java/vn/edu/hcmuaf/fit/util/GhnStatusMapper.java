package vn.edu.hcmuaf.fit.util;

public class GhnStatusMapper {
    private GhnStatusMapper() {
    }

    /**
     * Ánh xạ trạng thái GHN sang trạng thái đơn hàng nội bộ.
     *
     * Danh sách trạng thái GHN đầy đủ:
     * - ready_to_pick   : Chờ lấy hàng
     * - picking         : Đang lấy hàng
     * - picked          : Đã lấy hàng
     * - money_collect_picking : Đang thu tiền người gửi
     * - storing         : Đang lưu kho
     * - transporting    : Đang vận chuyển
     * - sorting         : Đang phân loại
     * - delivering      : Đang giao hàng
     * - money_collect_delivering : Đang thu tiền người nhận
     * - delivered       : Đã giao thành công
     * - delivery_fail   : Giao hàng thất bại
     * - waiting_to_return : Chờ trả hàng
     * - return          : Đang trả hàng
     * - returning       : Đang trả hàng về kho
     * - returned        : Đã trả hàng
     * - cancel          : Đã hủy
     * - exception       : Ngoại lệ / sự cố
     * - damage          : Hàng bị hư hỏng
     * - lost            : Hàng bị mất
     */
    public static String toOrderStatus(String ghnStatus) {
        if (ghnStatus == null) return null;
        switch (ghnStatus) {
            // Đang xử lý / chuẩn bị giao
            case "ready_to_pick":
            case "picking":
            case "picked":
            case "money_collect_picking":
            case "storing":
            case "transporting":
            case "sorting":
                return "Processing";

            // Đang giao đến tay khách
            case "delivering":
            case "money_collect_delivering":
                return "Shipping";

            // Giao thành công
            case "delivered":
                return "Completed";

            // Giao thất bại nhưng chưa hủy — vẫn giữ Shipping để admin xử lý
            case "delivery_fail":
            case "waiting_to_return":
                return "Shipping";

            // Đang hoàn hàng hoặc đã hủy
            case "return":
            case "returning":
            case "returned":
            case "cancel":
                return "Cancelled";

            // Sự cố nghiêm trọng
            case "exception":
            case "damage":
            case "lost":
                return "Cancelled";

            default:
                return null; // Không cập nhật nếu không nhận ra trạng thái
        }
    }

    /**
     * Trả về mô tả tiếng Việt của trạng thái GHN để hiển thị trên UI.
     */
    public static String toVietnamese(String ghnStatus) {
        if (ghnStatus == null) return "Không xác định";
        switch (ghnStatus) {
            case "ready_to_pick":             return "Chờ lấy hàng";
            case "picking":                   return "Đang lấy hàng";
            case "picked":                    return "Đã lấy hàng";
            case "money_collect_picking":     return "Đang thu tiền người gửi";
            case "storing":                   return "Đang lưu kho";
            case "transporting":              return "Đang vận chuyển";
            case "sorting":                   return "Đang phân loại";
            case "delivering":                return "Đang giao hàng";
            case "money_collect_delivering":  return "Đang thu tiền người nhận";
            case "delivered":                 return "Đã giao thành công";
            case "delivery_fail":             return "Giao hàng thất bại";
            case "waiting_to_return":         return "Chờ trả hàng";
            case "return":                    return "Đang trả hàng";
            case "returning":                 return "Đang trả hàng về kho";
            case "returned":                  return "Đã trả hàng";
            case "cancel":                    return "Đã hủy";
            case "exception":                 return "Sự cố vận chuyển";
            case "damage":                    return "Hàng bị hư hỏng";
            case "lost":                      return "Hàng bị mất";
            default:                          return ghnStatus;
        }
    }
}
