/*** Explore magist DB ***/

USE magist;

-- 1. How many orders are there in the dataset? 99441
SELECT 
    count(*) as 'order count'
FROM
    orders;
    
-- 2. Are orders actually delivered?
SELECT 
    COUNT(*) AS orders, order_status
FROM
    orders
GROUP BY order_status
ORDER BY COUNT(order_status) DESC;

-- 3. Is Magist having user growth? 
SELECT 
    COUNT(*) AS orders,
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
    orders
GROUP BY year_ , month_
order by year_,month_;

-- 4. How many products are there in the products table? 32951
SELECT 
    *
FROM
    products;
SELECT DISTINCT
    COUNT(product_id) AS 'number of product'
FROM
    products;

-- 5. Which are the categories with the most products? 
SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS num_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

-- 6. How many of those products were present in actual transactions?  
SELECT 
    COUNT(DISTINCT product_id) AS num_sold_products
FROM
    order_items;

-- 7. What’s the price for the most expensive and cheapest products?
SELECT 
    MIN(price) AS cheapest_product,
    MAX(price) AS most_expns_product
FROM
    order_items;

-- 8. What are the highest and lowest payment values?
select * from order_payments;
SELECT 
    MIN(payment_value) AS lowest, MAX(payment_value) AS highest
FROM
    order_payments;
    
-- 9. How many products per order?
SELECT 
    COUNT(product_id) AS prod_per_order, order_id
FROM
    order_items
GROUP BY order_id
ORDER BY prod_per_order DESC;

-- 10. Ratings/reviews
SELECT 
    AVG(review_score) AS avg_review_score,
    YEAR(review_creation_date) AS year,
    MAX(review_score) AS max_rev,
    MIN(review_score) AS min_rev
FROM
    order_reviews
GROUP BY YEAR(review_creation_date)
ORDER BY YEAR(review_creation_date) DESC;

-- 11. How long does it take to deliver parcels?
SELECT 
    order_id,
    TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)
FROM
    orders;

-- 12. How exact is the estimated delivery? 
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) 
FROM
    orders;








 