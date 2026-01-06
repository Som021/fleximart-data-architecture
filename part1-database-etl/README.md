 Part 1 — Database Design & ETL Pipeline

 Objective
This part focuses on transforming raw transactional data into a clean, normalized relational database using an ETL pipeline.

---

 Components:

 Files Included
- `etl_pipeline.py` — Python ETL script
- `schema_documentation.md` — Database schema explanation
- `business_queries.sql` — Business-level SQL queries
- `data_quality_report.txt` — ETL data cleaning report
- `requirements.txt` — Python dependencies

---

 ETL Workflow

1. Extract raw data from CSV files
2. Clean and standardize data:
   - Remove duplicates
   - Fix date formats
   - Validate IDs
   - Handle missing values
3. Load data into MySQL tables:
   - customers
   - products
   - orders
   - order_items

---

 Key Design Decisions
- String-based IDs for customers and products
- Auto-incremented order IDs
- Foreign key constraints for integrity
- Normalized schema to reduce redundancy

---

 How to Run
On Bash:

pip install -r requirements.txt
python etl_pipeline.py
