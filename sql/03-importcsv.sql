-- 1. Customers
COPY staging.stg_customers FROM 'C:/processed/customers.csv' DELIMITER ',' CSV HEADER;

-- 2. Products
COPY staging.stg_products FROM 'C:/processed/products.csv' DELIMITER ',' CSV HEADER;

-- 3. Orders
COPY staging.stg_orders FROM 'C:/processed/orders.csv' DELIMITER ',' CSV HEADER;

-- 4. Order Revenue (You are using 'order_items.csv' here, which is correct based on your file name)
COPY staging.stg_order_revenue FROM 'C:/processed/order_items.csv' DELIMITER ',' CSV HEADER;

-- 5. Geolocation
COPY staging.stg_geolocation FROM 'C:/processed/geolocation.csv' DELIMITER ',' CSV HEADER;

-- 6. Product Category Translation
COPY staging.stg_product_category_translation FROM 'C:/processed/product_category_translation.csv' DELIMITER ',' CSV HEADER;

-- 7. Sellers
COPY staging.stg_sellers FROM 'C:/processed/sellers.csv' DELIMITER ',' CSV HEADER;