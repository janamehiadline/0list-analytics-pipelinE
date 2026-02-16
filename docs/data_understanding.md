# Data Understanding - Olist E-Commerce Dataset

## 1. Primary Keys
- Customers: customer_id
- Orders: order_id
- Products: product_id
- Order Items: composite key (order_id + order_item_id)

## 2. Relationships
- Customers → Orders: customer_id
- Orders → Order Items: order_id
- Products → Order Items: product_id

## 3. Initial Observations
- Some missing values in order_delivered_customer_date
- Date columns are strings, need conversion to datetime
- Product categories in Portuguese, may need translation
- Check duplicates in all tables

## 4. Important Columns
- Customers: customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
- Orders: order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date
- Products: product_id, product_category_name, product_name_lenght, product_description_lenght
- Order Items: order_id, order_item_id, product_id, price, freight_value

## 5. Next Steps
1. Convert dates to datetime
2. Remove duplicates
3. Handle missing delivery dates
4. Translate product categories
5. Calculate revenue (price + freight_value)
6. Save processed files in data/processed/
