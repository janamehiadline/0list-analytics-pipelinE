-- 5. Geolocation (New)
CREATE TABLE IF NOT EXISTS staging.stg_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- 6. Product Category Translation (New)
CREATE TABLE IF NOT EXISTS staging.stg_product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);

-- 7. Sellers (New)
CREATE TABLE IF NOT EXISTS staging.stg_sellers (
    seller_id TEXT,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);