 Part 3 — Data Warehouse & Analytics

Objective:
This part implements a data warehouse using a Star Schema to support analytical queries and reporting.

---

Components:

 Files Included:
- `star_schema_design.md` — Star schema explanation
- `warehouse_schema.sql` — Warehouse DDL
- `warehouse_data.sql` — ETL load into warehouse
- `analytics_queries.sql` — OLAP queries

---

 Star Schema Design:

- Fact Table: `fact_sales`
- Dimension Tables:
  - `dim_date`
  - `dim_product`
  - `dim_customer`

---

 Analytics Performed:
- Drill-down analysis
- Top product performance
- Customer segmentation
- Time-based trends

---

 How to Run:

On Sql:

SOURCE warehouse_schema.sql;
SOURCE warehouse_data.sql;
SOURCE analytics_queries.sql;

---

Outcome:
- Analytics-ready data warehouse
- High-performance reporting queries

---

