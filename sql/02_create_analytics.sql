-- Create the schema first
CREATE SCHEMA IF NOT EXISTS analytics;

-- Dimension: Customers
DROP TABLE IF EXISTS analytics.dim_customers CASCADE;
CREATE TABLE analytics.dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_city TEXT,
    customer_state TEXT
);

-- Dimension: Products
DROP TABLE IF EXISTS analytics.dim_products CASCADE;
CREATE TABLE analytics.dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id TEXT,
    product_category_name TEXT
);

-- Dimension: Date
DROP TABLE IF EXISTS analytics.dim_date CASCADE;
CREATE TABLE analytics.dim_date (
    date_key DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

-- Dimension: Sellers
DROP TABLE IF EXISTS analytics.dim_sellers CASCADE;
CREATE TABLE analytics.dim_sellers (
    seller_key SERIAL PRIMARY KEY,
    seller_id TEXT,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

-- Dimension: Geolocation
DROP TABLE IF EXISTS analytics.dim_geolocation CASCADE;
CREATE TABLE analytics.dim_geolocation (
    geolocation_key SERIAL PRIMARY KEY,
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- Dimension: Product Category
DROP TABLE IF EXISTS analytics.dim_product_category CASCADE;
CREATE TABLE analytics.dim_product_category (
    category_key SERIAL PRIMARY KEY,
    product_category_name TEXT,
    product_category_name_english TEXT
);

-- Fact: Orders (Updated to connect to ALL dimensions)
DROP TABLE IF EXISTS analytics.fact_orders CASCADE;
CREATE TABLE analytics.fact_orders (
    order_id TEXT,
    customer_key INT,
    product_key INT,
    seller_key INT,          -- Connects to dim_sellers
    category_key INT,        -- Connects to dim_product_category
    geolocation_key INT,     -- Connects to dim_geolocation (via Seller Zip)
    date_key DATE,
    revenue NUMERIC
);
