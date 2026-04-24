import pandas as pd
import os

raw_folder = os.path.join("data", "raw")
processed_folder = os.path.join("data", "processed")

os.makedirs(processed_folder, exist_ok=True)

orders = pd.read_csv(
    os.path.join(raw_folder, "olist_orders_dataset.csv"),
    parse_dates=[
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ]
)
orders['order_status'] = orders['order_status'].str.strip()


orders['delivery_duration_days'] = (
    orders['order_delivered_customer_date'] - orders['order_purchase_timestamp']
).dt.days

negative_deliveries = orders[orders['delivery_duration_days'] < 0]
if not negative_deliveries.empty:
    print(" Negative delivery durations found. Here are the rows:")
    print(negative_deliveries)
else:
    print(" No negative delivery durations found.")

payments = pd.read_csv(
    os.path.join(raw_folder, "olist_order_payments_dataset.csv")
)
payments['payment_type'] = payments['payment_type'].str.strip()
payments['payment_value'] = pd.to_numeric(payments['payment_value'], errors='coerce')
payments['payment_installments'] = pd.to_numeric(
    payments['payment_installments'], errors='coerce'
)


payments_agg = payments.groupby('order_id').agg({
    'payment_type': lambda x: ','.join(x.unique()),
    'payment_installments': 'sum',
    'payment_value': 'sum'
}).reset_index()


reviews = pd.read_csv(
    os.path.join(raw_folder, "olist_order_reviews_dataset.csv"),
    parse_dates=["review_creation_date", "review_answer_timestamp"]
)
reviews['review_comment_title'] = reviews['review_comment_title'].fillna("").str.strip()
reviews['review_comment_message'] = reviews['review_comment_message'].fillna("").str.strip()
reviews['review_score'] = pd.to_numeric(reviews['review_score'], errors='coerce')

orders_combined = orders.merge(payments_agg, on='order_id', how='left')
orders_combined = orders_combined.merge(reviews, on='order_id', how='left')


orders_combined.to_csv(
    os.path.join(processed_folder, "orders.csv"),
    index=False
)

print("All cleaned data merged and saved as 'orders.csv'!")
