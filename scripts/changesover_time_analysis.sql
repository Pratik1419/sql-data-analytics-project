-- Chages Over The Years and Month in sales

SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quanity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)

-- Without use of year and month in a different place use DATETRUNC

SELECT 
DATETRUNC(month, order_date) AS order_date,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quanity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)