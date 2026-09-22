-- Q1
SELECT * FROM orders WHERE order_total > 100;

-- Q2
SELECT c.customer_id, c.full_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q3
SELECT  c.customer_id, 
        c.full_name, 
        SUM(o.order_total) AS total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1, 2
ORDER BY total_amount DESC
LIMIT 10;

-- Q4
SELECT COUNT(DISTINCT customer_id)
FROM orders;

-- Q5
SELECT  order_id,
        customer_id,
        order_date,
        order_total,
        status
FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- Q6
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(order_total) AS revenue
FROM orders
WHERE status = 'completed'
GROUP BY 1;

-- Q7
SELECT 
    customer_id,
    ROUND(AVG(order_total), 2) AS aov
FROM orders
WHERE status = 'completed'
GROUP BY 1;

-- Q8
SELECT
        status,
        COUNT(order_id)
FROM orders
GROUP BY status;

-- Q9
SELECT
        cat.category_name,
        SUM(oi.quantity * oi.unit_price - oi.discount_amount) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id AND o.status = 'completed'
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY 1;

-- Q10
SELECT
        cat.category_name,
        SUM(oi.quantity * oi.unit_price - oi.discount_amount) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id AND o.status = 'completed'
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY 1
HAVING SUM(oi.quantity * oi.unit_price - oi.discount_amount) > 100;