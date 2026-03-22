-- 1. CLEANUP
TRUNCATE TABLE analytics.fact_orders RESTART IDENTITY;
TRUNCATE TABLE analytics.dim_customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_products RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_date RESTART IDENTITY;
TRUNCATE TABLE analytics.dim_sellers RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.dim_product_category RESTART IDENTITY CASCADE;

-- 2. LOAD DIMENSIONS
INSERT INTO analytics.dim_customers (customer_id, customer_unique_id, customer_city, customer_state)
SELECT DISTINCT customer_id, customer_unique_id, customer_city, customer_state FROM staging.stg_customers;

INSERT INTO analytics.dim_products (product_id, product_category_name)
SELECT DISTINCT product_id, product_category_name FROM staging.stg_products;

INSERT INTO analytics.dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT DISTINCT seller_id, seller_zip_code_prefix, seller_city, seller_state FROM staging.stg_sellers;

INSERT INTO analytics.dim_product_category (product_category_name, product_category_name_english)
SELECT DISTINCT product_category_name, product_category_name_english FROM staging.stg_product_category_translation;

INSERT INTO analytics.dim_date (date_key, year, month, day)
SELECT DISTINCT DATE(order_purchase_timestamp)::DATE, EXTRACT(YEAR FROM order_purchase_timestamp)::INT, EXTRACT(MONTH FROM order_purchase_timestamp)::INT, EXTRACT(DAY FROM order_purchase_timestamp)::INT
FROM staging.stg_orders WHERE order_purchase_timestamp IS NOT NULL;

-- 3. LOAD FACT TABLE (The Correct Way)
INSERT INTO analytics.fact_orders (order_id, customer_key, product_key, seller_key, category_key, date_key, revenue)
SELECT 
    o.order_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    cat.category_key,
    DATE(o.order_purchase_timestamp)::DATE,
    COALESCE(rev.total_revenue, 0)
FROM staging.stg_orders o
LEFT JOIN (
    SELECT order_id, SUM(revenue) as total_revenue 
    FROM staging.stg_order_revenue 
    GROUP BY order_id
) rev ON o.order_id = rev.order_id
LEFT JOIN staging.stg_order_revenue sor ON o.order_id = sor.order_id
LEFT JOIN analytics.dim_customers c ON o.customer_id = c.customer_id
LEFT JOIN analytics.dim_products p ON sor.product_id = p.product_id
LEFT JOIN analytics.dim_sellers s ON sor.seller_id = s.seller_id
LEFT JOIN analytics.dim_product_category cat ON p.product_category_name = cat.product_category_name
ON CONFLICT DO NOTHING;