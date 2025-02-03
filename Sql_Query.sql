drop table if exists sales;
create table sales
(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int, 
	gender varchar(15),
	age int,
	category varchar(11),
	quantity int,
	price_per_unit float,
	cogs float,
	total_sale  float

)
select * from sales;

select count(*) from sales;

select * from sales where transactions_id is null;
select * from sales where sale_date is null;

select * from sales 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null

-- Data exploration

-- How many sales we have?
select count(*) as total_sales from sales 

-- How many unique customers we have
select count(distinct customer_id) as num_customers from sales 

select distinct category from sales 

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL Query to retrieve all columns for sales made on '2022-11-05'

select * from sales where sale_date ='2022-11-05'

-- Q.2 Write a SQL Query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold more than 4 in the month of Nov-2022

select *
from sales
where category = 'Clothing'
and
to_char(sale_date,'YYYY-MM') = '2022-11' 
and
quantity>=4

-- Q.3 Write a SQL Query to calculate the total sales(total_sales) for each category

select category,sum(total_sale) as net_sales,count(*) as total_orders from sales group by category

-- Q.4 write a sql query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age),2)
from sales 
where category='Beauty'

-- Q.5 Write a SQL query to find all the transactions where the total_sale is greater than 1000
select * from sales where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

select category,gender ,count(*) as num_transactions
from sales
group by category,gender
order by 1

-- Q.7 	Write a sql query to calculate the average sale for each month. Find out best selling month in each year
select year,month,avg_sales from
(select
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from sales
group by 1,2 ) as t1
where rank = 1
-- order by 1, 3 desc

-- Q.8 write a sql query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales from sales
group by 1 order by 2 desc limit 5

-- Q.9 Write a sql query to find the number of unique customers who purchased items from each category
select category,
count(distinct customer_id) as num_unique_customers
from sales
group by category


-- Q.10 Write a sql query to create each shift and number of orders (example morning<=12, afternoon between 12 and 17, Evening>17)
with hourly_sale 
as
(select *,
case 
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening' end as shift 
from sales)

select shift,
count(*) as total_orders 
from hourly_sale
group by shift

-- select extract(hour from sale_time) from sales
