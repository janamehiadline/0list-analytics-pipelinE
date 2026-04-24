-- 1. Customers
\copy staging.stg_customers FROM 'data/processed/customers.csv' DELIMITER ',' CSV HEADER;

-- 2. Products
\copy staging.stg_products FROM 'data/processed/products.csv' DELIMITER ',' CSV HEADER;

-- 3. Orders
\copy staging.stg_orders FROM 'data/processed/orders.csv' DELIMITER ',' CSV HEADER;

-- 4. Order Revenue
\copy staging.stg_order_revenue FROM 'data/processed/order_items.csv' DELIMITER ',' CSV HEADER;

-- 5. Geolocation
\copy staging.stg_geolocation FROM 'data/processed/geolocation.csv' DELIMITER ',' CSV HEADER;

-- 6. Product Category Translation
\copy staging.stg_product_category_translation FROM 'data/processed/product_category_translation.csv' DELIMITER ',' CSV HEADER;

-- 7. Sellers
\copy staging.stg_sellers FROM 'data/processed/sellers.csv' DELIMITER ',' CSV HEADER;