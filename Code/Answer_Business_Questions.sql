/*** answer business questions ***/

USE Magist;

/** ------ 3.1 ---------**/


-- What categories of tech does Magist have?
-- FIRST, check which categories contain these words:
SELECT product_category_name_english FROM product_category_name_translation
WHERE  product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%audio%'
        OR product_category_name_english LIKE '%phon%'
        OR product_category_name_english LIKE '%electronic%'
        OR product_category_name_english LIKE '%pc%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE '%apple%'
        OR product_category_name_english LIKE '%watch%'
        OR product_category_name_english LIKE '%mobile%'
        OR product_category_name_english LIKE '%dvd%'
        OR product_category_name_english LIKE '%cd%'
        OR product_category_name_english LIKE '%video%'
        OR product_category_name_english LIKE '%consol%';
        
-- THEN choose fitting categories and put them in a list: "audio", "cds_dvds_musicals", "consoles_games", "dvds_blu_ray", "electronics", "computer_accessories", "pc_gamer", "computers", "telephony", "fixed_telephony")

SELECT 
    product_category_name_english
FROM
    product_category_name_translation
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;

-- How many tech products have been sold overall?  - > 9367
SELECT 
    COUNT(order_items.product_id)
FROM
    order_items
        LEFT JOIN
    products ON products.product_id = order_items.product_id
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;

-- ALTERNATIVE BY ALI: how many DIFFERENT tech products have been sold? -> 2224
SELECT 
    COUNT(DISTINCT product_id)
FROM
    orders
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;


-- What percentage does that represent from the overall number of products sold? 8.32%
SELECT 
    9367 * 100 / COUNT(order_id)
FROM
    order_items;


-- What’s the average price of the products being sold? -> 120.65
SELECT 
    AVG(price) AS avg_price_sold
FROM
    order_items;


-- Are expensive tech products popular? NO
SELECT 
    COUNT(order_items.product_id) AS sold_tech_products,
    CASE
        WHEN price < 1000 THEN 'cheap'
        ELSE 'expensive'
    END AS price_category
FROM
    order_items
        LEFT JOIN
    products ON products.product_id = order_items.product_id
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
GROUP BY price_category;



/** ------ 3.2 ---------**/

-- How many months of data are covered in db? -> 25 months
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) AS time_interval
FROM
    orders;

-- How many sellers?
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers;

-- How many tech sellers? -> 334
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    order_items
        LEFT JOIN
    products ON products.product_id = order_items.product_id
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;

-- What percentage of overall sellers are tech sellers? 10.8%
SELECT 
    334 / COUNT(DISTINCT seller_id) * 100
FROM
    sellers;


-- Total amount earned by all sellers?
SELECT SUM(price) FROM order_items;


-- Total amount earned by all tech sellers?
SELECT 
    SUM(price) AS earned_by_tech_sellers
FROM
    order_items
        LEFT JOIN
    products ON products.product_id = order_items.product_id
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;
        
-- Average monthly income of all sellers?
SELECT 
    SUM(price) / COUNT(DISTINCT seller_id) / 25
FROM
    order_items;

-- Monthly avg income of all tech sellers?
SELECT 
    SUM(price) / COUNT(DISTINCT seller_id) / 25
FROM
    order_items
        LEFT JOIN
    products ON products.product_id = order_items.product_id
        LEFT JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'cds_dvds_musicals',
        'consoles_games',
        'dvds_blu_ray',
        'electronics',
        'computer_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'fixed_telephony')
;


/** ------ 3.3 ---------**/

-- avg time between order being placed and product being delivered
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS avg_delivery_duration
FROM
    orders;
-- avg delay in delivery
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) AS avg_delivery_duration
FROM
    orders;
    
    

-- How many orderes are deliverd with a delay? -> 6535
SELECT 
    COUNT(TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) AS deliverd_with_delay
FROM
    orders
WHERE
    TIMESTAMPDIFF(DAY,
        order_estimated_delivery_date,
        order_delivered_customer_date) > 0;

-- how many orders are delivered on time? -> 89941
    SELECT 
    COUNT(TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) AS deliverd_ontime
FROM
    orders
WHERE
    TIMESTAMPDIFF(DAY,
        order_estimated_delivery_date,
        order_delivered_customer_date) <= 0;   

-- Is there any pattern for delays?
SELECT 
    AVG(products.product_weight_g),
    AVG(products.product_length_cm),
    AVG(products.product_height_cm),
    COUNT(TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) AS orders,
    CASE
        WHEN
            TIMESTAMPDIFF(DAY,
                order_estimated_delivery_date,
                order_delivered_customer_date) > 0
        THEN
            'delayed'
        ELSE 'on time'
    END AS delivery
FROM
    orders
        LEFT JOIN
    order_items ON order_items.order_id = orders.order_id
        LEFT JOIN
    products ON products.product_id = order_items.product_id
GROUP BY delivery
;

