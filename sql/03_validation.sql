-- Validating that total revenue is consistent across layers
SELECT
    (SELECT SUM(revenue) FROM staging.stg_order_revenue) AS staging_revenue,
    (SELECT SUM(revenue) FROM analytics.fact_orders) AS analytics_revenue;

-- Confirming the number of unique orders matches
SELECT
    (SELECT COUNT(DISTINCT order_id) FROM staging.stg_orders) AS staging_orders,
    (SELECT COUNT(DISTINCT order_id) FROM analytics.fact_orders) AS analytics_orders;


--Checking for duplicate primary keys in dim_customers
SELECT customer_key, COUNT(*)
FROM analytics.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- English Comment: Checking for duplicate primary keys in dim_products
SELECT product_key, COUNT(*)
FROM analytics.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

--Ensuring all foreign keys in fact_orders are valid
SELECT COUNT(*) AS invalid_customer_links
FROM analytics.fact_orders f
LEFT JOIN analytics.dim_customers c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
