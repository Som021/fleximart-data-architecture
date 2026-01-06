/* =====================================================
   STEP 3.3 — ETL: LOAD DATA INTO STAR SCHEMA
   Source: fleximart (OLTP)
   Target: fleximart_dw (Data Warehouse)
===================================================== */

USE fleximart_dw;

-- -----------------------------------------------------
-- 1. LOAD DATE DIMENSION
-- -----------------------------------------------------
INSERT INTO dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year
)
SELECT DISTINCT
    DATE_FORMAT(o.order_date, '%Y%m%d') AS date_key,
    o.order_date,
    DAY(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date),
    QUARTER(o.order_date),
    YEAR(o.order_date)
FROM fleximart.orders o
WHERE o.order_date IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM dim_date d
    WHERE d.full_date = o.order_date
);

-- -----------------------------------------------------
-- 2. LOAD PRODUCT DIMENSION
-- -----------------------------------------------------
INSERT INTO dim_product (
    product_id,
    product_name,
    category,
    price
)
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category,
    p.price
FROM fleximart.products p
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_product dp
    WHERE dp.product_id = p.product_id
);

-- -----------------------------------------------------
-- 3. LOAD CUSTOMER DIMENSION
-- -----------------------------------------------------
INSERT INTO dim_customer (
    customer_id,
    first_name,
    last_name,
    email,
    region
)
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city AS region
FROM fleximart.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_customer dc
    WHERE dc.customer_id = c.customer_id
);

-- -----------------------------------------------------
-- 4. LOAD FACT SALES TABLE
-- -----------------------------------------------------
INSERT INTO fact_sales (
    date_key,
    product_key,
    customer_key,
    quantity_sold,
    total_amount
)
SELECT
    d.date_key,
    dp.product_key,
    dc.customer_key,
    oi.quantity,
    oi.subtotal
FROM fleximart.orders o
JOIN fleximart.order_items oi
    ON o.order_id = oi.order_id
JOIN dim_date d
    ON d.full_date = o.order_date
JOIN dim_product dp
    ON dp.product_id = oi.product_id
JOIN dim_customer dc
    ON dc.customer_id = o.customer_id;

-- -----------------------------------------------------
-- 5. ETL VALIDATION COUNTS
-- -----------------------------------------------------
SELECT 'dim_date' AS table_name, COUNT(*) AS records FROM dim_date
UNION
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION
SELECT 'fact_sales', COUNT(*) FROM fact_sales;
