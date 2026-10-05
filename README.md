# E-Commerce SQL Analysis

## Project Overview

This project analyzes an e-commerce transaction database using MySQL.

The analysis focuses on sales performance, customer behavior, product performance,
SQL joins, customer segmentation, views, and query optimization using indexes.

## Database

Database: `ecommerce_sql_analysis`

Main tables:
- customers
- products
- orders
- carts
- wishlists

## Analysis Performed

### 1. Overall Sales Performance
Calculated:
- Total orders
- Total items sold
- Total revenue
- Average order value
- Highest order value

### 2. Product Category Analysis
Analyzed sales performance by product category.

### 3. Monthly Sales Trend
Analyzed monthly:
- Orders
- Items sold
- Revenue

### 4. Customer Analysis
Analyzed:
- Top customers by spending
- Customer order frequency
- Average order value
- High-value customers
- Customers with no orders

### 5. Product Analysis
Identified the top-selling products based on quantity sold and revenue.

### 6. Customer Segmentation
Customers were classified into:
- High Value
- Medium Value
- Low Value

based on total spending.

### 7. SQL Joins
Demonstrated:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN simulation using UNION

### 8. SQL View
Created a `customer_spending` view containing customer order and spending information.

### 9. Query Optimization
Used `EXPLAIN` to analyze query execution and created an index on
`orders.order_date`.

## Files

- `ecommerce_analysis.sql` — Complete SQL analysis
- `screenshots/` — Screenshots showing query outputs and analysis results

## Tools Used

- MySQL
- MySQL Workbench
- SQL

## Key Learning Outcomes

This project demonstrates practical use of SQL for:
- Data aggregation
- Filtering
- Joins
- Subqueries
- CASE statements
- Views
- Indexing
- Query optimization
