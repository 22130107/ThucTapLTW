-- Fix lỗi cú pháp trong bảng orders (nếu cần)
-- Chỉ chạy nếu bạn gặp lỗi khi tạo bảng orders

-- Kiểm tra cấu trúc hiện tại
DESCRIBE orders;

-- Nếu cột PromoCode và DiscountAmount chưa có, thêm vào:
-- ALTER TABLE orders 
-- ADD COLUMN PromoCode VARCHAR(50) NULL AFTER ShippingAddress,
-- ADD COLUMN DiscountAmount DECIMAL(10,2) DEFAULT 0 AFTER PromoCode;

-- Nếu cột đã có nhưng có vấn đề, có thể drop và tạo lại:
-- ALTER TABLE orders DROP COLUMN PromoCode;
-- ALTER TABLE orders DROP COLUMN DiscountAmount;
-- 
-- ALTER TABLE orders 
-- ADD COLUMN PromoCode VARCHAR(50) NULL AFTER ShippingAddress,
-- ADD COLUMN DiscountAmount DECIMAL(10,2) DEFAULT 0 AFTER PromoCode;

-- Tạo index (tùy chọn, giúp tăng tốc truy vấn)
CREATE INDEX IF NOT EXISTS idx_orders_promocode ON orders(PromoCode);

-- Kiểm tra lại
DESCRIBE orders;
