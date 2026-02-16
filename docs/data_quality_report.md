# Data Quality Report

## Null Checks

### Customers

|                          |   0 |
|:-------------------------|----:|
| customer_id              |   0 |
| customer_unique_id       |   0 |
| customer_zip_code_prefix |   0 |
| customer_city            |   0 |
| customer_state           |   0 |

### Orders

|                               |     0 |
|:------------------------------|------:|
| order_id                      |     0 |
| customer_id                   |     0 |
| order_status                  |     0 |
| order_purchase_timestamp      |     0 |
| order_approved_at             |   161 |
| order_delivered_carrier_date  |  1793 |
| order_delivered_customer_date |  2987 |
| order_estimated_delivery_date |     0 |
| delivery_duration_days        |  2987 |
| payment_type                  |     1 |
| payment_installments          |     1 |
| payment_value                 |     1 |
| review_id                     |   768 |
| review_score                  |   768 |
| review_comment_title          | 88426 |
| review_comment_message        | 59042 |
| review_creation_date          |   768 |
| review_answer_timestamp       |   768 |

### Order Items

|                     |   0 |
|:--------------------|----:|
| order_id            |   0 |
| order_item_id       |   0 |
| product_id          |   0 |
| seller_id           |   0 |
| shipping_limit_date |   0 |
| price               |   0 |
| freight_value       |   0 |
| revenue             |   0 |

### Products

|                            |   0 |
|:---------------------------|----:|
| product_id                 |   0 |
| product_category_name      |   0 |
| product_name_lenght        |   0 |
| product_description_lenght |   0 |
| product_photos_qty         |   0 |
| product_weight_g           |   0 |
| product_length_cm          |   0 |
| product_height_cm          |   0 |
| product_width_cm           |   0 |

## Duplicate Checks

- Customers duplicates: 0
- Orders duplicates: 0
- Order Items duplicates: 0
- Products duplicates: 0

## Revenue Validation

Revenue mismatch detected.

## Delivery Validation

Found 2987 invalid or missing delivery records.