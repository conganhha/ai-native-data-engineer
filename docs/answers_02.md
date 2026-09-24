# Q1
SELECT SUM(total_amount) AS revenue
FROM orders
WHERE EXTRACT(MONTH FROM order_date) = 7 AND EXTRACT(YEAR FROM order_date) = 2026;

# Q2
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1, 2, 3
ORDER BY revenue DESC
LIMIT 1;

# Q3
SELECT 
    cat.category_name, 
    COUNT(DISTINCT oi.order_id) as cnt_o
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY 1
ORDER BY cnt_o DESC
LIMIT 1;

# Q4
SELECT AVG(total_amount) as aov
FROM orders;

# Q5
WITH top_customers AS (
    SELECT customer_id 
    FROM orders 
    GROUP BY customer_id 
    HAVING COUNT(*) > 3
)
SELECT COUNT(*) AS cnt_customer
FROM top_customers;


SELECT 
    city,
    COUNT(*) AS active_customers
FROM customers
GROUP BY 1
ORDER BY active_customers DESC
LIMIT 1;

WITH ranked AS (
	SELECT 
	        product_id, 
	        product_name, 
	        unit_price,
	        DENSE_RANK() OVER(
	        	PARTITION BY unit_price
	        	ORDER BY unit_price desc
	    	) AS rn
	FROM products
	ORDER BY unit_price DESC
)
SELECT 
        product_id, 
        product_name, 
        unit_price,
        rn
FROM ranked
where rn <= 3
ORDER BY unit_price desc;