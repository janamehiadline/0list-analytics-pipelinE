import pandas as pd

RAW_PATH = "data/raw/product_category_name_translation.csv"
PROCESSED_PATH = "data/processed/product_category_translation.csv"

def clean_category_translation():
    df = pd.read_csv(RAW_PATH)


    df = df.drop_duplicates()

   
    df = df.dropna(subset=["product_category_name"])

    #
    df["product_category_name"] = (
        df["product_category_name"]
        .astype(str)
        .str.strip()
        .str.lower()
        .str.replace("_", " ", regex=False)   
        .str.replace(r"\s+", " ", regex=True)  
    )

    
    df["product_category_name_english"] = (
        df["product_category_name_english"]
        .astype(str)
        .str.strip()
        .str.lower()
        .str.replace("_", " ", regex=False)
        .str.replace(r"\s+", " ", regex=True)
    )

    df.to_csv(PROCESSED_PATH, index=False)
    print(" product_category_translation cleaned successfully")

if __name__ == "__main__":
    clean_category_translation()
