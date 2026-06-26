--CREATING TABLE--
CREATE TABLE customers(customer_id INT PRIMARY KEY,
customer_name VARCHAR(50),
city VARCHAR(50),
signup_date DATE);

CREATE TABLE products(product_id INT PRIMARY KEY,
product_name VARCHAR(50),
category VARCHAR(50),
price INT);

CREATE TABLE orders(order_id INT PRIMARY KEY,
customer_id INT references customers(customer_id),
order_date DATE);

CREATE TABLE order_items(order_item_id INT PRIMARY KEY,
order_id INT references orders(order_id),
product_id INT references products(product_id),
quantity INT,
amount INT);

--INSERTING VALUES INTO TABLES

INSERT INTO customers
(customer_id, customer_name, city, signup_date)
VALUES
(1, 'Ali', 'Kochi', '2025-01-10'),
(2, 'Rahul', 'Calicut', '2025-01-15'),
(3, 'Amina', 'Malappuram', '2025-02-01'),
(4, 'Faiz', 'Kochi', '2025-02-20'),
(5, 'Anjali', 'Thrissur', '2025-03-05'),
(6, 'Arjun', 'Kannur', '2025-03-12'),
(7, 'Nisha', 'Kochi', '2025-03-25'),
(8, 'Sneha', 'Calicut', '2025-04-01'),
(9, 'Akash', 'Malappuram', '2025-04-10'),
(10, 'Maya', 'Thrissur', '2025-04-18');


INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Mouse', 'Electronics', 500),
(103, 'Keyboard', 'Electronics', 1500),
(104, 'T-Shirt', 'Fashion', 800),
(105, 'Shoes', 'Fashion', 2500),
(106, 'Book', 'Books', 400),
(107, 'Headphones', 'Electronics', 3000),
(108, 'Backpack', 'Accessories', 1200),
(109, 'Watch', 'Accessories', 3500),
(110, 'Notebook', 'Stationery', 100);




INSERT INTO orders
(order_id, customer_id, order_date)
VALUES
(1001, 1, '2025-03-01'),
(1002, 2, '2025-03-03'),
(1003, 1, '2025-03-15'),
(1004, 3, '2025-04-02'),
(1005, 4, '2025-04-10'),
(1006, 5, '2025-04-20'),
(1007, 2, '2025-05-01'),
(1008, 6, '2025-05-08'),
(1009, 7, '2025-05-15'),
(1010, 8, '2025-05-25');



INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, amount)
VALUES
(1, 1001, 101, 1, 50000),
(2, 1001, 102, 2, 1000),
(3, 1002, 104, 3, 2400),
(4, 1002, 106, 2, 800),
(5, 1003, 103, 1, 1500),
(6, 1004, 105, 2, 5000),
(7, 1005, 101, 1, 50000),
(8, 1005, 102, 1, 500),
(9, 1006, 104, 2, 1600),
(10, 1007, 105, 1, 2500),
(11, 1008, 107, 1, 3000),
(12, 1008, 108, 1, 1200),
(13, 1009, 109, 1, 3500),
(14, 1009, 110, 5, 500),
(15, 1010, 104, 2, 1600);


--verify

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;


--Real business question
--Total Revenue

select SUM(amount) total_revenue
FROM order_items ;


--Revenue per month

SELECT EXTRACT(month FROM o.order_date) as  MONTH ,
SUM(oi.amount)as Revenue from orders o 
JOIN order_items oi on o.order_id = oi.order_id 
group by MONTH;


--Revenue by city

SELECT c.city,SUM(oi.amount) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id 
GROUP BY city 
ORDER BY revenue DESC;


--TOP 5 customers

SELECT c.customer_id , c.customer_name ,SUM(oi.amount) AS spending
from customers c JOIN orders o 
on c.customer_id = o.customer_id
JOIN order_items oi
on o.order_id = oi.order_id 
GROUP BY c.customer_id 
order by spending DESC
LIMIT 5;



--Repeat customers

SELECT c.customer_name, COUNT(o.order_id) as no_of_visit
FROM orders o
join customers c on c.customer_id = o.customer_id
GROUP BY c.customer_id HAVING COUNT(o.order_id) > 1;


--Average customer spend

SELECT AVG(total_spend) from 
(SELECT o.customer_id,SUM(amount) as total_spend
 from orders o JOIN order_items oi 
 ON oi.order_id = o.order_id
 GROUP BY o.customer_id);


 --customer segment

SELECT o.customer_id , SUM(oi.amount) AS total_Spend,CASE WHEN SUM(oi.amount) >= 50000 THEN 'HIGH'
WHEN SUM(oi.amount) <= 10000 THEN 'LOW'
ELSE 'MEDIUM' END AS segment 
from orders o  join order_items oi 
on oi.order_id = o.order_id join customers c
on o.customer_id = c.customer_id 
GROUP BY o.customer_id order by total_spend desc
;


--Top selling product 

Select p.product_name,SUM(oi.quantity) as total 
from order_items oi join products p 
on p.product_id = oi.product_id 
GROUP BY p.product_id order by total DESC LIMIT 1;


--Top selling category

SELECT p.category, SUM(oi.amount) from order_items oi
join products P on p.product_id = oi.product_id
GROUP BY p.category;


--Highest Revenue product

Select p.product_name,SUM(oi.amount) as total 
from order_items oi join products p 
on p.product_id = oi.product_id 
GROUP BY p.product_id order by total DESC LIMIT 1;


--Revenue by city

SELECT c.city,  SUM(oi.amount) as revenue
from order_items oi join orders o 
ON oi.order_id = o.order_id
JOIN customers c
on c.customer_id = o.customer_id
GROUP BY c.city; 

--Highest revenue city

Select c.city,SUM(oi.amount) as total
from order_items oi join orders o
on o.order_id = oi.order_id
JOIN customers c 
on o.customer_id = c.customer_id 
group by c.city ORDER BY total DESC LIMIT 1 

--Average order value 

SELECT AVG(order_total) FROM (
SELECT SUM(amount)order_total from order_items
group by order_id
);

--Highest Value order 

SELECT order_id,SUM(amount)order_total from order_items
group by order_id order BY order_total DESC LIMIT 1;
