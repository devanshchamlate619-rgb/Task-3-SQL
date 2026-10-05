USE ecommerce_sql_analysis;

-- ============================================================
-- TASK 3: SQL FOR DATA ANALYSIS
-- Dataset: Ecommerce
-- Database: MySQL
-- ============================================================


-- ============================================================
-- 1. DATABASE / TABLE STRUCTURE
-- ============================================================

SHOW TABLES;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE carts;
DESCRIBE wishlists;


-- ============================================================
-- 2. OVERALL SALES PERFORMANCE
-- Uses aggregate functions: COUNT, SUM, AVG, MAX
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_items_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    ROUND(MAX(total_amount), 2) AS highest_order_value
FROM orders;


-- ============================================================
-- 3. SALES PERFORMANCE BY PRODUCT CATEGORY
-- Uses INNER JOIN, GROUP BY, ORDER BY and aggregates
-- ============================================================

SELECT
    p.category,
    COUNT(o.id) AS total_orders,
    SUM(o.quantity) AS total_items_sold,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- 4. MONTHLY SALES TREND
-- Uses DATE_FORMAT, GROUP BY and ORDER BY
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_items_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- ============================================================
-- 5. TOP 10 CUSTOMERS BY TOTAL SPENDING
-- Uses INNER JOIN, GROUP BY, ORDER BY and LIMIT
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================
-- 6. TOP-SELLING PRODUCTS
-- ============================================================

SELECT
    p.id AS product_id,
    p.category,
    SUM(o.quantity) AS total_quantity_sold,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.id
GROUP BY
    p.id,
    p.category
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- ============================================================
-- 7. ORDERS WITH HIGH-VALUE PURCHASES
-- Uses WHERE and ORDER BY
-- ============================================================

SELECT
    id AS order_id,
    customer_id,
    product_id,
    quantity,
    total_amount,
    order_date
FROM orders
WHERE total_amount > 1000
ORDER BY total_amount DESC;


-- ============================================================
-- 8. LEFT JOIN
-- Show all customers and their orders
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.id AS order_id,
    o.total_amount,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
ORDER BY c.id;


-- ============================================================
-- 9. RIGHT JOIN
-- Show all orders and their customer details
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.id AS order_id,
    o.total_amount,
    o.order_date
FROM customers c
RIGHT JOIN orders o
    ON c.id = o.customer_id
ORDER BY o.id;


-- ============================================================
-- 10. FULL OUTER JOIN SIMULATION
-- MySQL does not provide FULL OUTER JOIN directly.
-- LEFT JOIN + RIGHT JOIN are combined using UNION.
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.id AS order_id,
    o.total_amount,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id

UNION

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.id AS order_id,
    o.total_amount,
    o.order_date
FROM customers c
RIGHT JOIN orders o
    ON c.id = o.customer_id

ORDER BY customer_id;


-- ============================================================
-- 11. CUSTOMERS WHO HAVE NEVER PLACED AN ORDER
-- Uses LEFT JOIN + IS NULL
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE o.id IS NULL
ORDER BY c.id;


-- ============================================================
-- 12. CUSTOMER ORDER FREQUENCY AND SPENDING
-- Uses LEFT JOIN, COUNT, SUM and COALESCE
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS total_spent
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC, total_spent DESC;


-- ============================================================
-- 13. HIGH-VALUE CUSTOMERS: SPENDING ABOVE AVERAGE
-- Uses a subquery
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) AS customer_spending
)
ORDER BY total_spent DESC;


-- ============================================================
-- 14. CUSTOMER SEGMENTATION BASED ON TOTAL SPENDING
-- Uses CASE expression
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    CASE
        WHEN SUM(o.total_amount) >= 10000 THEN 'High Value'
        WHEN SUM(o.total_amount) >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;


-- ============================================================
-- 15. CUSTOMERS WHO HAVE SPENT MORE THAN 5000
-- Uses HAVING
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
HAVING SUM(o.total_amount) > 5000
ORDER BY total_spent DESC;


-- ============================================================
-- 16. CUSTOMER ORDER FREQUENCY
-- Uses COUNT and CASE
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    CASE
        WHEN COUNT(o.id) = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC;


-- ============================================================
-- 17. AVERAGE ORDER VALUE BY CUSTOMER
-- Uses AVG
-- ============================================================

SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name
ORDER BY average_order_value DESC;


-- ============================================================
-- 18. CREATE A VIEW FOR CUSTOMER SPENDING
-- Demonstrates SQL views
-- ============================================================

CREATE OR REPLACE VIEW customer_spending AS
SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY
    c.id,
    c.first_name,
    c.last_name;


-- Query the view

SELECT *
FROM customer_spending
ORDER BY total_spent DESC;


-- ============================================================
-- 19. QUERY OPTIMIZATION WITH EXPLAIN
-- Check execution plan for customer_id
-- ============================================================

EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 71;


-- ============================================================
-- 20. EXPLAIN BEFORE INDEXING order_date
-- ============================================================

EXPLAIN
SELECT *
FROM orders
WHERE order_date >= '2023-01-01';


-- ============================================================
-- 21. CREATE INDEX ON order_date
-- ============================================================

CREATE INDEX idx_orders_order_date
ON orders(order_date);


-- ============================================================
-- 22. EXPLAIN AFTER INDEXING order_date
-- ============================================================

EXPLAIN
SELECT *
FROM orders
WHERE order_date >= '2023-01-01';


-- ============================================================
-- 23. VERIFY THE INDEX
-- ============================================================

SHOW INDEX FROM orders;


-- ============================================================
-- 24. FINAL EXPLAIN CHECK
-- Confirms that the order_date index is being used.
-- ============================================================

EXPLAIN
SELECT *
FROM orders
WHERE order_date >= '2023-01-01';


-- ============================================================
-- END OF TASK 3
-- ============================================================
