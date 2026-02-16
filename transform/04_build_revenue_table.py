import pandas as pd
import os


raw_path = os.path.join("data", "raw", "olist_order_items_dataset.csv")
processed_path = os.path.join("data", "processed", "order_items.csv")

os.makedirs(os.path.dirname(processed_path), exist_ok=True)

df = pd.read_csv(
    raw_path,
    quotechar='"',
    skipinitialspace=True,
    on_bad_lines='skip'
)

for col in df.select_dtypes(include='object').columns:
    df[col] = df[col].str.strip()


numeric_cols = ["price", "freight_value", "order_item_id"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce')

df.dropna(
    subset=["order_id", "order_item_id", "product_id", "seller_id", "price", "freight_value"],
    inplace=True
)

# Reset index
df.reset_index(drop=True, inplace=True)

# Add revenue column and round to 2 decimals
df["revenue"] = (df["price"] + df["freight_value"]).round(2)

# Save cleaned CSV
df.to_csv(processed_path, index=False)

print(f"✅ Cleaned CSV with revenue saved to: {processed_path}")
