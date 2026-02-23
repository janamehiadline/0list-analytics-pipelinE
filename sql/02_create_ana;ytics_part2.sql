-- 1. CLEANUP: Reset existing tables to avoid duplicate key errors

TRUNCATE TABLE analytics.dim_sellers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_geolocation RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_product_category RESTART IDENTITY CASCADE;


-- 2. DIMENSION TABLE: Sellers

INSERT INTO analytics.dim_sellers (seller_id, seller_city, seller_state)
SELECT DISTINCT seller_id, seller_city, seller_state
FROM staging.stg_sellers;


-- 3. DIMENSION TABLE: Geolocation

INSERT INTO analytics.dim_geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
SELECT DISTINCT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
FROM staging.stg_geolocation;


-- 4. DIMENSION TABLE: Product Category

INSERT INTO analytics.dim_product_category (product_category_name, product_category_name_english)
SELECT DISTINCT product_category_name, product_category_name_english
FROM staging.stg_product_category_translation;