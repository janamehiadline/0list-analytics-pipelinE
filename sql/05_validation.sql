

-- 1️⃣ Validating that total revenue is consistent across layers
SELECT
    (SELECT COALESCE(SUM(revenue), 0) FROM staging.stg_order_revenue) AS staging_revenue,
    (SELECT COALESCE(SUM(revenue), 0) FROM analytics.fact_orders) AS analytics_revenue;


-- 2️⃣ Confirming the number of unique orders matches
SELECT
    (SELECT COUNT(DISTINCT order_id) FROM staging.stg_orders) AS staging_orders,
    (SELECT COUNT(DISTINCT order_id) FROM analytics.fact_orders) AS analytics_orders;


-- 3️⃣ Checking for duplicate primary keys in dim_customers
SELECT customer_key, COUNT(*) AS count
FROM analytics.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- 4️⃣ Checking for duplicate primary keys in dim_products
SELECT product_key, COUNT(*) AS count
FROM analytics.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- 5️⃣ Ensuring all foreign keys in fact_orders are valid (Customer)
SELECT COUNT(*) AS invalid_customer_links
FROM analytics.fact_orders f
LEFT JOIN analytics.dim_customers c 
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;


-- 6️⃣ Ensuring Seller Keys are valid
SELECT COUNT(*) AS invalid_seller_links
FROM analytics.fact_orders f
LEFT JOIN analytics.dim_sellers s 
    ON f.seller_key = s.seller_key
WHERE s.seller_key IS NULL 
  AND f.seller_key IS NOT NULL;


-- 7️⃣ NEW: Ensuring Product Keys are valid
SELECT COUNT(*) AS invalid_product_links
FROM analytics.fact_orders f
LEFT JOIN analytics.dim_products p 
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL 
  AND f.product_key IS NOT NULL;


-- 8️⃣ NEW: Checking for NULL foreign keys in fact table
SELECT 
    COUNT(*) FILTER (WHERE customer_key IS NULL) AS null_customers,
    COUNT(*) FILTER (WHERE seller_key IS NULL)   AS null_sellers,
    COUNT(*) FILTER (WHERE product_key IS NULL)  AS null_products
FROM analytics.fact_orders;


-- 9️⃣ NEW: Checking grain consistency (duplicate fact rows)
-- Ensures each order-product combination appears only once
SELECT order_id, product_key, COUNT(*) AS duplicate_count
FROM analytics.fact_orders
GROUP BY order_id, product_key
HAVING COUNT(*) > 1;


-- 🔟 NEW: Ensuring fact table has no orphan order_ids
SELECT COUNT(*) AS invalid_order_ids
FROM analytics.fact_orders f
LEFT JOIN staging.stg_orders s 
    ON f.order_id = s.order_id
WHERE s.order_id IS NULL;