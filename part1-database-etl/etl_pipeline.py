import pandas as pd
import mysql.connector
import re

# ---------------- DB CONFIG ----------------
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password=PASSWORD FOR LOCAL MYSQL,
    database="fleximart"
)
cursor = db.cursor()

report = []

# ---------------- HELPERS ----------------
def standardize_phone(phone):
    if pd.isna(phone):
        return None
    digits = re.sub(r"\D", "", str(phone))
    if len(digits) == 10:
        return f"+91-{digits}"
    return None

def standardize_category(cat):
    if pd.isna(cat):
        return "Misc"
    return cat.strip().capitalize()

def parse_date(date_val):
    if pd.isna(date_val):
        return None
    try:
        # Automatically parse multiple formats safely
        return pd.to_datetime(date_val, errors="coerce").date()
    except:
        return None

# ---------------- CUSTOMERS ----------------
customers = pd.read_csv(
    r"C:\Users\soham\OneDrive\Desktop\studentID-fleximart-data-architecture\data\customers_raw.csv"
)

initial_customers = len(customers)

# Remove duplicates and standardize phone
customers.drop_duplicates(subset=["email"], inplace=True)
customers["phone"] = customers["phone"].apply(standardize_phone)
customers.dropna(subset=["email"], inplace=True)

report.append(f"Customers processed: {initial_customers}")
report.append(f"Customers loaded: {len(customers)}")

# Insert customers
for _, row in customers.iterrows():
    cursor.execute("""
        INSERT INTO customers (customer_id, first_name, last_name, email, phone, city, registration_date)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
        ON DUPLICATE KEY UPDATE
            first_name=VALUES(first_name),
            last_name=VALUES(last_name),
            phone=VALUES(phone),
            city=VALUES(city),
            registration_date=VALUES(registration_date)
    """, (
        row["customer_id"], row["first_name"], row["last_name"],
        row["email"], row["phone"], row["city"], parse_date(row["registration_date"])
    ))

# ---------------- PRODUCTS ----------------
products = pd.read_csv(
    r"C:\Users\soham\OneDrive\Desktop\studentID-fleximart-data-architecture\data\products_raw.csv"
)

products.drop_duplicates(subset=["product_id"], inplace=True)
products["category"] = products["category"].apply(standardize_category)
products["price"].fillna(products["price"].median(), inplace=True)
products["stock_quantity"].fillna(0, inplace=True)

report.append(f"Products loaded: {len(products)}")

# Insert products
for _, row in products.iterrows():
    cursor.execute("""
        INSERT INTO products (product_id, product_name, category, price, stock_quantity)
        VALUES (%s,%s,%s,%s,%s)
        ON DUPLICATE KEY UPDATE
            product_name=VALUES(product_name),
            category=VALUES(category),
            price=VALUES(price),
            stock_quantity=VALUES(stock_quantity)
    """, (
        row["product_id"], row["product_name"], row["category"], row["price"], row["stock_quantity"]
    ))

# ---------------- SALES ----------------
sales = pd.read_csv(
    r"C:\Users\soham\OneDrive\Desktop\studentID-fleximart-data-architecture\data\sales_raw.csv"
)

# Remove duplicates and invalid rows
sales.drop_duplicates(inplace=True)
sales.dropna(subset=["customer_id", "product_id"], inplace=True)
sales["order_date"] = sales["transaction_date"].apply(parse_date)

# Insert sales with auto-increment order IDs
for _, row in sales.iterrows():
    # Check that customer and product exist to avoid FK errors
    cursor.execute("SELECT 1 FROM customers WHERE customer_id=%s", (row["customer_id"],))
    if cursor.fetchone() is None:
        continue  # skip invalid customer

    cursor.execute("SELECT price FROM products WHERE product_id=%s", (row["product_id"],))
    product = cursor.fetchone()
    if product is None:
        continue  # skip invalid product

    unit_price = row["unit_price"] if pd.notna(row["unit_price"]) else product[0]
    quantity = row["quantity"] if pd.notna(row["quantity"]) else 1
    total_amount = unit_price * quantity

    # Insert into orders (auto-increment ID)
    cursor.execute("""
        INSERT INTO orders (customer_id, order_date, total_amount)
        VALUES (%s,%s,%s)
    """, (row["customer_id"], row["order_date"], total_amount))
    order_id = cursor.lastrowid  # use auto-incremented ID

    # Insert into order_items
    cursor.execute("""
        INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
        VALUES (%s,%s,%s,%s,%s)
    """, (
        order_id, row["product_id"], quantity, unit_price, total_amount
    ))

db.commit()

# ---------------- REPORT ----------------
with open(r"C:\Users\soham\OneDrive\Desktop\studentID-fleximart-data-architecture\data_quality_report.txt", "w") as f:
    f.write("\n".join(report))

print("ETL Completed Successfully")

