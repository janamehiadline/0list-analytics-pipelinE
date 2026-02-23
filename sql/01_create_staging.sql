-- 1. Customers
CREATE TABLE IF NOT EXISTS staging.stg_customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

-- 2. Products
CREATE TABLE IF NOT EXISTS staging.stg_products (
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
CREATE TABLE IF NOT EXISTS staging.stg_orders (
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
    payment_installments INT,
    payment_value NUMERIC,
    review_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
-- 4. Order Revenue 
CREATE TABLE IF NOT EXISTS staging.stg_order_revenue (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    revenue NUMERIC
); 