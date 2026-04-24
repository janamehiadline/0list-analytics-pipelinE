-- 1. Customers
TRUNCATE TABLE analytics.dim_customers CASCADE;
INSERT INTO analytics.dim_customers (customer_id, customer_unique_id, customer_city, customer_state)
SELECT DISTINCT customer_id, customer_unique_id, customer_city, customer_state
FROM staging.stg_customers;

-- 2. Products
TRUNCATE TABLE analytics.dim_products CASCADE;
INSERT INTO analytics.dim_products (product_id, product_category_name)
SELECT DISTINCT product_id, product_category_name
FROM staging.stg_products;

-- 3. Sellers
TRUNCATE TABLE analytics.dim_sellers CASCADE;
INSERT INTO analytics.dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT DISTINCT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM staging.stg_sellers;

-- 4. Product Category Translation
TRUNCATE TABLE analytics.dim_product_category CASCADE;
INSERT INTO analytics.dim_product_category (product_category_name, product_category_name_english)
SELECT DISTINCT product_category_name, product_category_name_english
FROM staging.stg_product_category_translation;

-- 5. Date Dimension (Crucial: Create all dates present in orders)
TRUNCATE TABLE analytics.dim_date CASCADE;
INSERT INTO analytics.dim_date (date_key, year, month, day)
SELECT DISTINCT
    DATE(order_purchase_timestamp)::DATE,
    EXTRACT(YEAR FROM order_purchase_timestamp)::INT,
    EXTRACT(MONTH FROM order_purchase_timestamp)::INT,
    EXTRACT(DAY FROM order_purchase_timestamp)::INT
FROM staging.stg_orders
WHERE order_purchase_timestamp IS NOT NULL;

TRUNCATE TABLE analytics.fact_orders RESTART IDENTITY CASCADE;

-- We use a CTE (Common Table Expression) to calculate revenue properly first
WITH Order_Revenue_Final AS (
    SELECT 
        order_id,
        SUM(price + freight_value) as total_rev
    FROM staging.stg_order_revenue
    GROUP BY order_id
)

INSERT INTO analytics.fact_orders (
    order_id,
    customer_key,
    product_key,
    seller_key,
    category_key,
    date_key,
    revenue
)
SELECT DISTINCT ON (o.order_id)
    o.order_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    cat.category_key, 
    DATE(o.order_purchase_timestamp)::DATE,
    r.total_rev
FROM staging.stg_orders o
-- 1. Join the calculated Revenue
INNER JOIN Order_Revenue_Final r ON o.order_id = r.order_id
-- 2. Join Revenue table to get Product/Seller IDs
INNER JOIN staging.stg_order_revenue sor ON o.order_id = sor.order_id
-- 3. Join Dimensions (Using LEFT JOIN ensures data loads even if a dim is missing)
LEFT JOIN analytics.dim_customers c ON o.customer_id = c.customer_id
LEFT JOIN analytics.dim_products p ON sor.product_id = p.product_id
LEFT JOIN analytics.dim_sellers s ON sor.seller_id = s.seller_id
LEFT JOIN analytics.dim_product_category cat ON p.product_category_name = cat.product_category_name
-- 4. Join Date Dimension (LEFT JOIN to prevent the "Total Failure" you saw before)
LEFT JOIN analytics.dim_date d ON DATE(o.order_purchase_timestamp) = d.date_key
ORDER BY o.order_id, sor.price DESC;
