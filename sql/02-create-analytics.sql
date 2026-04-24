 /* ============================================
   SCHEMA: ANALYTICS
   ============================================ */
CREATE SCHEMA IF NOT EXISTS analytics;

-- 1. CUSTOMERS DIMENSION
DROP TABLE IF EXISTS analytics.dim_customers CASCADE;

CREATE TABLE analytics.dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id TEXT UNIQUE,
    customer_unique_id TEXT,
    customer_city TEXT,
    customer_state TEXT
);

-- 2. PRODUCTS DIMENSION
DROP TABLE IF EXISTS analytics.dim_products CASCADE;

CREATE TABLE analytics.dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id TEXT UNIQUE,
    product_category_name TEXT
);

-- 3. SELLERS DIMENSION
DROP TABLE IF EXISTS analytics.dim_sellers CASCADE;

CREATE TABLE analytics.dim_sellers (
    seller_key SERIAL PRIMARY KEY,
    seller_id TEXT UNIQUE,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

-- 4. DATE DIMENSION
DROP TABLE IF EXISTS analytics.dim_date CASCADE;

CREATE TABLE analytics.dim_date (
    date_key DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

-- 5. GEOLOCATION DIMENSION
DROP TABLE IF EXISTS analytics.dim_geolocation CASCADE;

CREATE TABLE analytics.dim_geolocation (
    geolocation_key SERIAL PRIMARY KEY,
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- 6. PRODUCT CATEGORY DIMENSION
DROP TABLE IF EXISTS analytics.dim_product_category CASCADE;

CREATE TABLE analytics.dim_product_category (
    category_key SERIAL PRIMARY KEY,
    product_category_name TEXT UNIQUE,
    product_category_name_english TEXT
);


/* ============================================
   FACT TABLES
   ============================================ */

-- 1. ORDERS FACT
DROP TABLE IF EXISTS analytics.fact_orders CASCADE;

CREATE TABLE analytics.fact_orders (
    fact_id SERIAL PRIMARY KEY,
    order_id TEXT,
    
    -- Foreign Keys
    customer_key INT,
    product_key INT,
    seller_key INT,
    category_key INT,
    
    date_key DATE,
    
    -- Measures
    revenue NUMERIC,

    -- Constraints
    CONSTRAINT fk_customer FOREIGN KEY (customer_key) 
        REFERENCES analytics.dim_customers (customer_key),
        
    CONSTRAINT fk_product FOREIGN KEY (product_key) 
        REFERENCES analytics.dim_products (product_key),
        
    CONSTRAINT fk_seller FOREIGN KEY (seller_key) 
        REFERENCES analytics.dim_sellers (seller_key),
        
    CONSTRAINT fk_category FOREIGN KEY (category_key) 
        REFERENCES analytics.dim_product_category (category_key),
    
        
    CONSTRAINT fk_date FOREIGN KEY (date_key) 
        REFERENCES analytics.dim_date (date_key)
);