--How it maybe used
--Usage 1: Find out the categories with fewer than 5 product items and the total number of existing products they have, so that new products may be created for those categories

SELECT cat.categories_id,cat.categories_name, 
COUNT (prd.categories_id) AS total_products 
FROM categories cat RIGHT JOIN product prd ON cat.categories_id = prd.categories_id
GROUP BY cat.categories_id
HAVING COUNT(prd.categories_id)<5
ORDER BY total_products ASC
;
-- Usage 2: Remove product items that have never been ordered by any members with categories name, and replace them with new products later
SELECT prd.product_id, prd.sku, prd.product_name, cat.categories_name, itm.orders_item_id
FROM orders_item itm RIGHT JOIN product prd ON itm.product_id = prd.product_id 
RIGHT JOIN categories cat ON cat.categories_id = prd.categories_id
WHERE itm.orders_item_id IS NULL
ORDER BY product_id ASC
;

--Usage 3: Find out the member who has the highest total payment amount and the detailed information of that member

SELECT c.customer_id,c.first_name,c.last_name,c.email,c.phone,c.address,SUM(p.payment_amount) AS total_payment_amount
FROM customer c RIGHT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_payment_amount DESC
;
--Usage 4:Find out the members who have never placed orders and the details of their member information

SELECT c.customer_id,c.first_name,c.last_name,c.email,c.phone,c.address, COUNT (o.customer_id) AS total_orders
FROM customer c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.customer_id)=0
ORDER BY c.customer_id ASC
;

--How to update it?
--1.	 Replace product items that have never been ordered with new items
--e.g. Replace Chocolate Cake with Blueberry Cake
UPDATE product 
SET product_id =305, sku='M305',product_name='Blueberry Cake', product_price = 100.00, product_inventory = 10, categories_id =3
WHERE product_name='Chocolate Cake';
--Check result: if all information of Chocolate Cake have been replaced, should return empty result
SELECT * FROM product
WHERE product_name='Chocolate Cake';

--2.	Update inventory after products are replenished
--e.g. Need to replenish cookies if inventory less than 30
SELECT * FROM product
WHERE product_inventory < 30 AND categories_id = 2
;
--And Update inventory after products are replenished 
UPDATE product
SET product_inventory=60
WHERE product_name='Unicorn Cookie';
-- Check result: if the inventory of the products have been updated
SELECT * FROM product
WHERE product_name='Unicorn Cookie';

--3.	Once a customer has paid, a new payment and order record is created. The quantity of the product with the same product ID in the product inventory will be deducted according to the quantity in the order items.

--step 1 add a new order record
INSERT INTO orders (orders_id,customer_id)
VALUES(23007102,923007)
;

--step 2 add order items for the new order record
INSERT INTO orders_item VALUES
(22,12,204,'23007102'),
(23,1,302,'23007102')
;

--Step 3: Insert information of when customer make payment
INSERT INTO payment (payment_id,payment_date,payment_categories,customer_id)
VALUES(230072,'2023-12-28','credit card',923007)
;

--Step 4: Update orders date and payment id for the orders table of related payment
UPDATE orders
SET orders_date='2023-12-28',payment_id=230072
WHERE orders_id=23007102
;
--Step 5 Update the orders total price on the orders table and payment amount on the payment table
Update orders
SET orders_total_price = t.total_price_per_order
FROM
(SELECT itm.orders_id, SUM(itm.orders_quantity*prd.product_price) AS total_price_per_order
FROM orders_item itm INNER JOIN product prd ON itm.product_id = prd.product_id 
WHERE orders_id=23007102
 GROUP BY itm.orders_id
)t
WHERE orders.orders_id=23007102
;

Update payment
SET payment_amount = t.total_price_per_order
FROM 
(SELECT itm.orders_id, SUM(itm.orders_quantity*prd.product_price) AS total_price_per_order
FROM orders_item itm INNER JOIN product prd ON itm.product_id = prd.product_id 
WHERE orders_id=23007102
 GROUP BY itm.orders_id
)t
WHERE payment.payment_id=230072;

--Step 6 Update the quantity of products
UPDATE product 
SET product_inventory = new.new_inventory 
FROM
(SELECT 
 --itm.orders_id,itm.orders_quantity, itm.product_id,itm.orders_id, prd.product_inventory, 
 o.orders_id,itm.product_id, (prd.product_inventory-itm.orders_quantity)AS new_inventory 
FROM orders_item itm INNER JOIN product prd ON prd.product_id = itm.product_id 
 INNER JOIN orders o ON o.orders_id = itm.orders_id
 WHERE itm.orders_id=23007102
)new
WHERE product.product_id =new.product_id; 

