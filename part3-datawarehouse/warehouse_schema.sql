/* =========================================================
   DATA WAREHOUSE SCHEMA: FLEXIMART ANALYTICS
   Schema Type: Star Schema
   ========================================================= */

CREATE DATABASE IF NOT EXISTS fleximart_dw;
USE fleximart_dw;

/* =========================================================
   DIMENSION TABLE: DATE
   ========================================================= */
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);

/* =========================================================
   DIMENSION TABLE: PRODUCT
   ========================================================= */
CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(10) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    UNIQUE (product_id)
);

/* =========================================================
   DIMENSION TABLE: CUSTOMER
   ========================================================= */
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    region VARCHAR(50),
    UNIQUE (customer_id)
);

/* =========================================================
   FACT TABLE: SALES
   ========================================================= */
CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    date_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    quantity_sold INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_sales_date
        FOREIGN KEY (date_key) REFERENCES dim_date(date_key),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (product_key) REFERENCES dim_product(product_key),

    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);
