USE fleximart_dw;

-- =====================================================
-- 1. DRILL-DOWN ANALYSIS
-- Year → Quarter → Month
-- =====================================================
SELECT
    d.year,
    d.quarter,
    d.month_name,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.quarter,
    d.month_name,
    d.month
ORDER BY
    d.year,
    d.quarter,
    d.month;

-- =====================================================
-- 2. ROLL-UP ANALYSIS
-- Monthly → Yearly Sales Summary
-- =====================================================
SELECT
    d.year,
    SUM(f.total_amount) AS yearly_sales,
    SUM(f.quantity_sold) AS yearly_quantity
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;

-- =====================================================
-- 3. TOP 10 PRODUCTS BY REVENUE
-- =====================================================
SELECT
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS revenue,
    ROUND(
        SUM(f.total_amount) /
        SUM(SUM(f.total_amount)) OVER () * 100,
        2
    ) AS revenue_percentage
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_name,
    p.category
ORDER BY revenue DESC
LIMIT 10;

-- =====================================================
-- 4. CUSTOMER SEGMENTATION (HIGH / MEDIUM / LOW VALUE)
-- =====================================================
WITH customer_spend AS (
    SELECT
        c.customer_key,
        SUM(f.total_amount) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT
    CASE
        WHEN total_spent > 50000 THEN 'High Value'
        WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue
FROM customer_spend
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- =====================================================
-- 5. DAILY SALES TREND
-- =====================================================
SELECT
    d.full_date,
    SUM(f.total_amount) AS daily_revenue,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT f.customer_key) AS unique_customers
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY d.full_date
ORDER BY d.full_date;

-- =====================================================
-- 6. PEAK SALES DAY
-- =====================================================
SELECT
    d.full_date,
    SUM(f.total_amount) AS total_revenue,
    COUNT(*) AS transaction_count
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY d.full_date
ORDER BY total_revenue DESC
LIMIT 1;

-- =====================================================
-- 7. REGION-WISE SALES PERFORMANCE
-- =====================================================
SELECT
    c.region,
    SUM(f.total_amount) AS region_sales,
    COUNT(*) AS transaction_count,
    ROUND(
        SUM(f.total_amount) /
        SUM(SUM(f.total_amount)) OVER () * 100,
        2
    ) AS sales_percentage
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY c.region
ORDER BY region_sales DESC;

-- =====================================================
-- 8. LOW PERFORMING PRODUCTS
-- Products with total quantity < 10
-- =====================================================
SELECT
    p.product_name,
    SUM(f.quantity_sold) AS total_quantity,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY p.product_name
HAVING total_quantity < 10
ORDER BY total_quantity ASC;

-- =====================================================
-- 9. AVERAGE ORDER VALUE BY REGION
-- =====================================================
SELECT
    c.region,
    ROUND(AVG(f.total_amount), 2) AS avg_order_value
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY c.region
ORDER BY avg_order_value DESC;

-- =====================================================
-- 10. PRODUCT CATEGORY PERFORMANCE
-- =====================================================
SELECT
    p.category,
    SUM(f.quantity_sold) AS total_units_sold,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;
