SELECT * FROM sales;


--
SELECT 
	customer_name,
	category,
	amount ,
	
	ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC)RANKS
FROM sales;

--
WITH ranked as(
SELECT *,
	ROW_NUMBER() OVER(
PARTITION BY category ORDER BY amount DESC
	)rn
	FROM sales)

SELECT * from ranked WHERE rn<=2;




--ranks questions
SELECT *,
	RANK() OVER(ORDER BY amount DESC)
FROM sales
--
SELECT *,
	RANK() OVER(PARTITION BY city ORDER BY amount desc)
FROM sales
--
WITH top as (
SELECT *,
		rank() OVER (partition by CITY ORDER BY amount desc )ranks
from sales)
SELECT * FROM top WHERE ranks =1;



--dense rank
--Find the second highest unique amount in each city
WITH top as(
SELECT customer_name ,
		amount,
		city,
		DENSE_RANK() OVER(partition by city ORDER BY amount DESC) AS row_num
FROM sales)

SELECT * FROM top WHERE row_num =2

--Find the third highest unique amount overall.

WITH top as(
SELECT customer_name ,
		amount,
		city,
		DENSE_RANK() OVER( ORDER BY amount DESC) AS row_num
FROM sales)

SELECT * FROM top WHERE row_num =3

--Find all customers whose purchase is among the top 2 unique amounts in their city

WITH top as(
SELECT customer_name ,
		amount,
		city,
		DENSE_RANK() OVER(PARTITION BY city ORDER BY amount DESC) AS row_num
FROM sales)
SELECT * FROM top WHERE row_num <=2
---
SELECT * FROM (
SELECT customer_name ,
		amount,
		city,
		DENSE_RANK() OVER(PARTITION BY city ORDER BY amount DESC) AS row_num
FROM sales
) where row_num <= 2;

--Find the highest-selling product in each category
WITH highest as(
select category,
	product,
	SUM(amount)total_sales
	FROM sales
	GROUP BY category,product),
	
	ranked as(
	SELECT *,
	DENSE_RANK () OVER(PARTITION BY category ORDER BY total_sales DESC)dense_rank
	from highest)


SELECT * FROM ranked 
WHERE dense_rank =1
	
---Find the top 3 customers in each city based on total purchase amount.

WITH total_spending as (
SELECT c.customer_id,c.city,
		sum(amount) as total
	from orders o JOIN customers c 
	ON c.customer_id = o.customer_id 
	GROUP BY c.customer_id,c.city ),
ranked as (
select *,
	DENSE_RANK () OVER(PARTITION BY city ORDER BY total DESC)dense_Rank
	from total_spending )
SELECT * from ranked 
WHERE dense_rank <= 3

--

SELECT * FROM(
	SELECT customer_id,city,total,
	rank() over(partition by city ORDER by total desc)dr
		FROM
		(SELECT c.customer_id,c.city ,
		SUM(amount) as total
			FROM customers c joiN orders o
			ON c.customer_id = o.customer_id
			GROUP BY c.city,c.customer_id
			)
		)WHERE dr<3


--Rank all products by total sales

WITH spending AS(
SELECT p.product_id,p.product_name,SUM(oi.amount)total 
		from products p JOIN order_items oi
		ON oi.product_id = p.product_id
		GROUP BY p.product_id,p.product_name),
	ranking as(SELECT 
			product_id,product_name,total,
			RANK() OVER (ORDER BY total DESC)
			FROM spending )
		SELECT * FROM ranking 

--Remove Duplicate Records
SELECT * FROM employees;
WITH dup as(
SELECT *,
		ROW_NUMBER() OVER(PARTITION BY email ORDER BY employee_id)rn
		FROM employees 
)
DELETE FROM employees
WHERE employee_id IN(
SELECT employee_id FROM dup WHERE rn>1);
)
SELECT * FROM ranking WHERE rn=1 


SELECT * FROM employees;
--1. Find the highest-paid employee in each department.
WITH ranking as(
SELECT *,
		Row_number() OVER(PARTITION BY department order by salary DESC)rk
		from employees
)
select * from ranking WHERE rk=1

--2. Find the second highest salary in each department
WITH ranking as(
SELECT *,
		DENSE_RANK() OVER(PARTITION BY department order by salary DESC)rk
		from employees
)
select * from ranking WHERE rk=2

--3. Display the top 5 most expensive products.


WITH ranking as(
SELECT 
		p.product_name,
		oi.amount,
		ROW_NUMBER() OVER(ORDER BY amount DESC)as rn
		FROM products p join order_items oi on oi.product_id = p.product_id)
SELECT * FROM ranking WHERE rn<=5

--5. Find the latest order for every customer.

select * from orders;

WITH ranking as(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC)rn
	from ORDERS )
	SELECT * FROM ranking WHERE rn=1

--8. Find the customer with the highest spending in every city.
SELECT * FROM orders;
WITH highest as(
	SELECT c.city,c.customer_name,MAX(o.amount)maximum
	FROM customers c JOIN orders o  
	ON o.customer_id = c.customer_id
	GROUP BY c.city,c.customer_name),
ranking as(
	SELECT *,
			DENSE_RANK() OVER(PARTITION BY city ORDER BY maximum)dr
			FROM highest
)
SELECT * from ranking WHERE dr=1


--9. Find customers whose latest order is also their highest order.

with ranking as(
select *,
	row_number () OVER (PARTITION BY customer_id ORDER BY order_date DESC)od,
	row_number () OVER (PARTITION BY customer_id ORDER BY amount DESC)am
	FROM orders
	)
SELECT * FROM ranking WHERE od=1 and am=1;

--Employees Above Department Average


with ranking as(
	SELECT *,
	AVG(salary) OVER(PARTITION BY department )aver
	from employees )
	
SELECT * FROM ranking WHERE salary>aver;


	

WITH spend as(
SELECT category,
	
)