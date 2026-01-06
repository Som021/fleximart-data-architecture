USE fleximart;

-- =====================================================
-- 1. TOTAL NUMBER OF CUSTOMERS
-- =====================================================
SELECT COUNT(*) AS total_customers
FROM customers;


-- =====================================================
-- 2. TOTAL NUMBER OF PRODUCTS
-- =====================================================
SELECT COUNT(*) AS total_products
FROM products;


-- =====================================================
-- 3. TOTAL SALES REVENUE
-- =====================================================
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders;


-- =====================================================
-- 4. TOTAL NUMBER OF ORDERS
-- =====================================================
SELECT COUNT(*) AS total_orders
FROM orders;


-- =====================================================
-- 5. TOP 5 CUSTOMERS BY TOTAL SPENDING
-- =====================================================
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;


-- =====================================================
-- 6. TOP 5 BEST-SELLING PRODUCTS (BY QUANTITY)
-- =====================================================
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- =====================================================
-- 7. TOP 5 BEST-SELLING PRODUCTS (BY REVENUE)
-- =====================================================
SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.subtotal), 2) AS revenue_generated
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue_generated DESC
LIMIT 5;


-- =====================================================
-- 8. DAILY SALES TREND
-- =====================================================
SELECT 
    order_date,
    ROUND(SUM(total_amount), 2) AS daily_sales
FROM orders
GROUP BY order_date
ORDER BY order_date;


-- =====================================================
-- 9. MONTHLY SALES TREND
-- =====================================================
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(total_amount), 2) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;


-- =====================================================
-- 10. CUSTOMER ORDER FREQUENCY
-- =====================================================
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_orders DESC;


-- =====================================================
-- 11. PRODUCTS WITH LOW STOCK (LESS THAN 10)
-- =====================================================
SELECT 
    product_id,
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;


-- =====================================================
-- 12. AVERAGE ORDER VALUE
-- =====================================================
SELECT 
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders;


-- =====================================================
-- 13. MOST ACTIVE CUSTOMER CITY
-- =====================================================
SELECT 
    city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY city
ORDER BY total_orders DESC
LIMIT 1;


-- =====================================================
-- 14. CUSTOMER LIFETIME VALUE (CLV)
-- =====================================================
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(o.total_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY lifetime_value DESC;


-- =====================================================
-- 15. PRODUCTS NEVER SOLD
-- =====================================================
SELECT 
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- =====================================================
-- 16. ORDERS WITH MORE THAN 1 PRODUCT
-- =====================================================
SELECT 
    o.order_id,
    COUNT(oi.product_id) AS number_of_products
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING number_of_products > 1;


-- =====================================================
-- 17. TOTAL SALES BY CATEGORY
-- =====================================================
SELECT 
    p.category,
    ROUND(SUM(oi.subtotal), 2) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- =====================================================
-- 18. MOST FREQUENTLY ORDERED PRODUCT PER CUSTOMER
-- =====================================================
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    SUM(oi.quantity) AS quantity_ordered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, p.product_name
ORDER BY c.customer_id, quantity_ordered DESC;

