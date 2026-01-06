# NoSQL Analysis – FlexiMart

## 1. Introduction

This document presents an academic-oriented NoSQL analysis for the FlexiMart project. It explains the rationale for using MongoDB, the schema design approach, and a comparison with the existing MySQL-based relational system.

The goal of introducing NoSQL is to support flexible, semi-structured data, especially for product catalogs that may evolve over time with varying attributes.

---

## 2. Why MongoDB for FlexiMart

MongoDB is a document-oriented NoSQL database that stores data in JSON-like BSON documents. It is well-suited for use cases where:

* Data structure is flexible or evolving
* Records contain nested or hierarchical data
* High read performance is required
* Horizontal scalability is important

### Key Reasons for Choosing MongoDB

1. **Schema Flexibility**
   Products can have varying attributes (sizes, colors, variants, discounts) without altering a rigid schema.

2. **Natural JSON Structure**
   MongoDB documents closely resemble API responses and frontend data models, reducing transformation overhead.

3. **Embedded Documents**
   Related data such as product variants and stock levels can be embedded within a single document, reducing joins.

4. **Scalability**
   MongoDB supports horizontal scaling through sharding, making it suitable for growing product catalogs.

5. **Performance**
   Read-heavy operations like product browsing and filtering are faster due to denormalized data access.

---

## 3. Use Case Selection: Product Catalog

In FlexiMart, transactional data (customers, orders, payments) is best handled using a relational database (MySQL) due to strict consistency and referential integrity requirements.

However, the **product catalog** benefits from a NoSQL approach because:

* Products may have different attributes per category
* Variants (size, color, pack type) vary by product
* Inventory and pricing data can be nested
* Frequent read operations dominate

Hence, MongoDB is used **only for the product catalog**, following a polyglot persistence approach.

---

## 4. MongoDB Schema Design

### Collection: `products_catalog`

Each document represents a complete product with embedded attributes.

### Example High-Level Structure

* product_id (String)
* product_name (String)
* category (String)
* base_price (Number)
* variants (Array of Objects)
* stock (Embedded Object)
* tags (Array)
* created_at (Date)

### Embedded Variants Structure

Each product may have multiple variants such as:

* Size (Small, Medium, Large)
* Color (Red, Blue, Black)
* Pack type (Single, Combo)

This avoids creating multiple relational tables and join operations.

---

## 5. Normalization vs Denormalization

### MySQL (Normalized)

* Products stored in one table
* Variants stored in separate tables
* Inventory tracked separately
* Requires joins for complete product view

### MongoDB (Denormalized)

* Product, variants, and stock stored together
* Single document fetch retrieves full product data
* Improves read performance

Denormalization is intentional in MongoDB to optimize read-heavy workloads.

---

## 6. Comparison: MongoDB vs MySQL

| Feature     | MongoDB           | MySQL                 |
| ----------- | ----------------- | --------------------- |
| Data Model  | Document-based    | Relational tables     |
| Schema      | Flexible          | Fixed                 |
| Joins       | Limited           | Strong                |
| Scalability | Horizontal        | Vertical (primarily)  |
| Best For    | Catalogs, content | Transactions, finance |

---

## 7. Data Consistency Approach

* MongoDB handles product catalog data
* MySQL remains the system of record for orders and customers
* Product IDs are shared across systems for integration
* ETL or API-level synchronization can be used if required

This hybrid approach ensures both **flexibility and integrity**.

---

## 8. Conclusion

MongoDB complements the MySQL database in FlexiMart by efficiently handling flexible, read-heavy product catalog data.

By using MongoDB for NoSQL workloads and MySQL for transactional workloads, FlexiMart achieves:

* Better performance
* Scalable architecture
* Cleaner schema design
* Industry-standard polyglot persistence
