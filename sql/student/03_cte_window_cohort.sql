-- CTE 1
WITH spending_per_customer AS (
    SELECT 
        c.customer_id, 
        c.full_name,
        SUM(o.order_total) AS total_spending
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
    GROUP BY 1, 2
    ORDER BY total_spending DESC
)
SELECT *
FROM spending_per_customer
LIMIT 10;

-- CTE 2
WITH spending_per_customer AS (
    SELECT 
            c.customer_id, 
            c.full_name,
            SUM(o.order_total) AS total_spending
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
    GROUP BY 1, 2
),
segment_of_customer AS (
    SELECT 
        *,
        CASE
            WHEN total_spending < 500000 THEN 'Low'
            WHEN total_spending <= 2000000 THEN 'Medium'
            ELSE 'High'
        END AS segment
    FROM spending_per_customer
)
SELECT *
FROM segment_of_customer;

-- CTE 3
WITH orders_per_customer AS (
    SELECT
        c.customer_id,
        c.full_name,
        COUNT(o.order_id) AS orders
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
    GROUP BY 1, 2
),
customer_stats AS (
    SELECT
        AVG(orders) AS avg_orders_per_customer,
        MAX(orders) AS highest_order
    FROM orders_per_customer
);

-- CTE 4
WITH spending_per_customer AS (
    SELECT 
            c.customer_id, 
            c.full_name,
            SUM(o.order_total) AS total_spending,
            COUNT(o.order_id) AS orders
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
    GROUP BY 1, 2
)
SELECT
    *,
    ROUND(100.0 * total_spending / NULLIF(orders, 0), 2) AS aov
FROM spending_per_customer;

-- CTE 5
WITH first_order AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
customer_activity AS (
    SELECT DISTINCT
        o.customer_id,
        f.cohort_month,
        DATE_TRUNC('month', o.order_date) AS order_month
    FROM orders o
    JOIN first_order f
        ON o.customer_id = f.customer_id
),
retention AS (
    SELECT
        cohort_month,
        DATE_PART(
            'month',
            AGE(order_month, cohort_month)
        ) AS month_number,
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM customer_activity
    GROUP BY cohort_month, order_month
),
final AS (
    SELECT
        cohort_month,
        month_number,
        retained_customers,
        MAX(
            CASE
                WHEN month_number = 0
                THEN retained_customers
            END
        ) OVER (
            PARTITION BY cohort_month
        ) AS cohort_size
    FROM retention
)
SELECT
    cohort_month::date,
    month_number,
    retained_customers,
    ROUND(
        100.0 * retained_customers / cohort_size,
        2
    ) AS retention_rate
FROM final
ORDER BY cohort_month, month_number;

-- W1
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(order_total) AS total_spending
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spending,
    ROW_NUMBER() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending
ORDER BY spending_rank;


-- W2
-- 1. RANK():
--    - Nếu có giá trị bằng nhau, các dòng nhận cùng một hạng.
--    - Thứ hạng kế tiếp sẽ bị bỏ qua tương ứng với số lượng bản ghi bị trùng.
-- 2. DENSE_RANK():
--    - Nếu có giá trị bằng nhau, các dòng nhận cùng một hạng.
--    - Thứ hạng kế tiếp tăng liên tục +1.
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(order_total) AS total_spending
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT 
        customer_id,
        total_spending,
        RANK() OVER (ORDER BY total_spending DESC) AS rnk,
        DENSE_RANK() OVER (ORDER BY total_spending DESC) AS dense_rnk
    FROM customer_spending
)
SELECT 
    customer_id,
    total_spending,
    rnk,
    dense_rnk
FROM ranked_customers
WHERE dense_rnk <= 3
ORDER BY dense_rnk;


-- W3
SELECT 
    order_id,
    customer_id,
    order_date,
    order_total,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC, order_id ASC
    ) AS order_sequence_number
FROM orders
ORDER BY customer_id, order_sequence_number;


-- W4
SELECT 
    order_id,
    customer_id,
    order_date,
    order_total,
    LAG(order_total, 1) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC, order_id ASC
    ) AS prev_order_total,
    order_total - LAG(order_total, 1) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC, order_id ASC
    ) AS diff_with_prev_order,
    LEAD(order_total, 1) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC, order_id ASC
    ) AS next_order_total
FROM orders
ORDER BY customer_id, order_date;


-- W5
SELECT 
    order_id,
    order_date,
    order_total,
    SUM(order_total) OVER (
        ORDER BY order_date ASC, order_id ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM orders
ORDER BY order_date, order_id;

-- RFM (1 Group By duy nhất)
-- Tránh quét bảng orders 3 lần riêng biệt
SELECT
    c.customer_id,
    (NOW()::date - MAX(order_date)::date) AS recency_days,
    COUNT(order_id) AS frequency,
    coalesce(SUM(order_total), 0) AS monetary
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1;