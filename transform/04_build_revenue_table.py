import pandas as pd
import os

# Define paths
raw_path = os.path.join("data", "raw", "olist_order_items_dataset.csv")
processed_path = os.path.join("data", "processed", "order_items.csv")

# Ensure processed folder exists
os.makedirs(os.path.dirname(processed_path), exist_ok=True)

# Load the dataset
df = pd.read_csv(
    raw_path,
    parse_dates=["shipping_limit_date"],
    quotechar='"',
    skipinitialspace=True,
    on_bad_lines='skip'
)

# 1. Clean Strings
for col in df.select_dtypes(include='object').columns:
    df[col] = df[col].str.strip()

# 2. Convert Numeric Columns
numeric_cols = ["price", "freight_value", "order_item_id"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce')

# 3. Drop rows with missing critical data
df.dropna(
    subset=["order_id", "order_item_id", "product_id", "seller_id", "price", "freight_value"],
    inplace=True
)

# 4. HANDLE DUPLICATES
df = df.groupby(['order_id', 'product_id', 'seller_id', 'shipping_limit_date']).agg({
    'order_item_id': 'first', 
    'price': 'sum',           
    'freight_value': 'sum'    
}).reset_index()

# 5. Calculate Revenue
df["revenue"] = (df["price"] + df["freight_value"]).round(2)

# 6. FORCE CORRECT COLUMN ORDER
# This MUST match the SQL table structure exactly.
# order_item_id (Integer) MUST be first.
desired_columns = [
    'order_item_id',
    'order_id',
    'product_id',
    'seller_id',
    'shipping_limit_date',
    'price',
    'freight_value',
    'revenue'
]

df = df[desired_columns]

# 7. DEBUG PRINT: Check if order_item_id is first
print("CHECKING COLUMN ORDER IN DATAFRAME:")
print(df.columns.tolist())

# 8. Save
df.to_csv(processed_path, index=False)
print(f" Cleaned CSV with revenue saved to: {processed_path}")