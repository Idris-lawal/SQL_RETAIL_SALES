
--- SQL RETAIL SALES PROJECT 1
CREATE DATABASE SQL_PROJECT_P1;


-- TABLE CREATION
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
		transactions_id	 int PRIMARY KEY,
		sale_date date,
		sale_time time,
		customer_id int,
		gender varchar(10),
		age	 int,
		categor varchar(50),	
		quantity int,	
		price_per_unit	Float,
		cogs	Float,
		total_sale Float
);


SELECT * FROM retail_sales
limit 10;

SELECT COUNT(*) as Total_rows
	from Retail_sales

--- DATA CLEANING

SELECT * FROM retail_sales
limit 10;


SELECT COUNT(*) as Total_rows
	from Retail_sales

SELECT *
FROM retail_sales
WHERE Transactions_id is null or
		sale_date is null or sale_time is null 
		or customer_id is null or gender is null 
		or age is null or categor is null
	  or quantity is null or price_per_unit is null 
	  or cogs is null or total_sale is null;

-- DELETE NULL 

Delete 
FROM retail_sales
WHERE Transactions_id is null or
		sale_date is null or sale_time is null 
		or customer_id is null or gender is null 
		or age is null or categor is null
	  or quantity is null or price_per_unit is null 
	  or cogs is null or total_sale is null;


-- DATA EXPLORATION
 -- how many sales
Select count(*) as Total_sales
	   FROM Retail_sales

-- how many unique customers

SELECT count(distinct (customer_id)) as Total_customers
		From retail_sales

-- uniques category

SELECT count(distinct (Categor)) as Total_customers
		From retail_sales


--- DATA ANALYSIS / BUSINESS PROBLEM & ANSWERS
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

	SELECT * 
		FROM Retail_sales
		where Sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--  and the quantity sold is more than 3 in the month of Nov-2022

		
	SELECT *
		FROM Retail_sales
		where categor = 'Clothing' 
		and  to_char(sale_date, 'YYYY-MM') = '2022-11'
		and quantity > 3; 


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

	SELECT categor, sum(total_sale) as Total_sales_category 
		From Retail_sales
	Group by categor
	Order by Total_sales_category desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

	select Round(avg(Age),0) as average_age
		from Retail_sales
		where categor = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

		SELECT *
			FROM Retail_sales
		    where total_sale > 1000
			
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

		SELECT Categor as Category,Gender, count(transactions_id) As Number_of_transactions
			FROM Retail_sales
		Group by Categor,Gender
		order by 1,Number_of_transactions desc


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT Year, Month, Average_sales
	FROM
(
		SELECT Extract(year from sale_date) as Year, Extract(Month From Sale_date) as month, Avg(total_sale) as average_sales,
					Rank() over (PArtition by Extract(year from sale_date) order by Avg(total_sale)desc ) as Avg_sale_rank
			FROM Retail_sales
		Group by 1,2
		Order by 1,3 desc
) p
	where Avg_sale_rank = 1;
		

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

	SELECT customer_id, sum(total_sale) as Total_sales
		FROM Retail_sales
	Group by Customer_id
	order by Total_sales desc
	limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

		SELECT Categor as Category, count(distinct Customer_id) as unique_customers 
			FROM Retail_sales
		Group by categor
		order by 2 desc;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_sales
as (
		SELECT  *, Case when Extract(Hour From Sale_time) < 12 then 'Morning'
					 when  Extract(Hour From Sale_time) BETWEEN 12 AND 17 then 'Afternoon'
					 Else 'Evening' end as Shift
			FROM Retail_sales
	 )
	 	 SELECT Shift, count(Transactions_id) as total_orders
		  From Hourly_sales
		  Group by 1
		  order by 2 desc