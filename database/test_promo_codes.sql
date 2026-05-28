-- Test data cho bảng promocodes
-- Chạy script này để tạo một số mã khuyến mãi mẫu để test

USE dataweb;

-- Xóa dữ liệu test cũ (nếu có)
DELETE FROM promocodes WHERE code IN ('SUMMER2024', 'WELCOME10', 'FREESHIP', 'VIP50K');

-- 1. Mã giảm 10% - Không giới hạn
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('SUMMER2024', 'percent', 10.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 0, 0, 1, 100000.00, 'all', NULL, 1);

-- 2. Mã giảm 10% cho khách hàng mới - Giới hạn 100 lượt
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('WELCOME10', 'percent', 10.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 100, 0, 1, 50000.00, 'all', NULL, 1);

-- 3. Mã giảm 50,000đ - Đơn hàng tối thiểu 500,000đ
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('VIP50K', 'fixed', 50000.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 50, 0, 1, 500000.00, 'all', NULL, 1);

-- 4. Mã miễn phí ship - Giảm 30,000đ
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('FREESHIP', 'fixed', 30000.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 200, 0, 1, 0.00, 'all', NULL, 1);

-- 5. Mã đã hết hạn (để test validation)
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('EXPIRED', 'percent', 20.00, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 0, 0, 1, 0.00, 'all', NULL, 1);

-- 6. Mã chưa bắt đầu (để test validation)
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('FUTURE', 'percent', 15.00, '2027-01-01 00:00:00', '2027-12-31 23:59:59', 0, 0, 1, 0.00, 'all', NULL, 1);

-- 7. Mã đã hết lượt (để test validation)
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('SOLDOUT', 'percent', 25.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 10, 10, 1, 0.00, 'all', NULL, 1);

-- 8. Mã bị vô hiệu hóa (để test validation)
INSERT INTO promocodes (code, type, amount, start_at, end_at, usage_limit, used_count, active, min_order_value, applies_to, applies_to_id, created_by)
VALUES ('INACTIVE', 'percent', 30.00, '2024-01-01 00:00:00', '2026-12-31 23:59:59', 0, 0, 0, 0.00, 'all', NULL, 1);

-- Kiểm tra dữ liệu đã insert
SELECT 
    code,
    type,
    amount,
    CASE 
        WHEN NOW() < start_at THEN 'Chưa bắt đầu'
        WHEN NOW() > end_at THEN 'Đã hết hạn'
        ELSE 'Đang hoạt động'
    END as status,
    usage_limit,
    used_count,
    active,
    min_order_value
FROM promocodes
ORDER BY id DESC;

-- Test cases để thử:
-- ✅ SUMMER2024   - Giảm 10%, đơn tối thiểu 100k
-- ✅ WELCOME10    - Giảm 10%, đơn tối thiểu 50k, giới hạn 100 lượt
-- ✅ VIP50K       - Giảm 50k, đơn tối thiểu 500k
-- ✅ FREESHIP     - Giảm 30k, không giới hạn đơn hàng
-- ❌ EXPIRED      - Đã hết hạn
-- ❌ FUTURE       - Chưa bắt đầu
-- ❌ SOLDOUT      - Đã hết lượt
-- ❌ INACTIVE     - Bị vô hiệu hóa
