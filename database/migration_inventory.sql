-- Inventory Management Tables
-- Run this script against the dataweb database

CREATE TABLE IF NOT EXISTS inventory_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL COMMENT 'import, export, adjust, order_export, order_cancel_return',
    reference_id INT NULL COMMENT 'order_id if type=order_export or order_cancel_return',
    note TEXT,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES accounts(AccountID)
);

CREATE TABLE IF NOT EXISTS inventory_transaction_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_change INT NOT NULL COMMENT 'positive=in, negative=out',
    current_stock INT NOT NULL COMMENT 'stock after change',
    note TEXT,
    FOREIGN KEY (transaction_id) REFERENCES inventory_transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(ProductID)
);

-- Add low_stock_threshold column (ignore error if already exists)
ALTER TABLE productdetails ADD COLUMN low_stock_threshold INT DEFAULT 5;
