--Queries for creating tables--
--Table: customer--
CREATE TABLE customer(
customer_id INT PRIMARY KEY NOT NULL,
first_name CHAR(50) NOT NULL,
last_name CHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
phone VARCHAR(10) UNIQUE NOT NULL,
address VARCHAR(255) NOT NULL
	);

--Table: categories--
CREATE TABLE categories (
categories_id INT PRIMARY KEY NOT NULL,
categories_name VARCHAR(255) UNIQUE
);

--Table: product--
CREATE TABLE product(
product_id INT PRIMARY KEY NOT NULL,
sku varchar(10) NOT NULL UNIQUE,
product_name CHAR(50) NOT NULL UNIQUE,
product_price DECIMAL(7,2) NOT NULL,
product_inventory INT NOT NULL,
categories_id INT NOT NULL, 
FOREIGN KEY (categories_id) REFERENCES categories(categories_id)
);

--Table: payment--	
CREATE TABLE payment(
payment_id INT PRIMARY KEY NOT NULL,
payment_date DATE NOT NULL,
payment_categories VARCHAR(100) NOT NULL,
payment_amount INT,
customer_id INT NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

--Table: orders--
CREATE TABLE orders(
orders_id INT PRIMARY KEY NOT NULL,
orders_date DATE,
orders_total_price DECIMAL(7,2),
customer_id INT NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
payment_id INT UNIQUE,
FOREIGN KEY (payment_id) REFERENCES payment(payment_id)
	);



--Table: orders_item--
CREATE TABLE orders_item(
orders_item_id INT PRIMARY KEY NOT NULL,
orders_quantity INT NOT NULL,
	product_id INT NOT NULL,
FOREIGN KEY (product_id) REFERENCES product(product_id),
orders_id INT NOT NULL,
FOREIGN KEY (orders_id) REFERENCES orders(orders_id)
);


--Queries for inserting informaiton--
--Insert customer info for the table customer—
INSERT INTO customer VALUES
(923001,'Leo', 'Wong','leo.wong12@gmailtest.com','4165550121','Apt. 755 1762 Alverta Shore'),
(923002,'Macy','Belle','macy.belle22@gmailtest.com','4165550110','Suite 385 94655 Morar Fields'),
(923003,'Jay', 'Patil','jay.patil43@gmailtest.com','4165550142','Apt. 288 587 Steuber Circle Michellfurt'),
(923004,'Andy','Nguyen','andy.nguyen59@gmailtest.com','4165550154','Apt. 924 646 Kelley LodgeNew Eusebioton'),
(923005,'Tina','Chan','tina.chan89@gmailtest.com','4165550189','20353 Doris Flat Garretmouth'),
(923006,'Ben','Walters','ben.walters889@gmailtest.com','4165550149','266 Stanton Harbors Port Michealtown'),
(923007,'Sarah','Liang','sarah.liang927@gmailtest.com','4375550157','Apt. 332 2112 Hintz Court Lake Shanmouth')
;

--Insert categories of products for the table categories--
INSERT INTO categories VALUES
(1,'Drink'),
(2,'Cookie'),
(3,'Mini Cake'),
(4,'Ice Cream')
;

--Insert product information for the table product--
INSERT INTO product VALUES
(101,'D101','Milk tea',5.00,10,1),
(201,'C201','Unicorn Cookie',3.25,10,2),
(202,'C202','Chocolate Cookie',3.25,22,2),
(203,'C203','Strawberry Cookie',3.25,47,2),
(204,'C204','Granola Cookie',3.25,53,2),
(205,'C205','Matcha Cookie',3.25,60,2),
(206,'C206','Hazelnut Cookie',3.25,35,2),
(301,'M301','Bobalicious Cake',70.00,2,3),
(302,'M302','Ramen Bowl Cake',90.00,4,3),
(303,'M303','Fromage Cake',80.00,6,3),
(304,'M304','Chocolate Cake',100.00,10,3),
(401,'I401','Taro',	6.50,3,4),
(402,'I402','Coconut',6.50,2,4),
(403,'I403','Mango',6.50,2,4),
(404,'I404','Black Seasame',6.50,4,4),
(405,'I405','Coffee',6.50,4,4)
;

--Insert payment information for the table payment--
INSERT INTO payment VALUES
(230011,'2023-03-01','credit card',179,923001),
(230012,'2023-12-01','gift card',135,923001),
(230031,'2023-02-02','credit card',90,923003),
(230032,'2023-03-13','credit card',338,923003),
(230033,'2023-07-15','credit card',46,923003),
(230034,'2023-12-15','credit card',103,923003),
(230051,'2023-11-10','credit card',180,923005),
(230052,'2023-12-10','credit card',860,923005),
(230071,'2023-01-01','gift card',121,923007)
;

--Insert orders information for the table orders--
INSERT INTO orders VALUES
(23001103,'2023-03-01',179,923001,230011),
(23001212,'2023-12-01',135,923001,230012),
(23003102,'2023-02-02',90,923003,230031),
(23003203,'2023-03-13',338,923003,230032),
(23003307,'2023-07-15',46,923003,230033),
(23003412,'2023-12-15',103,923003,230034),
(23005111,'2023-11-10',180,923005,230051),
(23005212,'2023-12-10',860,923005,230052),
(23007101,'2023-01-01',121,923007,230071)
;

--Insert orders details for the table orders_item--
INSERT INTO orders_item VALUES
(5,15,101,'23001103'),
(6,16,201,'23001103'),
(7,16,204,'23001103'),
(16,20,202,'23001212'),
(17,1,301,'23001212'),
(4,1,302,'23003102'),
(8,10,203,'23003203'),
(9,10,205,'23003203'),
(10,4,206,'23003203'),
(11,20,401,'23003203'),
(12,20,402,'23003203'),
(13,4,101,'23003307'),
(14,4,404,'23003307'),
(20,2,403,'23003412'),
(21,1,302,'23003412'),
(15,2,302,'23005111'),
(18,3,301,'23005212'),
(19,200,205,'23005212'),
(1,5,101,'23007101'),
(2,1,301,'23007101'),
(3,8,204,'23007101')
;
