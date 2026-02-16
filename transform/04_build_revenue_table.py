import pandas as pd

# Paths
raw_path = r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\raw\olist_order_items_dataset.csv"
processed_path = r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\processed\order_items.csv"  # Updated filename

# Load CSV safely, skip bad lines
df = pd.read_csv(raw_path, quotechar='"', skipinitialspace=True, on_bad_lines='skip')

# Strip extra spaces from string columns
for col in df.select_dtypes(include='object').columns:
    df[col] = df[col].str.strip()

# Convert numeric columns to proper type
numeric_cols = ["price", "freight_value", "order_item_id"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce')

# Remove rows with missing critical data
df.dropna(subset=["order_id", "order_item_id", "product_id", "seller_id", "price", "freight_value"], inplace=True)

# Reset index
df.reset_index(drop=True, inplace=True)

# Add revenue column and round to 2 decimals
df["revenue"] = (df["price"] + df["freight_value"]).round(2)

# Save cleaned CSV
df.to_csv(processed_path, index=False)

print(f"Cleaned CSV with revenue saved to: {processed_path}")


