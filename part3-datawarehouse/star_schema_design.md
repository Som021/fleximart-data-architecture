
Star Schema Design

Project: FlexiMart Sales Analytics
Assignment: PART 3 — Data Warehouse
Schema Type: Star Schema

---

1. Introduction

A "Star Schema" is a dimensional data model widely used in data warehousing and business intelligence systems.
It consists of:

* One central fact table containing measurable business metrics
* Multiple dimension tables providing descriptive context for analysis

The FlexiMart Data Warehouse adopts a "Star Schema" to support fast, efficient analytical queries such as sales trends, customer segmentation, and product performance analysis.

---

2. Why Star Schema?

The Star Schema was chosen for the following reasons:

* ⭐ Simplified design – Easy to understand and maintain
* ⚡ High query performance – Fewer joins than normalized schemas
* 📊 Optimized for OLAP – Supports aggregations and drill-down analysis
* 🧠 Business-friendly – Aligns with how analysts think about data

This structure is ideal for read-heavy analytical workloads, unlike transactional databases which focus on frequent inserts and updates.

---

3. Schema Overview

The FlexiMart Star Schema consists of:

Central Fact Table

* fact_sales — Stores measurable sales data

Dimension Tables

* dim_date — Time-based attributes
* dim_product — Product details
* dim_customer — Customer information

---

 4. Star Schema Structure

```
                |dim_date|
                   |
                   |       
        |dim_product| ─── |fact_sales| ─── |dim_customer|
```

Each dimension table connects directly to the fact table, forming a star-like structure.

---

 5. Fact Table Description

⭐ fact_sales

The fact table stores quantitative metrics related to sales transactions.

Measures:

* Quantity sold
* Total sales amount

Foreign Keys:

* date_key
* product_key
* customer_key

Each record represents a single sales event.

---

6. Dimension Tables Description

📅 dim_date

Stores time-related attributes to support:

* Yearly trends
* Quarterly reports
* Monthly drill-downs

Attributes include:

* Day
* Month
* Month name
* Quarter
* Year

---

📦 dim_product

Stores descriptive information about products, enabling:

* Product-wise sales analysis
* Category-level reporting
* Top product identification

Attributes include:

* Product name
* Category
* Price

---

🧍 dim_customer

Stores customer-related attributes for:

* Customer segmentation
* Regional sales analysis
* Loyalty and value analysis

Attributes include:

* Customer name
* Region
* Email

---

7. Grain of the Fact Table

Grain Definition:

> One row in `fact_sales` represents **one product sold to one customer on one date**.

Clearly defining the grain ensures:

* Accurate aggregations
* Consistent reporting
* No ambiguity in analytics

---

8. Advantages of This Design

* ✔ Supports **drill-down and roll-up** queries
* ✔ Enables **fast aggregations**
* ✔ Reduces redundancy
* ✔ Separates transactional and analytical workloads
* ✔ Scales well with growing data volume

---

 9. Conclusion

The FlexiMart Star Schema provides a robust foundation for analytical reporting and business intelligence.
By separating facts from dimensions, it ensures **high performance, clarity, and scalability**, making it suitable for enterprise-level decision-making.

