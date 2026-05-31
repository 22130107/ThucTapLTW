-- ⚠️ LƯU Ý: Database của bạn đã có sẵn các cột này rồi!
-- Script này chỉ để tham khảo, KHÔNG CẦN chạy lại

-- Bảng orders đã có:
-- `PromoCode` varchar(50) NULL
-- `DiscountAmount` decimal(10,2) NOT NULL

-- Nếu bạn muốn thêm index (tùy chọn):
-- CREATE INDEX IF NOT EXISTS idx_orders_promocode ON orders(PromoCode);

-- Kiểm tra cấu trúc bảng
DESCRIBE orders;
