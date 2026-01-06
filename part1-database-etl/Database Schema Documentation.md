
DATABASE SCHEMA DOCUMENTATION

Database Name: fleximart

---

1. OVERVIEW

---

The FlexiMart database is designed to store customer, product, and sales
transaction data while maintaining strong referential integrity through
foreign key constraints.

The system supports string-based identifiers such as C001 and P001 to
enable seamless integration with external systems and CSV-based data
sources.

---

2. TABLES OVERVIEW

---

## Table Name     Purpose

customers      Stores customer details
products       Stores product catalog information
orders         Stores order-level transaction data
order_items    Stores product-level order details

---

3. TABLE DEFINITIONS

---

## CUSTOMERS TABLE

## Column Name         Data Type        Description

customer_id         VARCHAR(10)      Unique customer ID (e.g., C001)
first_name          VARCHAR(50)      Customer first name
last_name           VARCHAR(50)      Customer last name
email               VARCHAR(100)     Unique customer email
phone               VARCHAR(20)      Standardized phone number
city                VARCHAR(50)      Customer city
registration_date   DATE             Customer registration date

Primary Key:

* customer_id

Unique Constraint:

* email

---

## PRODUCTS TABLE

## Column Name         Data Type        Description

product_id          VARCHAR(10)      Product ID (e.g., P001)
product_name        VARCHAR(100)     Product name
category            VARCHAR(50)      Product category
price               DECIMAL(10,2)    Product price
stock_quantity      INT              Available stock quantity

Primary Key:

* product_id

---

## ORDERS TABLE

## Column Name         Data Type        Description

order_id            INT              Auto-increment unique order ID
customer_id         VARCHAR(10)      Reference to customer
order_date          DATE             Order date
total_amount        DECIMAL(10,2)    Total order value

Primary Key:

* order_id

Foreign Key:

* customer_id REFERENCES customers(customer_id)

---

## ORDER_ITEMS TABLE

## Column Name         Data Type        Description

order_item_id       INT              Auto-increment line item ID
order_id            INT              Reference to order
product_id          VARCHAR(10)      Reference to product
quantity            INT              Units ordered
unit_price          DECIMAL(10,2)    Price per unit
subtotal            DECIMAL(10,2)    quantity * unit_price

Primary Key:

* order_item_id

Foreign Keys:

* order_id REFERENCES orders(order_id)
* product_id REFERENCES products(product_id)

---

4. RELATIONSHIPS (ER SUMMARY)

---

customers 1 ----< orders 1 ----< order_items >---- 1 products

---

5. DESIGN JUSTIFICATION

---

* String-based IDs for customers and products enable flexible integration
  with external systems and improve human readability.

* Auto-incremented order IDs ensure guaranteed uniqueness, simplify
  transaction handling, and improve database performance.

* Foreign key constraints enforce referential integrity and prevent
  orphan or invalid records across related tables.

* The normalized database structure avoids redundancy, ensures data
  consistency, and improves maintainability and scalability.

---