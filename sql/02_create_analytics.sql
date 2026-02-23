-
-- 1. CLEANUP: Reset existing tables to avoid duplicate key errors

TRUNCATE TABLE analytics.fact_orders RESTART IDENTITY;
TRUNCATE TABLE analytics.dim_customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_products RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_date RESTART IDENTITY;


-- 2. DIMENSION TABLE: Customers

INSERT INTO analytics.dim_customers (customer_id, customer_unique_id, customer_city, customer_state)
SELECT DISTINCT customer_id, customer_unique_id, customer_city, customer_state
FROM staging.stg_customers;


-- 3. DIMENSION TABLE: Products

INSERT INTO analytics.dim_products (product_id, product_category_name)
SELECT DISTINCT product_id, product_category_name
FROM staging.stg_products;


-- 4. DIMENSION TABLE: Date

INSERT INTO analytics.dim_date (date_key, year, month, day)
SELECT DISTINCT
    DATE(order_purchase_timestamp::TIMESTAMP) AS date_key,
    EXTRACT(YEAR FROM order_purchase_timestamp::TIMESTAMP),
    EXTRACT(MONTH FROM order_purchase_timestamp::TIMESTAMP),
    EXTRACT(DAY FROM order_purchase_timestamp::TIMESTAMP)
FROM staging.stg_orders
WHERE order_purchase_timestamp IS NOT NULL;

-
-- 5. FACT TABLE: Orders

INSERT INTO analytics.fact_orders (
    order_id, 
    customer_key, 
    product_key, 
    date_key, 
    revenue
)
SELECT
    r.order_id,
    c.customer_key,
    p.product_key,
    DATE(o.order_purchase_timestamp::TIMESTAMP),
    r.revenue
FROM staging.stg_order_revenue r
JOIN staging.stg_orders o 
    ON r.order_id = o.order_id
JOIN analytics.dim_customers c 
    ON o.customer_id = c.customer_id
JOIN analytics.dim_products p 
    ON r.product_id = p.product_id;