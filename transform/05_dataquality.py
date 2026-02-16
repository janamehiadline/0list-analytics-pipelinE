import pandas as pd

# Load processed datasets
customers = pd.read_csv("data/processed/customers.csv")
orders = pd.read_csv("data/processed/orders.csv")
order_items = pd.read_csv("data/processed/order_items.csv")
products = pd.read_csv("data/processed/products.csv")

report_lines = []
report_lines.append("# Data Quality Report\n")

# =============================
# NULL CHECKS
# =============================

report_lines.append("## Null Checks\n")

report_lines.append("### Customers\n")
report_lines.append(customers.isnull().sum().to_markdown())

report_lines.append("\n### Orders\n")
report_lines.append(orders.isnull().sum().to_markdown())

report_lines.append("\n### Order Items\n")
report_lines.append(order_items.isnull().sum().to_markdown())

report_lines.append("\n### Products\n")
report_lines.append(products.isnull().sum().to_markdown())

# =============================
# DUPLICATES
# =============================

report_lines.append("\n## Duplicate Checks\n")
report_lines.append(f"- Customers duplicates: {customers.duplicated().sum()}")
report_lines.append(f"- Orders duplicates: {orders.duplicated().sum()}")
report_lines.append(f"- Order Items duplicates: {order_items.duplicated().sum()}")
report_lines.append(f"- Products duplicates: {products.duplicated().sum()}")

# =============================
# REVENUE VALIDATION
# =============================

order_items["calculated_revenue"] = order_items["price"] + order_items["freight_value"]
revenue_diff = (order_items["revenue"] - order_items["calculated_revenue"]).abs().sum()

report_lines.append("\n## Revenue Validation\n")

if revenue_diff == 0:
    report_lines.append("Revenue validation passed.")
else:
    report_lines.append("Revenue mismatch detected.")

# =============================
# DELIVERY VALIDATION
# =============================

orders["order_purchase_timestamp"] = pd.to_datetime(orders["order_purchase_timestamp"], errors="coerce")
orders["order_delivered_customer_date"] = pd.to_datetime(orders["order_delivered_customer_date"], errors="coerce")

invalid_delivery = orders[
    orders["order_delivered_customer_date"] < orders["order_purchase_timestamp"]
]

report_lines.append("\n## Delivery Validation\n")

if len(invalid_delivery) == 0:
    report_lines.append(" No negative delivery durations found.")
else:
    report_lines.append(f" Found {len(invalid_delivery)} invalid delivery records.")

# =============================
# WRITE FILE
# =============================

with open("docs/data_quality_report.md", "w", encoding="utf-8") as f:
    f.write("\n".join(report_lines))

print(" data_quality_report.md generated successfully.")
