import os

# 🔐 Set credentials FIRST
os.environ["KAGGLE_USERNAME"] = "celineelghorayeb"
os.environ["KAGGLE_KEY"] = "PUT_YOUR_NEW_KEY_HERE"

# ✅ Import AFTER setting environment variables
from kaggle.api.kaggle_api_extended import KaggleApi

def download_dataset():
    try:
        api = KaggleApi()
        api.authenticate()
        print("Authentication Successful!")

        download_path = r"C:\Users\HCES\OneDrive\Desktop\Olist-Analytics-Project\data\raw"
        os.makedirs(download_path, exist_ok=True)

        api.dataset_download_files(
            "olistbr/brazilian-ecommerce",
            path=download_path,
            unzip=True
        )

        print(f"Dataset downloaded to: {download_path}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    download_dataset()
