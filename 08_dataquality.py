import pandas as pd

# =========================
# Load processed datasets
# =========================
customers = pd.read_csv("data/processed/customers.csv")
orders = pd.read_csv("data/processed/orders.csv")
order_items = pd.read_csv("data/processed/order_items.csv")
products = pd.read_csv("data/processed/products.csv")
sellers = pd.read_csv("data/processed/sellers.csv")
geolocation = pd.read_csv("data/processed/geolocation.csv")
category_translation = pd.read_csv("data/processed/product_category_translation.csv")

report_lines = []
report_lines.append("# Data Quality Report\n")

report_lines.append("## Null Checks\n")

def null_check(df, name):
    report_lines.append(f"### {name}")
    report_lines.append(df.isnull().sum().to_markdown())
    report_lines.append("")

null_check(customers, "Customers")
null_check(orders, "Orders")
null_check(order_items, "Order Items")
null_check(products, "Products")
null_check(sellers, "Sellers")
null_check(geolocation, "Geolocation")
null_check(category_translation, "Product Category Translation")


report_lines.append("\n## Duplicate Checks\n")

report_lines.append(f"- Customers duplicate customer_id: {customers.duplicated('customer_id').sum()}")
report_lines.append(f"- Orders duplicate order_id: {orders.duplicated('order_id').sum()}")
report_lines.append(f"- Order Items duplicate (order_id, product_id): {order_items.duplicated(['order_id', 'product_id']).sum()}")
report_lines.append(f"- Products duplicate product_id: {products.duplicated('product_id').sum()}")
report_lines.append(f"- Sellers duplicate seller_id: {sellers.duplicated('seller_id').sum()}")
report_lines.append(f"- Geolocation duplicate zip_code_prefix: {geolocation.duplicated('geolocation_zip_code_prefix').sum()}")
report_lines.append(f"- Category duplicate product_category_name: {category_translation.duplicated('product_category_name').sum()}")

report_lines.append("\n## Revenue Validation\n")

order_items["calculated_revenue"] = (
    order_items["price"] + order_items["freight_value"]
)

negative_revenue = (order_items["calculated_revenue"] < 0).sum()

if negative_revenue == 0:
    report_lines.append(" No negative revenue values found.")
else:
    report_lines.append(f" {negative_revenue} negative revenue records found.")


report_lines.append("\n## Delivery Validation\n")

orders["order_purchase_timestamp"] = pd.to_datetime(
    orders["order_purchase_timestamp"], errors="coerce"
)
orders["order_delivered_customer_date"] = pd.to_datetime(
    orders["order_delivered_customer_date"], errors="coerce"
)

orders["delivery_days"] = (
    orders["order_delivered_customer_date"] -
    orders["order_purchase_timestamp"]
).dt.days

invalid_delivery = orders[orders["delivery_days"] < 0]

if len(invalid_delivery) == 0:
    report_lines.append("No negative delivery durations found.")
else:
    report_lines.append(f" {len(invalid_delivery)} orders with negative delivery duration.")


with open("docs/data_quality_report.md", "w", encoding="utf-8") as f:
    f.write("\n".join(report_lines))

print(" data_quality_report.md generated successfully.")
