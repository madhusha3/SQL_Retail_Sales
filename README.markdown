# Retail Sales Analysis with PostgreSQL

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: PostgreSQL (`sql_project_p1`)  
**Level**: Intermediate  
**Objective**: Demonstrate proficiency in SQL for data analysis, cleaning, and deriving actionable business insights.

This project showcases my ability to leverage SQL in PostgreSQL to analyze retail sales data, addressing real-world business questions. Designed to mirror tasks performed by data analysts, it includes database setup, data cleaning, exploratory data analysis (EDA), and advanced querying to uncover trends and insights. This portfolio piece highlights my technical skills, analytical mindset, and ability to communicate findings effectively to stakeholders.

## Why This Project?

As a data analyst, I aim to transform raw data into meaningful insights. This project demonstrates:
- **SQL Proficiency**: Writing clean, efficient, and well-documented queries.
- **Data Cleaning**: Ensuring data integrity by handling missing values.
- **Business Acumen**: Answering targeted business questions to drive decision-making.
- **Portfolio Appeal**: A polished, professional project that aligns with industry expectations for data analyst roles.

## Project Objectives

1. **Database Setup**: Create and structure a PostgreSQL database for retail sales data.
2. **Data Cleaning**: Identify and resolve null values to ensure data quality.
3. **Exploratory Data Analysis**: Understand dataset characteristics, such as customer demographics and product categories.
4. **Business Insights**: Answer 10 key business questions using SQL to reveal sales trends, customer behavior, and operational patterns.

## Dataset Description

The `retail_sales` table contains transactional data with the following schema:

- **transactions_id**: Unique transaction identifier (Primary Key)
- **sale_date**: Date of the sale
- **sale_time**: Time of the sale
- **customer_id**: Unique customer identifier
- **gender**: Customer gender
- **age**: Customer age
- **category**: Product category (e.g., Clothing, Beauty)
- **quantity**: Number of units sold
- **price_per_unit**: Price per unit
- **cogs**: Cost of goods sold
- **total_sale**: Total sale amount

## Project Structure

### 1. Database Setup

Created a PostgreSQL database and table to store retail sales data:

```sql
CREATE DATABASE sql_project_p1;

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
);
```

### 2. Data Cleaning

Ensured data quality by identifying and removing null values:

- **Null Check**: Inspected all columns for missing data.
- **Null Count**: Quantified nulls per column for transparency.
- **Data Purification**: Deleted records with any null values to maintain integrity.

```sql
-- Check for null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
      customer_id IS NULL OR gender IS NULL OR age IS NULL OR
      category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR
      cogs IS NULL OR total_sale IS NULL;

-- Count nulls per column
SELECT
    COUNT(*) FILTER (WHERE transactions_id IS NULL) AS transactions_id_nulls,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS sale_date_nulls,
    -- ... (other columns)
    COUNT(*) FILTER (WHERE total_sale IS NULL) AS total_sale_nulls
FROM retail_sales;

-- Remove null records
DELETE FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
      customer_id IS NULL OR gender IS NULL OR age IS NULL OR
      category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR
      cogs IS NULL OR total_sale IS NULL;
```

### 3. Exploratory Data Analysis

Gained insights into the dataset's structure:

- **Total Sales**: Counted total transactions.
- **Unique Customers**: Identified distinct customers.
- **Product Categories**: Listed unique categories.

```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
SELECT DISTINCT category AS category FROM retail_sales;
```

### 4. Business Questions & SQL Queries

Developed queries to address 10 business questions, showcasing analytical depth:

1. **Sales on a Specific Date**: Write a SQL query to retrieve all columns for sales made on '2022-11-05.
   ```sql
   SELECT * FROM retail_sales
   WHERE sale_date = '2022-11-05';
   ```

2. **Clothing Sales in November 2022**: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
   ```sql
   SELECT * FROM retail_sales
   WHERE category = 'Clothing'
       AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
       AND quantiy >= 4;
   ```

3. **Total Sales by Category**: Write a SQL query to calculate the total sales (total_sale) for each category.
   ```sql
   SELECT category, SUM(total_sale) AS total_sales, COUNT(quantiy) AS total_orders
   FROM retail_sales
   GROUP BY category;
   ```

4. **Average Age in Beauty Category**: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
   ```sql
   SELECT ROUND(AVG(age), 2) AS avg_age, gender
   FROM retail_sales
   WHERE category = 'Beauty'
   GROUP BY gender;
   ```

5. **High-Value Transactions**: Write a SQL query to find all transactions where the total_sale is greater than 1000.
   ```sql
   SELECT * FROM retail_sales
   WHERE total_sale >= 1000;
   ```

6. **Transactions by Gender and Category**: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
   ```sql
   SELECT category, gender, COUNT(DISTINCT transactions_id) AS total_transactions
   FROM retail_sales
   GROUP BY category, gender
   ORDER BY category;
   ```

7. **Best-Selling Month per Year**: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
   ```sql
   SELECT year, month, avg_monthly_sales
   FROM (
       SELECT EXTRACT(YEAR FROM sale_date) AS year,
              EXTRACT(MONTH FROM sale_date) AS month,
              AVG(total_sale) AS avg_monthly_sales,
              RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
       FROM retail_sales
       GROUP BY year, month
   ) AS t1
   WHERE sales_rank = 1;
   ```

8. **Top 5 Customers**: Write a SQL query to find the top 5 customers based on the highest total sales.
   ```sql
   SELECT customer_id, SUM(total_sale) AS total_sales
   FROM retail_sales
   GROUP BY customer_id
   ORDER BY total_sales DESC
   LIMIT 5;
   ```

9. **Unique Customers by Category**: Write a SQL query to find the number of unique customers who purchased items from each category.
   ```sql
   SELECT category, COUNT(DISTINCT customer_id) AS count_of_unique_customers
   FROM retail_sales
   GROUP BY category;
   ```

10. **Orders by Shift**: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
    ```sql
    WITH hourly_sale AS (
        SELECT *,
               CASE
                   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
                   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                   ELSE 'Evening'
               END AS shift
        FROM retail_sales
    )
    SELECT shift, COUNT(transactions_id) AS total_orders
    FROM hourly_sale
    GROUP BY shift;
    ```

## Key Findings

- **Sales Patterns**: Identified peak sales periods and high-value transactions, enabling targeted marketing.
- **Customer Insights**: Analyzed demographics (e.g., average age in Beauty) to inform customer segmentation.
- **Category Performance**: Highlighted top-performing categories, aiding inventory decisions.
- **Operational Efficiency**: Shift-based analysis revealed staffing optimization opportunities.


## Tools & Technologies

- **Database**: PostgreSQL
- **SQL Skills**: DDL, DML, window functions, CTEs, aggregations
- **Environment**: Local PostgreSQL server (pgAdmin or similar)
- **Future Enhancements**: Python for visualizations, Tableau for dashboards

## How to Run This Project

1. **Clone the Repository**:
   ```bash
   git clone <your-repo-url>
   ```
2. **Set Up PostgreSQL**:
   - Install PostgreSQL and create a database named `sql_project_p1`.
   - Run the table creation script from `database_setup.sql`.
3. **Load Data**:
   - Import the retail sales dataset (CSV or SQL dump, available in the repository).
4. **Execute Queries**:
   - Use the queries in `analysis_queries.sql` to explore the data and generate insights.
5. **Explore Further**:
   - Modify queries to answer additional business questions or integrate with visualization tools.

## Why This Project Stands Out

- **Attention to Detail**: Comprehensive data cleaning ensures reliable results.
- **Business Relevance**: Queries address practical business scenarios, from sales forecasting to customer profiling.
- **Scalability**: The project structure supports extensions, such as advanced analytics or visualization integration.
- **Professional Presentation**: Clear documentation and structured code make it easy for hiring managers to review.

## About Me

I’m a passionate data analyst with a strong foundation in SQL, Python, and data visualization. This project is part of my portfolio to demonstrate my ability to extract insights from data and communicate them effectively. I’m eager to contribute my skills to a data-driven organization.

- **LinkedIn**: [[Your LinkedIn Profile URL](https://www.linkedin.com/in/madhusudann5397/)]
- **GitHub**: [[Your GitHub Profile URL](https://github.com/madhusha3)]
- **Email**: [iammadhusudan.n@gmail.com]

## Contact

For feedback, questions, or collaboration opportunities, please reach out via [iammadhusudan.n@gmail.com] or LinkedIn. I’m excited to connect with hiring managers and fellow data enthusiasts!

---

*Thank you for reviewing my project! I look forward to discussing how my skills can add value to your team.*
