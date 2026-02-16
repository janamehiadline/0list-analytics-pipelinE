import pandas as pd

RAW_PATH = "data/raw/olist_sellers_dataset.csv"
PROCESSED_PATH = "data/processed/sellers.csv"

def clean_sellers():
    df = pd.read_csv(RAW_PATH)

    
    df = df.drop_duplicates(subset=["seller_id"])

    
    df["seller_city"] = df["seller_city"].str.strip().str.title()
    df["seller_state"] = df["seller_state"].str.strip().str.upper()

    df.to_csv(PROCESSED_PATH, index=False)
    print(" sellers cleaned")

if __name__ == "__main__":
    clean_sellers()
