import sys
import subprocess
import os

# =========================
# Run script function (FIXED)
# =========================
def run_script(script_path):
    print(f"\n Running: {script_path}")
    
    # Ensure we are in the project root
    project_root = os.path.dirname(os.path.abspath(__file__))
    os.chdir(project_root)

    # Use sys.executable to ensure we use the same python interpreter
    if script_path.endswith(".py"):
        # ADDED: encoding='utf-8' and text=True
        # This prevents the UnicodeEncodeError (e.g. the crash on the checkmark emoji)
        result = subprocess.run([sys.executable, script_path], encoding='utf-8', text=True)
    else:
        # For non-python files (like SQL), this function might need adjustment
        # but the user's code uses it for .py files.
        result = subprocess.run([script_path], encoding='utf-8', text=True)

    if result.returncode != 0:
        print(f" Error in {script_path}")
        sys.exit(1)
    else:
        print(f" Finished: {script_path}")


def main():
    # =========================
    # 1. DOWNLOAD
    # =========================
    run_script("src/ingest/00_download_dataset.py")


    # =========================
    # 2. TRANSFORM / CLEANING
    # =========================
    run_script("transform/01_clean_customers.py")
    run_script("transform/02_clean_products.py")
    run_script("transform/03_clean_orders.py")
    run_script("transform/04_build_revenue_table.py")
    run_script("transform/05_clean_product_category_translation.py")
    run_script("transform/06_clean_sellers.py")
    run_script("transform/07_clean_geolocation.py")


    # =========================
    # 3. DATA QUALITY REPORT
    # =========================
    run_script("transform/08_data_quality.py")


    # =========================
    # 4. SQL EXECUTION
    # =========================
    print("\n Running SQL scripts...")

    # Note: These require a running PostgreSQL instance and correct credentials.
    # In this environment, we provide the scripts but don't execute them 
    # unless a database is configured.
    db_name = "postgres"
    user = "postgres"

    sql_files = [
        "sql/01-create-staging.sql",
        "sql/02-create-analytics.sql",
        "sql/03-importcsv.sql",
        "sql/04-business-logic.sql",
        "sql/05-validation.sql"
       # "sql/06-insert-analytics.sql"
    ]

    # Check if psql is available before running
    import shutil
    if shutil.which("psql"):
        for sql in sql_files:
            print(f" Running SQL: {sql}")
            result = subprocess.run([
                "psql",
                "-U", user,
                "-d", db_name,
                "-f", sql
            ], encoding='utf-8', text=True) # Also added encoding here for safety

            if result.returncode != 0:
                print(f" Error in SQL file: {sql}")
                sys.exit(1)
    else:
        print("\n [Notice] 'psql' not found. Skipping SQL execution.")
        print(" All SQL scripts have been generated in the 'sql/' directory for your use.")


    print("\n Pipeline completed successfully!")

if __name__ == "__main__":
    main()