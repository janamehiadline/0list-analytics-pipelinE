import pandas as pd

# =============================
# Paths
# =============================
RAW_PATH = "data/raw/olist_order_items_dataset.csv"
PROCESSED_PATH = "data/processed/order_items.csv"

# =============================
# 1️⃣ Load CSV safely
# =============================
df = pd.read_csv(RAW_PATH, quotechar='"', skipinitialspace=True)

# =============================
# 2️⃣ Strip spaces from string columns
# =============================
str_cols = ["order_id", "order_item_id", "product_id", "seller_id", "shipping_limit_date"]

for col in str_cols:
    df[col] = df[col].astype(str).str.strip()

# =============================
# 3️⃣ Convert numeric columns properly
# =============================
num_cols = ["price", "freight_value"]

for col in num_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# =============================
# 4️⃣ Drop rows where price or freight_value is NaN
# =============================
df = df.dropna(subset=num_cols)

# =============================
# 5️⃣ Remove rows with negative or zero price/freight
# =============================
df = df[(df["price"] > 0) & (df["freight_value"] >= 0)]

# =============================
# 6️⃣ Reset index
# =============================
df = df.reset_index(drop=True)

# =============================
# 7️⃣ Save cleaned CSV
# =============================
df.to_csv(PROCESSED_PATH, index=False)

print("✅ Cleaning complete. File saved as order_items.csv")


