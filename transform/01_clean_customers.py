import pandas as pd

# 1️⃣ Load the CSV safely
df = pd.read_csv(
    r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\raw\olist_customers_dataset.csv",
    quotechar='"',
    skipinitialspace=True
)

# 2️⃣ Rename columns properly (if header is broken)
df.columns = [
    "customer_id",
    "customer_unique_id",
    "customer_zip_code_prefix",
    "customer_city",
    "customer_state"
]

# 3️⃣ Remove extra spaces
df["customer_city"] = df["customer_city"].str.strip()
df["customer_state"] = df["customer_state"].str.strip()

# 4️⃣ Standardize text formatting
df["customer_city"] = df["customer_city"].str.title()
df["customer_state"] = df["customer_state"].str.upper()

# 5️⃣ Remove duplicates
df = df.drop_duplicates()

# 6️⃣ Check missing values
print("Missing values:\n", df.isnull().sum())

# 7️⃣ Convert ZIP code to string (important!)
df["customer_zip_code_prefix"] = df["customer_zip_code_prefix"].astype(str)

# 8️⃣ Save cleaned file as customers.csv
df.to_csv(
    r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\processed\customers.csv",
    index=False
)

print("✅ Cleaning complete. File saved as customers.csv")
