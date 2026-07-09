--MoM 

WITH mom as (
SELECT Month,Sales,
	LAG(Sales) OVER (ORDER BY Month) as lagged,
	Sales - LAG(Sales) OVER (ORDER BY Month)diff
from monthly_sales)

SELECT Month,Sales,lagged,
	
	ROUND(COALESCE((Sales - lagged)::numeric*100/ NULLIF(lagged,0) ,0),2) as mom_percentage
	from mom;


SELECT Month,sales,
	LAG(month) OVER(ORDER BY MONTH)
	FROM monthly_sales

SELECT Month,sales,
	ROUND(SUM(Sales) OVER(ORDER BY MONTH),2)
	FROM monthly_sales

SELECT Month,sales,
	ROUND(AVG(Sales) OVER(ORDER BY MONTH ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2)
	FROM monthly_sales

SELECT Month,sales,
	LEAD(Sales,1,0) OVER(ORDER BY MONTH)
	FROM monthly_sales

--For each customer, show:
--First purchase
--Previous purchase
--Days since last purchase
--Churn status using CASE WHEN


select customer_id,order_date,
	min(order_date) OVER(PARTITION BY customer_id )first_purchase,
	LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)prev_purchase,
	LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)last_purchase,
	CASE WHEN LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) IS NULL
		THEN 'NEW CUSTOMER'
	 WHEN order_date - LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) > 30 
		THEN 'INACTIVE'
	
	ELSE 'ACTIVE'
	END as customer_status
FROM orders ;





--VIEWS--


CREATE VIEW revenue_kpi AS 
SELECT SUM(amount) FROM orders;

--Daily revenue

CREATE VIEW daily_revenue_kpi AS
(SELECT order_date,SUM(amount) as daily_revenue
FROM orders GROUP BY order_date 
ORDER BY order_date
)



SELECT COUNT(*) 
FROM (
SELECT customer_id
FROM orders GROUP BY customer_id
HAVING COUNT(customer_id)>1)t;

SELECT COUNT(*) FROM customers;


--REPEAT ORDER RATE 

Repeat order rate

WITH repeat_customers as(
	SELECT customer_id 
	from orders 
	GROUP BY customer_id
	HAVING COUNT(*)>1
	)
SELECT
(SELECT COUNT(*) FROM repeat_customers) AS repeat_customers,
(SELECT COUNT(*) FROM repeat_customers) AS total_customers,
ROUND(
(SELECT COUNT(*) FROM repeat_customers) * 100.0/
	(SELECT COUNT(*) FROM customers),2 ) AS repeat_order_rate


--materialized view

create MATERIALIZED VIEW AS 

REFRESH MATERIALIZED VIEW 

















	