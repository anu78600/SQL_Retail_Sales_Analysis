# 🛒 SQL Retail Sales Analysis

##  Project Overview

This project focuses on analyzing **retail sales transaction data using SQL** to uncover customer behavior, sales performance, product category trends, and operational patterns.

The analysis covers the complete process from **table creation and data cleaning to exploratory analysis and business-focused SQL queries**.

The goal is to transform raw retail transaction data into meaningful insights that can support better business and sales decisions.

---

##  Project Objective

The main objectives of this project are to:

* Clean and prepare retail transaction data for analysis.
* Explore sales and customer information using SQL.
* Analyze sales performance across product categories.
* Understand customer purchasing behavior.
* Identify high-value customers.
* Analyze monthly sales performance.
* Understand sales patterns across different time shifts.
* Answer practical business questions using SQL.

---

## 🗂️ Dataset / Table Structure

The project uses a table named:

`retail_sales`

### Table Columns

| Column            | Data Type | Description                   |
| ----------------- | --------- | ----------------------------- |
| `transactions_id` | INT       | Unique transaction identifier |
| `sale_date`       | DATE      | Date of the transaction       |
| `sale_time`       | TIME      | Time of the transaction       |
| `customer_id`     | INT       | Unique customer identifier    |
| `gender`          | VARCHAR   | Customer gender               |
| `age`             | INT       | Customer age                  |
| `category`        | VARCHAR   | Product category              |
| `quantity`        | INT       | Number of items purchased     |
| `price_per_unit`  | FLOAT     | Price per item                |
| `cogs`            | FLOAT     | Cost of goods sold            |
| `total_sale`      | FLOAT     | Total transaction value       |

---

#  1. Database & Table Creation

The retail sales table was created using the following SQL query:

```sql
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

To verify the imported data:

```sql
SELECT *
FROM retail_sales
LIMIT 30;
```

---

#  2. Data Cleaning

Before performing analysis, the dataset was checked for missing values across the important columns.

### Checking NULL Values

```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL;

SELECT *
FROM retail_sales
WHERE sale_time IS NULL;

SELECT *
FROM retail_sales
WHERE customer_id IS NULL;

SELECT *
FROM retail_sales
WHERE gender IS NULL;

SELECT *
FROM retail_sales
WHERE age IS NULL;

SELECT *
FROM retail_sales
WHERE category IS NULL;

SELECT *
FROM retail_sales
WHERE quantity IS NULL;

SELECT *
FROM retail_sales
WHERE price_per_unit IS NULL;

SELECT *
FROM retail_sales
WHERE cogs IS NULL;

SELECT *
FROM retail_sales
WHERE total_sale IS NULL;
```

The analysis identified missing values in fields such as:

* `age`
* `quantity`
* `price_per_unit`
* `cogs`
* `total_sale`

### Removing Incomplete Transactions

Transactions containing NULL values in required fields were removed:

```sql
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

---

#  3. Exploratory Data Analysis

## Total Number of Sales

```sql
SELECT COUNT(*) AS total_sales
FROM retail_sales;
```

This provides the total number of completed sales transactions available for analysis.

---

## Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id) AS customers_we_have
FROM retail_sales;
```

This identifies the number of unique customers represented in the dataset.

---

## Total Product Categories

```sql
SELECT COUNT(DISTINCT category) AS total_category
FROM retail_sales;
```

To view the individual categories:

```sql
SELECT DISTINCT category
FROM retail_sales;
```

---

#  4. Business Questions & SQL Solutions

## Q1. Retrieve all sales made on November 5, 2022

### Business Question

> What transactions were made on November 5, 2022?

### SQL Solution

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'
ORDER BY transactions_id DESC;
```

### Purpose

This query helps analyze the transactions generated on a specific business date.

---

# Q2. Find Clothing transactions with more than 3 items sold in November 2022

### Business Question

> Which Clothing transactions had a quantity greater than 3 during November 2022?

### SQL Solution

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```

### Alternative Approach

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

### Purpose

This helps identify higher-volume Clothing purchases during a specific month.

---

# Q3. Calculate total sales for each category

### Business Question

> How much revenue was generated by each product category?

### SQL Solution

```sql
SELECT
    category,
    SUM(total_sale) AS total_sales_category,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### Purpose

This provides a category-level view of:

* Total sales revenue
* Number of orders

This can help identify categories contributing significantly to overall sales.

---

# Q4. Find the average customer age for the Beauty category

### Business Question

> What is the average age of customers purchasing Beauty products?

### SQL Solution

```sql
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Purpose

This helps understand the customer demographic associated with the Beauty category.

---

# Q5. Find transactions with sales greater than 1000

### Business Question

> Which transactions generated more than 1000 in sales?

### SQL Solution

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY transactions_id DESC;
```

### Purpose

This identifies high-value transactions that may be useful for understanding premium purchases and customer spending behavior.

---

# Q6. Find the number of transactions by gender and category

### Business Question

> How many transactions were made by each gender within each product category?

### SQL Solution

```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender;
```

### Purpose

This query provides a breakdown of transaction volume based on:

* Product category
* Customer gender

This can help businesses understand purchasing patterns across customer segments.

---

# Q7. Find the best-selling month in each year

### Business Question

> Which month had the highest average sale in each year?

### SQL Solution

```sql
SELECT *
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER
        (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rank = 1;
```

### SQL Concepts Used

* `EXTRACT()`
* `AVG()`
* `GROUP BY`
* `RANK()`
* Window Functions
* `PARTITION BY`
* Subqueries

### Purpose

This identifies the strongest-performing month based on average transaction value for each year.

---

# Q8. Find the Top 5 Customers by Total Sales

### Business Question

> Who are the five customers contributing the highest total sales?

### SQL Solution

```sql
SELECT
    customer_id,
    SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sales DESC
LIMIT 5;
```

### Purpose

This helps identify high-value customers and provides insight into customer contribution to revenue.

---

# Q9. Find unique customers for each category

### Business Question

> How many unique customers purchased products from each category?

### SQL Solution

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### Purpose

This measures the customer reach of each product category.

A category with many unique customers may have broader customer adoption compared with a category purchased by a smaller customer base.

---

# Q10. Analyze sales by time-based shifts

### Business Question

> How many orders were placed during Morning, Afternoon, and Evening shifts?

### Shift Definition

| Shift     | Time         |
| --------- | ------------ |
| Morning   | Before 12 PM |
| Afternoon | 12 PM – 5 PM |
| Evening   | After 5 PM   |

### SQL Solution

```sql
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12
                THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
                THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

### SQL Concepts Used

* `WITH` / CTE
* `CASE`
* `EXTRACT()`
* `COUNT()`
* `GROUP BY`

### Purpose

This analysis helps understand when customers are most active and can support decisions around staffing, promotions, and store operations.

---

#  SQL Concepts Demonstrated

This project helped me practice and apply several important SQL concepts:

* `CREATE TABLE`
* `SELECT`
* `WHERE`
* `AND / OR`
* `IS NULL`
* `DELETE`
* `COUNT()`
* `COUNT(DISTINCT)`
* `SUM()`
* `AVG()`
* `ROUND()`
* `GROUP BY`
* `ORDER BY`
* `LIMIT`
* `DISTINCT`
* `BETWEEN`
* `TO_CHAR()`
* `EXTRACT()`
* `CASE`
* CTEs (`WITH`)
* Subqueries
* Window Functions
* `RANK()`
* `PARTITION BY`

---

#  Business Areas Covered

The analysis addresses several real-world retail business areas:

###  Sales Performance

* Category-wise revenue
* High-value transactions
* Monthly performance

###  Customer Analysis

* Unique customers
* Top customers
* Customer demographics
* Gender-based transaction analysis

###  Product Analysis

* Category performance
* Category customer reach
* Clothing purchase patterns

###  Operational Analysis

* Morning vs Afternoon vs Evening orders
* Customer activity by time period

---

#  Key Learning Outcomes

Through this project, I practiced how to:

1. Create and structure a SQL database table.
2. Identify and clean missing data.
3. Perform exploratory data analysis.
4. Translate business questions into SQL queries.
5. Aggregate data using `SUM()`, `AVG()`, and `COUNT()`.
6. Segment customers and transactions.
7. Use window functions for ranking.
8. Use CTEs for more structured queries.
9. Analyze sales trends across dates and time periods.
10. Approach SQL from a **business-analysis perspective**, rather than only writing queries.

---

#  Project Workflow

```text
Raw Retail Data
       ↓
Table Creation
       ↓
Data Validation
       ↓
NULL Value Detection
       ↓
Data Cleaning
       ↓
Exploratory Analysis
       ↓
Business Questions
       ↓
SQL Analysis
       ↓
Business Insights
```

---

#  Tools Used

* **SQL**
* **PostgreSQL**
* **GitHub**

---

# 📂 Project Structure

```text
SQL-Retail-Sales-Analysis/
│
├── README.md
│
├── retail_sales.sql
│
└── dataset/
    └── retail_sales.csv
```

---

# 👨‍💻 About the Project

This project is part of my journey toward becoming a **Data Analyst**.

Instead of focusing only on SQL syntax, I used this project to practice solving **real-world business questions with SQL**, including sales analysis, customer segmentation, category performance, and operational analysis.

> **Learn → Practice → Build → Analyze → Improve**

---

## ⭐ Skills Demonstrated

**SQL | Data Cleaning | Data Analysis | Exploratory Data Analysis | Business Analysis | Customer Analysis | Sales Analysis | PostgreSQL | Window Functions | CTEs**

