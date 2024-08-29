# Creating database 
use sqlproject;

# load the dataset into my sql workbench using python with pandas
select * from retail_sales;

# getting null values for each column 
select * from retail_sales 
where transactions_id is null 
or sale_date is null 
or sale_time is null 
or customer_id is null
or gender is null 
or age is null
or category is null 
or quantity is null 
or price_per_unit is null
or cogs is null
or total_sale is null;

--
#check out how many rows are in my dataset 2000 
select count(*) as total_count from retail_sales;

#delete the null rows
delete from retail_sales
where 
transactions_id is null
or sale_date is null 
or sale_time is null 
or customer_id is null
or gender is null 
or age is null
or category is null 
or quantity is null 
or price_per_unit is null
or cogs is null
or total_sale is null;


-- data exploration 
-- 1)how many sales we have
select count(*) as total_sales from retail_sales;

-- 2)How many uniuque customers we have ?
select count(distinct customer_id) from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Solution

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4  in the month of Nov-2022
select * 
from retail_sales 
where category = 'Clothing'
and quantity >=4
and sale_date like '2022-11%';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales_for_each_category,
count(*) as total_orders
from retail_sales 
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retial_sales 
where total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(*) as total_transaciton 
from retail_sales
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte as
(select round(avg(total_sale),2) as average_total_sales,
extract(month from sale_date) as month,
extract(year from sale_date) as year ,
dense_rank() over(partition by extract(year from sale_date )  order by avg(total_sale) desc ) as rnk
from retail_sales
group by extract(month from sale_date ),extract( year from sale_date ))
select  month,year,average_total_sales
from cte 
where rnk  = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id , sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by sum(total_sale) desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as total_unique_customer
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale aS
(SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales)
SELECT shift,COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of the project
