-- 1. CLEANUP: Reset tables for fresh load
TRUNCATE TABLE analytics.fact_orders RESTART IDENTITY;
TRUNCATE TABLE analytics.dim_customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_products RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_date RESTART IDENTITY;
TRUNCATE TABLE analytics.dim_sellers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_geolocation RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_product_category RESTART IDENTITY CASCADE;

-- 2. LOAD DIMENSION: Customers
INSERT INTO analytics.dim_customers (customer_id, customer_unique_id, customer_city, customer_state)
SELECT DISTINCT customer_id, customer_unique_id, customer_city, customer_state
FROM staging.stg_customers;

-- 3. LOAD DIMENSION: Products
INSERT INTO analytics.dim_products (product_id, product_category_name)
SELECT DISTINCT product_id, product_category_name
FROM staging.stg_products;

-- 4. LOAD DIMENSION: Date
INSERT INTO analytics.dim_date (date_key, year, month, day)
SELECT DISTINCT
    DATE(order_purchase_timestamp)::DATE AS date_key,
    EXTRACT(YEAR FROM order_purchase_timestamp)::INT,
    EXTRACT(MONTH FROM order_purchase_timestamp)::INT,
    EXTRACT(DAY FROM order_purchase_timestamp)::INT
FROM staging.stg_orders
WHERE order_purchase_timestamp IS NOT NULL;

-- 5. LOAD DIMENSION: Sellers
INSERT INTO analytics.dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT DISTINCT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM staging.stg_sellers;

-- 6. LOAD DIMENSION: Geolocation
-- We use DISTINCT ON to ensure one key per Zip Code for easier joining
INSERT INTO analytics.dim_geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
SELECT DISTINCT ON (geolocation_zip_code_prefix) geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
FROM staging.stg_geolocation;

-- 7. LOAD DIMENSION: Product Category
INSERT INTO analytics.dim_product_category (product_category_name, product_category_name_english)
SELECT DISTINCT product_category_name, product_category_name_english
FROM staging.stg_product_category_translation;

-- 8. LOAD FACT TABLE: Orders (Fully Connected)
INSERT INTO analytics.fact_orders (
    order_id, 
    customer_key, 
    product_key, 
    seller_key,
    category_key,
    geolocation_key,
    date_key, 
    revenue
)
SELECT
    r.order_id,
    c.customer_key,
    p.product_key,
    s.seller_key,                                           -- Get Seller Key
    cat.category_key,                                        -- Get Category Key
    geo.geolocation_key,                                     -- Get Geo Key (via Seller Zip)
    DATE(o.order_purchase_timestamp)::DATE,
    r.revenue
FROM staging.stg_order_revenue r
JOIN staging.stg_orders o 
    ON r.order_id = o.order_id
JOIN analytics.dim_customers c 
    ON o.customer_id = c.customer_id
JOIN analytics.dim_products p 
    ON r.product_id = p.product_id
JOIN analytics.dim_sellers s 
    ON r.seller_id = s.seller_id
LEFT JOIN analytics.dim_product_category cat 
    ON p.product_category_name = cat.product_category_name
LEFT JOIN analytics.dim_geolocation geo 
    ON s.seller_zip_code_prefix = geo.geolocation_zip_code_prefix;

