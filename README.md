# Assignment-sql-suzanne-tsang
<H1>Summary</H1>
<p>The purpose of this relational database is to keep track of sales records, customer information, and product information for a dessert shop's e-commerce site. This database aims to provide unified data that supports the shop's needs to check sales performance, product details, and customer order history without redundant data. It stores information about customers, payment records, order records, order items, products, and categories.</p>
<H3>Description of the database</H3>
<ul><li><b>Customer:</b> The database keeps information for each member, including their first name, last name, email, phone number, and address. The shop also generates a unique customer ID for each new customer.</li>
<li><b>Payment:</b> For each payment, the shop generates a unique payment ID and tracks information such as the payment date, payment category (cash or credit card), and total amount. Each member may have multiple payment records or none, as people can register as members through website subscription without making any purchases. </li>
<li><b>Orders:</b> The database records information about orders, including the order date and the total price of the order. The shop generates a unique order ID for each order with at least one order items. Each order can be settled by one payment and contains at least one or many order items. Each member may have multiple order records or none if they have not yet started placing orders. Order date, order total price, payment id will be updated once payment created.</li>
<li><b>Orders_Item:</b> The database keeps track of the quantity and generates a unique order item ID for each item in an order. Each order item is related to only one product and one order.</li>
<li><b>Product:</b> Each product can be ordered multiple times or never ordered and is related to only one category. The database keeps track of the SKU, product name, price, and inventory level. The shop generates a unique product ID for each product.</li>
<li><b>Categories:</b> A new category is created only when there is at least one product in it. The shop generates a unique category ID for each category and records its name.</li>
</ul>
		
<H3>How it may be used?</H3>
<p><b>Usage 1: Find out the categories with fewer than 5 product items and the total number of existing products they have, so that new products may be created for those categories</b>
<br>
<br>
SELECT cat.categories_id,cat.categories_name, <br>
COUNT (prd.categories_id) AS total_products<br>
FROM categories cat RIGHT JOIN product prd ON cat.categories_id = prd.categories_id<br>
GROUP BY cat.categories_id<br>
HAVING COUNT(prd.categories_id)<5<br>
ORDER BY total_products ASC<br>
;
</p>
<p><b>Usage 2: Remove product items that have never been ordered by any members with categories name, and replace them with new products later</b>
 
  <br>
SELECT prd.product_id, prd.sku, prd.product_name, cat.categories_name, itm.orders_item_id<br>
FROM orders_item itm RIGHT JOIN product prd ON itm.product_id = prd.product_id <br>
RIGHT JOIN categories cat ON cat.categories_id = prd.categories_id<br>
WHERE itm.orders_item_id IS NULL<br>
;
</p>
<p><b>Usage 3: Find out the member who has the highest total payment amount and the detailed information of that member</b>
  <br>
  <br>
SELECT c.customer_id,c.first_name,c.last_name,c.email,c.phone,c.address,SUM(p.payment_amount) AS total_payment_amount<br>
FROM customer c RIGHT JOIN payment p ON c.customer_id = p.customer_id<br>
GROUP BY c.customer_id<br>
ORDER BY total_payment_amount DESC<br>
;
</p>
<p><b>Usage 4: Find out the members who have never placed orders and the details of their member information</b>
  <br>
  <br>
SELECT c.customer_id,c.first_name,c.last_name,c.email,c.phone,c.address, COUNT (o.customer_id) AS total_orders<br>
FROM customer c LEFT JOIN orders o ON c.customer_id = o.customer_id<br>
GROUP BY c.customer_id<br>
HAVING COUNT(o.customer_id)=0<br>
ORDER BY c.customer_id ASC<br>
;
  </p>
<H3>How to update it?</H3>
<b>1.	Replace product items that have never been ordered with new items, e.g. replace Chocolate Cake with Blueberry Cake</b>
<br>
<br>
SELECT cat.categories_id,cat.categories_name, <br>
COUNT (prd.categories_id) AS total_products <br>
FROM categories cat RIGHT JOIN product prd ON cat.categories_id = prd.categories_id<br>
GROUP BY cat.categories_id<br>
HAVING COUNT(prd.categories_id)<5<br>
ORDER BY total_products ASC<br>
;

<b>2.	Update inventory after products are replenished</b>
<br>
<br>
SELECT prd.product_id, prd.sku, prd.product_name, cat.categories_name, itm.orders_item_id<br>
FROM orders_item itm RIGHT JOIN product prd ON itm.product_id = prd.product_id <br>
RIGHT JOIN categories cat ON cat.categories_id = prd.categories_id<br>
WHERE itm.orders_item_id IS NULL<br>
ORDER BY product_id ASC<br>
;

<b>3.	Once a customer has paid, a new payment and order record is created. The quantity of the product with the same product ID in the product inventory will be deducted according to the quantity in the order items.</b>
<br>
<br>
--step 1 add a new order record
<br>
<br>
INSERT INTO orders (orders_id,customer_id)<br>
VALUES(23007102,923007)<br>
;
 
--step 2 add order items for the new order record
<br>
<br>
INSERT INTO orders_item<br>
VALUES(22,12,204,'23007102'),<br>
(23,1,302,'23007102')<br>
;

--Step 3: Insert information of when customer make payment
<br>
<br>
INSERT INTO payment (payment_id,payment_date,payment_categories,customer_id)<br>
VALUES(230072,'2023-12-28','credit card',923007)<br>
;

--Step 4: Update orders date and payment id for the orders table of related payment
<br>
<br>
UPDATE orders<br>
SET orders_date='2023-12-28',payment_id=230072<br>
WHERE orders_id=23007102<br>
;

--Step 5 Update the orders total price on the orders table and payment amount on the payment table
Update orders
<br>
<br>
SET orders_total_price = t.total_price_per_order<br>
FROM<br>
(SELECT itm.orders_id, SUM(itm.orders_quantity*prd.product_price) AS total_price_per_order<br>
FROM orders_item itm INNER JOIN product prd ON itm.product_id = prd.product_id <br>
WHERE orders_id=23007102<br>
 GROUP BY itm.orders_id<br>
)t<br>
WHERE orders.orders_id=23007102<br>
;
<br>
Update payment<br>
SET payment_amount = t.total_price_per_order<br>
FROM <br>
(SELECT itm.orders_id, SUM(itm.orders_quantity*prd.product_price) AS total_price_per_order<br>
FROM orders_item itm INNER JOIN product prd ON itm.product_id = prd.product_id <br>
WHERE orders_id=23007102<br>
 GROUP BY itm.orders_id<br>
)t<br>
WHERE payment.payment_id=230072;<br>

--Step 6 Update the quantity of product
<br>
<br>
UPDATE product <br>
SET product_inventory = new.new_inventory <br>
FROM<br>
(SELECT <br>
 --itm.orders_id,itm.orders_quantity, itm.product_id,itm.orders_id, prd.product_inventory, <br>
 o.orders_id,itm.product_id, (prd.product_inventory-itm.orders_quantity)AS new_inventory <br>
FROM orders_item itm INNER JOIN product prd ON prd.product_id = itm.product_id <br>
 INNER JOIN orders o ON o.orders_id = itm.orders_id<br>
 WHERE itm.orders_id=23007102<br>
)new<br>
WHERE product.product_id =new.product_id<br>
; <br>
