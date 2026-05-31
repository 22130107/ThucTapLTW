-- Script để debug quyền đánh giá sản phẩm
-- Chạy script này để kiểm tra tại sao không đánh giá được

USE dataweb;

-- 1. Kiểm tra thông tin khách hàng
SELECT 
    a.AccountID,
    a.Username,
    c.CustomerID,
    c.FullName
FROM accounts a
JOIN customers c ON a.AccountID = c.AccountID
WHERE a.Username = 'testuser';  -- Thay 'testuser' bằng username của bạn

-- 2. Kiểm tra đơn hàng của khách hàng
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    o.TotalAmount,
    oi.ProductID,
    p.ProductName,
    oi.Quantity
FROM orders o
JOIN orderitems oi ON o.OrderID = oi.OrderID
JOIN products p ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 1  -- Thay 1 bằng CustomerID của bạn
ORDER BY o.OrderDate DESC;

-- 3. Kiểm tra sản phẩm nào khách hàng đã mua (có thể đánh giá)
SELECT DISTINCT
    p.ProductID,
    p.ProductName,
    o.Status,
    o.OrderDate,
    CASE 
        WHEN o.Status IN ('Processing', 'Shipping', 'Completed') THEN 'Có thể đánh giá'
        ELSE 'Chưa thể đánh giá'
    END as ReviewPermission
FROM orders o
JOIN orderitems oi ON o.OrderID = oi.OrderID
JOIN products p ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 1  -- Thay 1 bằng CustomerID của bạn
ORDER BY o.OrderDate DESC;

-- 4. Kiểm tra đánh giá đã có của khách hàng
SELECT 
    r.ReviewID,
    r.ProductID,
    p.ProductName,
    r.Rating,
    r.Content,
    r.ReviewDate
FROM reviews r
JOIN products p ON r.ProductID = p.ProductID
WHERE r.CustomerID = 1;  -- Thay 1 bằng CustomerID của bạn

-- 5. Kiểm tra quyền đánh giá cho một sản phẩm cụ thể
-- Thay CustomerID = 1 và ProductID = 1 bằng giá trị thực tế
SET @customer_id = 1;
SET @product_id = 1;

SELECT 
    'Đã mua sản phẩm?' as Question,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM orders o
            JOIN orderitems oi ON o.OrderID = oi.OrderID
            WHERE o.CustomerID = @customer_id 
            AND oi.ProductID = @product_id
            AND o.Status IN ('Processing', 'Shipping', 'Completed')
        ) THEN 'CÓ ✓'
        ELSE 'KHÔNG ✗'
    END as Answer
UNION ALL
SELECT 
    'Đã đánh giá rồi?' as Question,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM reviews
            WHERE CustomerID = @customer_id 
            AND ProductID = @product_id
        ) THEN 'CÓ ✓'
        ELSE 'KHÔNG ✗'
    END as Answer
UNION ALL
SELECT 
    'Có thể đánh giá?' as Question,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM orders o
            JOIN orderitems oi ON o.OrderID = oi.OrderID
            WHERE o.CustomerID = @customer_id 
            AND oi.ProductID = @product_id
            AND o.Status IN ('Processing', 'Shipping', 'Completed')
        ) AND NOT EXISTS (
            SELECT 1 FROM reviews
            WHERE CustomerID = @customer_id 
            AND ProductID = @product_id
        ) THEN 'CÓ ✓'
        ELSE 'KHÔNG ✗'
    END as Answer;

-- 6. Cập nhật trạng thái đơn hàng để test (nếu cần)
-- UNCOMMENT dòng dưới để chuyển đơn hàng sang Processing
-- UPDATE orders SET Status = 'Processing' WHERE OrderID = 1;

-- 7. Xem tất cả trạng thái đơn hàng hiện có
SELECT DISTINCT Status, COUNT(*) as Count
FROM orders
GROUP BY Status;
