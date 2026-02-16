import pandas as pd

RAW_PATH = "data/raw/olist_geolocation_dataset.csv"
PROCESSED_PATH = "data/processed/geolocation.csv"

def clean_geolocation():
    df = pd.read_csv(RAW_PATH)

    # Drop rows with missing values
    df = df.dropna()

    # Remove duplicates by zip code
    df = df.drop_duplicates(subset=["geolocation_zip_code_prefix"])

    # Clean city & state
    df["geolocation_city"] = df["geolocation_city"].str.strip().str.title()
    df["geolocation_state"] = df["geolocation_state"].str.strip().str.upper()

    # Round coordinates
    df["geolocation_lat"] = df["geolocation_lat"].round(4)
    df["geolocation_lng"] = df["geolocation_lng"].round(4)

    df.to_csv(PROCESSED_PATH, index=False)
    print(" geolocation cleaned")

if __name__ == "__main__":
    clean_geolocation()
