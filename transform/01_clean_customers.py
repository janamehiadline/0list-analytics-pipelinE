import pandas as pd

# =============================
# Paths
# =============================
RAW_PATH = "data/raw/olist_customers_dataset.csv"
PROCESSED_PATH = "data/processed/customers.csv"

# =============================
# 1️⃣ Load the CSV safely
# =============================
df = pd.read_csv(
    RAW_PATH,
    quotechar='"',
    skipinitialspace=True
)

# =============================
# 2️⃣ Rename columns properly
# =============================
df.columns = [
    "customer_id",
    "customer_unique_id",
    "customer_zip_code_prefix",
    "customer_city",
    "customer_state"
]

# =============================
# 3️⃣ Remove extra spaces
# =============================
df["customer_city"] = df["customer_city"].str.strip()
df["customer_state"] = df["customer_state"].str.strip()

# =============================
# 4️⃣ Standardize text formatting
# =============================
df["customer_city"] = df["customer_city"].str.title()
df["customer_state"] = df["customer_state"].str.upper()

# =============================
# 5️⃣ Remove duplicates
# =============================
df = df.drop_duplicates()

# =============================
# 6️⃣ Check missing values
# =============================
print("Missing values:\n", df.isnull().sum())

# =============================
# 7️⃣ Convert ZIP code to string
# =============================
df["customer_zip_code_prefix"] = df["customer_zip_code_prefix"].astype(str)

# =============================
# 8️⃣ Save cleaned file
# =============================
df.to_csv(PROCESSED_PATH, index=False)

print("✅ Cleaning complete. File saved as customers.csv")

