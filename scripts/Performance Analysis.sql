-- Performance Analysis

-- Comparing the current value to a target value.


/* Analze the yearly performance of products by comparing their sales 
to both average sales performance of the product and the previous year's sales */

WITH yearly_products_sales AS
(
	SELECT
	YEAR(f.order_date) AS order_year,
	p.product_name,
	SUM(f.sales_amount) AS currents_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = f.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
order_year,
product_name,
currents_sales,
AVG(currents_sales) OVER (PARTITION BY product_name) AS avg_sales,
currents_sales - AVG(currents_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN currents_sales - AVG(currents_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN currents_sales - AVG(currents_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_change,
LAG(currents_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
currents_sales - LAG(currents_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN currents_sales - LAG(currents_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN currents_sales - LAG(currents_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END py_change
FROM yearly_products_sales
ORDER BY product_name, order_year;