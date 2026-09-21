-- Sql Retail Sales Analysis - P01

-- Creating the Table

Create Table retail_sales
(
		transactions_id INT Primary KEY,
		sale_date DATE,
		sale_time Time,
		customer_id INT,
		gender Varchar(15),
		age INT,
		category Varchar(20),
		quantity INT,
		price_per_unit Float,
		cogs Float,
		total_sale Float
);

Select * From retail_sales Limit 30;


Select 
	Count(*) 
From retail_sales;


-- Checking NULL values in the every column

Select * From retail_sales
Where transactions_id IS NULL;

Select * From retail_sales
Where sale_date IS NULL;

Select * From retail_sales
Where sale_time IS NULL;

Select * From retail_sales
Where customer_id IS NULL;

Select * From retail_sales
Where gender IS NULL;

Select * From retail_sales
Where age IS NULL; -- age have null values.

Select * From retail_sales
Where category IS NULL;

Select * From retail_sales
Where quantity IS NULL; -- quantity have null values.

Select * From retail_sales
Where price_per_unit IS NULL; -- price_per_unit have null values


Select * From retail_sales
Where cogs IS NULL; -- cogs have null values.

Select * From retail_sales
Where total_sale IS NULL; --total_sale have null values.

-- Deleting the null values 

Delete From retail_sales
Where
	transactions_id Is NUll
	OR
	sale_date IS NUll
	OR
	sale_time Is NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

Select * From retail_sales

-- Data Exploration....

-- How many sales we have?

Select Count(*) AS total_sales From retail_sales;

-- How many unique customers we have?

Select Count(Distinct customer_id) as customers_we_have From retail_sales;

-- Total unique category we have..

Select Count(Distinct category) AS Total_category From retail_sales;
-----------------------------------------------------------------------
Select Distinct category AS Total_category From retail_sales;


--- DATA Analysis & Business key problems & answers.

-- Q1. Write a sql query to retrive all columns for sales made on 2022-11-05

Select * From retail_sales
where sale_date = '2022-11-05'
Order By transactions_id DESC;

-- Q2. Write a Sql query to retrive all transactions where the category is 'clothing' and the quantity sold is more than 10 in the month of NOV-2022

Select *
From retail_sales
Where category = 'Clothing' AND quantity > 3 And TO_Char(sale_date,'YYYY-MM') = '2022-11';
-----------------------------------------------------------------------------------------------------------------------------
Select * From retail_sales
Where category = 'Clothing' And quantity > 3 And sale_date Between '2022-11-01' And '2022-11-30';


-- Q3. Write a sql query to calculate the total sales(total_sale) for each category.

Select Distinct category, Sum(total_sale) AS Total_Sales_Catg, Count(*) AS total_orders From retail_sales
Group By category;

-- Q4. Write a SQL query to find the average age of customers who purchased items for the "Beauty" category.

Select Round(AVG(age),2) AS avg_age From retail_sales
Where category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greter than 1000.

Select * From retail_sales
Where total_sale > 1000
Order BY transactions_id DESC;

-- Q6. Write a sql query to find the total number of transactions (transactions_id) made by each gender in each category.

Select Distinct(category), gender , Count(transactions_id) AS total_trans
From retail_sales
Group By category,gender;

-- Q7. Write a Sql query to calculate the average sale for each month. Find out best selling month in each year.

Select * From
	(
			Select 
				Extract(Year From sale_date) AS year,
				Extract(Month From sale_date) AS month,
				Avg(total_sale) as avg_sale,
				Rank() Over(Partition BY Extract(Year From sale_date) Order by AVG(total_sale) DESC) AS Rank
		
			From retail_sales
			Group By year, month
			
	) AS t1
Where Rank = 1;

-- Q8. Write a Sql query to find the top 5 customers based on the highest total sales.

Select Distinct Customer_id, Sum(total_sale) as net_sales

From retail_sales
Group By customer_id
Order By net_sales DESC Limit 5;

-- Q9. Write a SQL query to find the number of the unique customers who purchased items for each category.

Select Count(Distinct customer_id) AS Unique_customer,category 
From retail_sales
Group By category;

-- Q10. Write a SQL query to create each shift and number of orders(Examole Morning <=12, Afternoon Between 12 & 17, Evening >17)

With hourly_sale
AS 
(
Select *,
	Case
		When Extract(HOUR From sale_time) < 12 Then 'Morning'
		When Extract(HOUR From sale_time) Between 12 And 17 Then 'Afternoon'
		Else 'Evening'
	End as Shift
From retail_sales
)


Select 
Shift,
Count(*) AS total_orders
From hourly_sale
Group By Shift;


