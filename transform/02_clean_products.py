import pandas as pd

# 1️⃣ Load CSV safely
file_path = r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\raw\olist_products_dataset.csv"
df = pd.read_csv(file_path, quotechar='"', skipinitialspace=True)

# 2️⃣ Strip spaces from string columns
str_cols = ["product_id", "product_category_name"]
for col in str_cols:
    df[col] = df[col].astype(str).str.strip()

# 3️⃣ Convert numeric columns to proper types, coerce errors
num_cols = [
    "product_name_lenght", "product_description_lenght",
    "product_photos_qty", "product_weight_g",
    "product_length_cm", "product_height_cm", "product_width_cm"
]

for col in num_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce')

# 4️⃣ Drop completely empty rows (if all numeric columns are NaN)
df = df.dropna(subset=num_cols, how='all')

# 5️⃣ Fill missing category names with 'unknown'
df["product_category_name"] = df["product_category_name"].replace({'nan': 'unknown'})

# 6️⃣ Remove rows with impossible values (zero or negative)
df = df[
    (df["product_photos_qty"] > 0) &
    (df["product_weight_g"] > 0) &
    (df["product_length_cm"] > 0) &
    (df["product_height_cm"] > 0) &
    (df["product_width_cm"] > 0)
]

# 7️⃣ Reset index
df = df.reset_index(drop=True)

# 8️⃣ Save cleaned CSV in the processed folder as products.csv
cleaned_path = r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\processed\products.csv"
df.to_csv(cleaned_path, index=False)

print(f"Cleaned products CSV saved to: {cleaned_path}")


