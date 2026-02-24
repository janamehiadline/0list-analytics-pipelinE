-- Create the schema first
CREATE SCHEMA IF NOT EXISTS staging;

-- 1. Customers
DROP TABLE IF EXISTS staging.stg_customers CASCADE;
CREATE TABLE staging.stg_customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

-- 2. Products
DROP TABLE IF EXISTS staging.stg_products CASCADE;
CREATE TABLE staging.stg_products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght TEXT,        
    product_description_lenght TEXT, 
    product_photos_qty TEXT,          
    product_weight_g TEXT,        
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);

-- 3. Orders 
DROP TABLE IF EXISTS staging.stg_orders CASCADE;
CREATE TABLE staging.stg_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,         
    order_delivered_carrier_date TIMESTAMP, 
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    delivery_duration_days NUMERIC,
    payment_type TEXT,
    payment_installments NUMERIC,  -- <--- CHANGED TO NUMERIC
    payment_value NUMERIC,
    review_id TEXT,
    review_score NUMERIC
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 4. Order Revenue 
DROP TABLE IF EXISTS staging.stg_order_revenue CASCADE;
CREATE TABLE staging.stg_order_revenue (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    revenue NUMERIC
);

-- 5. Geolocation
DROP TABLE IF EXISTS staging.stg_geolocation CASCADE;
CREATE TABLE staging.stg_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- 6. Product Category Translation
DROP TABLE IF EXISTS staging.stg_product_category_translation CASCADE;
CREATE TABLE staging.stg_product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);

-- 7. Sellers
DROP TABLE IF EXISTS staging.stg_sellers CASCADE;
CREATE TABLE staging.stg_sellers (
    seller_id TEXT,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);