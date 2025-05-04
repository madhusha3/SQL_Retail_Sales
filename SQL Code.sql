-- Retail Sales Analysis SQL Project
CREATE DATABASE sql_project_p1;

--Create a Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
							transactions_id INT PRIMARY KEY,
							sale_date DATE,
							sale_time TIME,
							customer_id INT,
							gender VARCHAR(15),
							age INT,
							category VARCHAR(15),	
							quantiy INT,
							price_per_unit FLOAT,	
							cogs FLOAT,
							total_sale FLOAT
)

SELECT * FROM retail_sales;

-- Count total rows in table
SELECT COUNT(*) 
FROM retail_sales;

-- Look for NULL values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'retail_sales';

SELECT 
    'SELECT * FROM retail_sales WHERE ' || 
    string_agg(column_name || ' IS NULL', ' OR ') || ';'
FROM 
    information_schema.columns
WHERE 
    table_name = 'retail_sales'
    AND table_schema = 'public';  -- change this if it's not public

-- Look for NULL values
SELECT 
  * 
FROM 
  retail_sales 
WHERE 
  transactions_id IS NULL 
  OR sale_date IS NULL 
  OR sale_time IS NULL 
  OR customer_id IS NULL 
  OR gender IS NULL 
  OR age IS NULL 
  OR category IS NULL 
  OR quantiy IS NULL 
  OR price_per_unit IS NULL 
  OR cogs IS NULL 
  OR total_sale IS NULL;
  
--Check How Many NULLs Each Column Has
SELECT
  COUNT(*) FILTER (WHERE transactions_id IS NULL) AS transactions_id_nulls,
  COUNT(*) FILTER (WHERE sale_date IS NULL) AS sale_date_nulls,
  COUNT(*) FILTER (WHERE sale_time IS NULL) AS sale_time_nulls,
  COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
  COUNT(*) FILTER (WHERE gender IS NULL) AS gender_nulls,
  COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
  COUNT(*) FILTER (WHERE category IS NULL) AS category_nulls,
  COUNT(*) FILTER (WHERE quantiy IS NULL) AS quantiy_nulls,
  COUNT(*) FILTER (WHERE price_per_unit IS NULL) AS price_per_unit_nulls,
  COUNT(*) FILTER (WHERE cogs IS NULL) AS cogs_nulls,
  COUNT(*) FILTER (WHERE total_sale IS NULL) AS total_sale_nulls
FROM retail_sales;

-- Delete NUll Values from the Table
DELETE FROM retail_sales
WHERE 
transactions_id IS NULL 
  OR sale_date IS NULL 
  OR sale_time IS NULL 
  OR customer_id IS NULL 
  OR gender IS NULL 
  OR age IS NULL 
  OR category IS NULL 
  OR quantiy IS NULL 
  OR price_per_unit IS NULL 
  OR cogs IS NULL 
  OR total_sale IS NULL;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

-- DATA EXPLORATION

--1: How many sales we have?
SELECT COUNT(*) AS Total_Sales FROM retail_sales;

--2. How many Unique customers we have?
SELECT COUNT(DISTINCT(customer_id)) AS Total_Customers FROM retail_sales;

--3. How many Unique Category we have?
SELECT DISTINCT(category) AS Category FROM retail_sales;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

--3. Data Analysis & Findings

-- The following SQL queries were developed to answer specific business questions:

--My Analysis and Finding 
SELECT * FROM retail_sales;

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

-- 2. Write a SQL query to retrieve all transactions where the category is 
-- 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT 
  * 
FROM 
  retail_sales 
WHERE 
  category = 'Clothing' 
  AND TO_CHAR (sale_date, 'YYYY-MM') = '2022-11' 
  AND quantiy >= 4;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

SELECT * FROM retail_sales;
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
	SUM(total_sale) AS Total_Sales, 
	category,
	COUNT(quantiy) AS Total_Orders
FROM retail_sales
	GROUP BY category;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
	ROUND(AVG(age),2) AS Avg_Age
FROM retail_sales
WHERE category = 'Beauty';

SELECT 
	ROUND(AVG(age),2) AS Avg_Age,
	gender
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY gender;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

SELECT * FROM retail_sales;
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * 
FROM retail_sales
WHERE total_sale >= 1000;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

SELECT * FROM retail_sales;
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(DISTINCT(transactions_id)) AS Total_Transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY category;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

SELECT * FROM retail_sales;
--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_monthly_sales,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank -- ✅ gave alias here!
    FROM retail_sales
    GROUP BY year, month
	--ORDER BY year, avg_monthly_sales DESC;
) AS T1
WHERE sales_rank = 1;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿


SELECT * FROM retail_sales;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;
--  It adds up all their purchases.

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

SELECT * FROM retail_sales;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
	COUNT(DISTINCT(customer_id)) AS Count_of_Unique_Customers,
	category
FROM retail_sales
GROUP BY category;

-- 🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿


SELECT * FROM retail_sales;

-- 10. Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift

FROM retail_sales
)
SELECT 
	shift,
	COUNT(transactions_id) AS Total_Orders
FROM hourly_sale
GROUP BY shift;

SELECT EXTRACT(HOUR FROM CURRENT_TIME)

-- END OF PROJECT :)
