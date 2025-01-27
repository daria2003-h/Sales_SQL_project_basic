# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.



--project--

SELECT * FROM pg_database;
--creating a new table

drop table if exists retail_sales;
create table retail_sales 
						(
							transactions_id int primary key,
							sale_date date,	
							sale_time time,	
							customer_id int,
							gender varchar (15),	
							age int,	
							category varchar(15),	
							quantiy int,	
							price_per_unit float,	
							cogs float,	
							total_sale float

								);
								
select *
from retail_sales
limit 20;

select 	
	count(*)
from retail_sales rs ;

--Data Cleaning--

select *
from retail_sales rs 
where transactions_id is null
		or sale_date is null	
		or sale_time is null
		or gender is null	
		or category is null	
		or quantiy is null		
		or cogs is null	
		or total_sale is null;
	
delete 
from retail_sales rs
where transactions_id is null
		or sale_date is null	
		or sale_time is null
		or gender is null	
		or category is null	
		or quantiy is null		
		or cogs is null	
		or total_sale is null;

--Data exploration--
--How many sales do we have?--
	
select count (*) as total_sales
from retail_sales rs; 
	
-- How many distinct customers do we have ?--
select count (distinct customer_id) as unique_customers 
from retail_sales rs ;

--How many unique categories do we have?--
select distinct category as unique_categories 
from retail_sales rs ;

--Data Analysis & Business Key Problems & Answers--


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select *
from retail_sales rs 
where sale_date > '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
--ALTER TABLE retail_sales
--RENAME COLUMN quantiy TO quantity;


select *
from retail_sales 
	where category = 'Clothing' 
		and quantity >= 4
		and to_char(sale_date, 'YYYY-MM') = '2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
	
select 
	category,
	sum(total_sale),
	count (*) as order_count
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	category, 
	gender, 
	round(avg(age),2) as average_age
from retail_sales
where category= 'Beauty'
group by 1,2;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail_sales 
where total_sale > 1000
order by sale_date ;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 	
	category, 
	gender,
	count(*) as transactions_count
from retail_sales 
group by 1,2
order by 1,2;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
			sale_year, 
			sale_month, 
			avg
from
			(select 
				extract( year from sale_date) as sale_year,
				extract( month from sale_date) as sale_month,
				avg(total_sale) as avg,
				rank() over 
					(partition by extract( year from sale_date) order by avg(total_sale) desc) as sales_rank
			from retail_sales
			group by 1,2) as t2
where sales_rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as sum_sales
from retail_sales 
group by customer_id 
order by sum_sales desc 
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
	count( distinct customer_id) as unique_customers
from retail_sales 
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales as
(select *,
	case
		when extract(hour from sale_time)< 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then  'Afternoon'
		else 'Evening'
	end as shift
from retail_sales)
select 
		shift,
		count (*) as number_oders
from hourly_sales
group by shift;



--End of the project--


