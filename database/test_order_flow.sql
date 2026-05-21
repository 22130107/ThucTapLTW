-- Script test quy trình đơn hàng
-- Sử dụng để test nhanh các trạng thái đơn hàng

USE dataweb;

-- 1. Xem tất cả đơn hàng và trạng thái
SELECT 
    OrderID,
    CustomerID,
    RecipientName,
    Status,
    TotalAmount,
    OrderDate,
    CASE Status
        WHEN 'Pending' THEN 'Chờ xác nhận'
        WHEN 'Processing' THEN 'Đã xác nhận'
        WHEN 'Shipping' THEN 'Đang giao'
        WHEN 'Completed' THEN 'Đã giao'
        WHEN 'Cancelled' THEN 'Đã hủy'
    END as StatusVietnamese
FROM orders
ORDER BY OrderID DESC;

-- 2. Chuyển đơn hàng sang Processing (Xác nhận)
-- UPDATE orders SET Status = 'Processing' WHERE OrderID = 1;

-- 3. Chuyển đơn hàng sang Shipping (Đang giao)
-- UPDATE orders SET Status = 'Shipping' WHERE OrderID = 1;

-- 4. Chuyển đơn hàng sang Completed (Đã giao)
-- UPDATE orders SET Status = 'Completed' WHERE OrderID = 1;

-- 5. Hủy đơn hàng
-- UPDATE orders SET Status = 'Cancelled' WHERE OrderID = 1;

-- 6. Kiểm tra khách hàng có thể đánh giá không
SELECT 
    o.OrderID,
    o.Status,
    oi.ProductID,
    p.ProductName,
    CASE 
        WHEN o.Status = 'Completed' THEN 'Có thể đánh giá ✓'
        ELSE 'Chưa thể đánh giá ✗'
    END as CanReview
FROM orders o
JOIN orderitems oi ON o.OrderID = oi.OrderID
JOIN products p ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 1  -- Thay bằng CustomerID của bạn
ORDER BY o.OrderDate DESC;

-- 7. Test flow đầy đủ cho một đơn hàng
SET @test_order_id = 3;  -- Thay bằng OrderID muốn test

-- Bước 1: Pending → Processing
UPDATE orders SET Status = 'Processing' WHERE OrderID = @test_order_id;
SELECT CONCAT('✓ Đơn hàng #', @test_order_id, ' đã chuyển sang Processing') as Step1;

-- Đợi 2 giây (trong thực tế)
-- SELECT SLEEP(2);

-- Bước 2: Processing → Shipping
UPDATE orders SET Status = 'Shipping' WHERE OrderID = @test_order_id;
SELECT CONCAT('✓ Đơn hàng #', @test_order_id, ' đã chuyển sang Shipping') as Step2;

-- Bước 3: Shipping → Completed
UPDATE orders SET Status = 'Completed' WHERE OrderID = @test_order_id;
SELECT CONCAT('✓ Đơn hàng #', @test_order_id, ' đã chuyển sang Completed') as Step3;

-- Bước 4: Kiểm tra có thể đánh giá
SELECT 
    CONCAT('✓ Khách hàng có thể đánh giá ', COUNT(DISTINCT oi.ProductID), ' sản phẩm') as Step4
FROM orders o
JOIN orderitems oi ON o.OrderID = oi.OrderID
WHERE o.OrderID = @test_order_id AND o.Status = 'Completed';

-- 8. Thống kê đơn hàng theo trạng thái
SELECT 
    Status,
    CASE Status
        WHEN 'Pending' THEN 'Chờ xác nhận'
        WHEN 'Processing' THEN 'Đã xác nhận'
        WHEN 'Shipping' THEN 'Đang giao'
        WHEN 'Completed' THEN 'Đã giao'
        WHEN 'Cancelled' THEN 'Đã hủy'
    END as StatusVietnamese,
    COUNT(*) as Count,
    SUM(TotalAmount) as TotalRevenue
FROM orders
GROUP BY Status
ORDER BY 
    FIELD(Status, 'Pending', 'Processing', 'Shipping', 'Completed', 'Cancelled');

-- 9. Tạo đơn hàng test mới với trạng thái Completed
INSERT INTO orders (CustomerID, TotalAmount, Status, PaymentMethod, RecipientName, ShippingAddress)
VALUES (1, 500000, 'Completed', 'COD', 'Test User', 'Test Address');

SET @new_order_id = LAST_INSERT_ID();

INSERT INTO orderitems (OrderID, ProductID, Quantity, PriceAtOrder)
VALUES (@new_order_id, 1, 1, 500000);  -- Thay ProductID nếu cần

INSERT INTO order_shipping (OrderID, RecipientPhone, ToDistrictId, ToWardCode)
VALUES (@new_order_id, '0123456789', 1547, '550307');

SELECT CONCAT('✓ Đã tạo đơn hàng test #', @new_order_id, ' với trạng thái Completed') as Result;

-- 10. Reset đơn hàng về Pending (để test lại)
-- UPDATE orders SET Status = 'Pending' WHERE OrderID = @test_order_id;

-- 11. Xem chi tiết một đơn hàng
SELECT 
    o.OrderID,
    o.CustomerID,
    c.FullName as CustomerName,
    o.RecipientName,
    o.ShippingAddress,
    o.Status,
    o.PaymentMethod,
    o.TotalAmount,
    o.OrderDate,
    GROUP_CONCAT(CONCAT(p.ProductName, ' (x', oi.Quantity, ')') SEPARATOR ', ') as Products
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN orderitems oi ON o.OrderID = oi.OrderID
JOIN products p ON oi.ProductID = p.ProductID
WHERE o.OrderID = @test_order_id
GROUP BY o.OrderID;
