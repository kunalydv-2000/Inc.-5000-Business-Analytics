/*
===========================================================
 File Name : 03_exploratory_analysis.sql
 Project   : Inc. 5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Kunal Yadav
===========================================================

Description
-----------
This script performs Exploratory Data Analysis (EDA)
to understand the dataset before answering business
questions.

Analysis Includes
-----------------
1. Dataset Overview
2. Descriptive Statistics
3. Distribution Analysis
4. Industry Analysis
5. Geographic Analysis
6. Revenue Analysis
7. Growth Analysis
8. Employee Analysis
9. Correlation Indicators

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
1. Dataset Overview
=========================================================*/

SELECT
    COUNT(*) AS total_companies,
    COUNT(DISTINCT industry_name) AS total_industries,
    COUNT(DISTINCT state_code) AS total_states,
    COUNT(DISTINCT city_name) AS total_cities,
    COUNT(DISTINCT metro_area) AS total_metro_areas
    FROM inc5000_cleaned;
GO


/*=========================================================
2. Revenue Statistics
=========================================================*/

SELECT

MIN(annual_revenue_usd) AS minimum_revenue,

MAX(annual_revenue_usd) AS maximum_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue,

SUM(annual_revenue_usd) AS total_revenue
FROM inc5000_cleaned;

GO


/*=========================================================
3. Growth Statistics
=========================================================*/

SELECT

MIN(growth_rate_percent) AS minimum_growth,

MAX(growth_rate_percent) AS maximum_growth,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth
FROM inc5000_cleaned;

GO


/*=========================================================
4. Employee Statistics
=========================================================*/

SELECT

MIN(employee_count) AS minimum_employees,

MAX(employee_count) AS maximum_employees,

AVG(CAST(employee_count AS DECIMAL(18,2))) AS average_employees,

SUM(employee_count) AS total_employees
FROM inc5000_cleaned;

GO


/*=========================================================
5. Companies by Industry
=========================================================*/

SELECT

industry_name,

COUNT(*) AS total_companies

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY total_companies DESC;
GO


/*=========================================================
6. Companies by State
=========================================================*/

SELECT

state_name,

COUNT(*) AS total_companies

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY total_companies DESC;
GO


/*=========================================================
7. Companies by City
=========================================================*/

SELECT TOP (20)

city_name,

COUNT(*) AS total_companies

FROM inc5000_cleaned

GROUP BY city_name

ORDER BY total_companies DESC;
GO


/*=========================================================
8. Companies by Metro Area
=========================================================*/

SELECT TOP (20)

metro_area,

COUNT(*) AS total_companies

FROM inc5000_cleaned

WHERE metro_area IS NOT NULL

GROUP BY metro_area

ORDER BY total_companies DESC;
GO


/*=========================================================
9. Revenue by Industry
=========================================================*/

SELECT

industry_name,

COUNT(*) AS companies,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY total_revenue DESC;
GO


/*=========================================================
10. Revenue by State
=========================================================*/

SELECT

state_name,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY total_revenue DESC;
GO


/*=========================================================
11. Average Growth by Industry
=========================================================*/

SELECT

industry_name,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY average_growth DESC;
GO


/*=========================================================
12. Average Growth by State
=========================================================*/

SELECT

state_name,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY average_growth DESC;
GO


/*=========================================================
13. Average Employees by Industry
=========================================================*/

SELECT

industry_name,

AVG(CAST(employee_count AS DECIMAL(18,2))) AS average_employees

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY average_employees DESC;
GO


/*=========================================================
14. Years on Inc.5000 List Distribution
=========================================================*/

SELECT

years_on_inc5000,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY years_on_inc5000

ORDER BY years_on_inc5000;
GO


/*=========================================================
15. Revenue Categories
=========================================================*/

SELECT

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'

WHEN annual_revenue_usd BETWEEN 10000000 AND 49999999 THEN '$10M - $49M'

WHEN annual_revenue_usd BETWEEN 50000000 AND 99999999 THEN '$50M - $99M'

ELSE '$100M+'

END AS revenue_category,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'

WHEN annual_revenue_usd BETWEEN 10000000 AND 49999999 THEN '$10M - $49M'

WHEN annual_revenue_usd BETWEEN 50000000 AND 99999999 THEN '$50M - $99M'

ELSE '$100M+'

END

ORDER BY companies DESC;
GO


/*=========================================================
16. Employee Size Categories
=========================================================*/

SELECT

CASE

WHEN employee_count <= 10 THEN '1-10'

WHEN employee_count <= 50 THEN '11-50'

WHEN employee_count <= 250 THEN '51-250'

WHEN employee_count <= 1000 THEN '251-1000'

ELSE '1000+'

END AS company_size,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY

CASE

WHEN employee_count <= 10 THEN '1-10'

WHEN employee_count <= 50 THEN '11-50'

WHEN employee_count <= 250 THEN '51-250'

WHEN employee_count <= 1000 THEN '251-1000'

ELSE '1000+'

END

ORDER BY companies DESC;
GO


/*=========================================================
17. Growth Categories
=========================================================*/

SELECT

CASE

WHEN growth_rate_percent < 100 THEN 'Low Growth'

WHEN growth_rate_percent < 500 THEN 'Moderate Growth'

WHEN growth_rate_percent < 1000 THEN 'High Growth'

ELSE 'Hyper Growth'

END AS growth_category,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY

CASE

WHEN growth_rate_percent < 100 THEN 'Low Growth'

WHEN growth_rate_percent < 500 THEN 'Moderate Growth'

WHEN growth_rate_percent < 1000 THEN 'High Growth'

ELSE 'Hyper Growth'

END

ORDER BY companies DESC;
GO


/*=========================================================
18. Revenue Per Employee
=========================================================*/

SELECT TOP (20)

company_name,

annual_revenue_usd,

employee_count,

CASE
WHEN employee_count = 0 THEN NULL
ELSE CAST(annual_revenue_usd AS DECIMAL(18,2)) / employee_count
END AS revenue_per_employee

FROM inc5000_cleaned

WHERE employee_count > 0

ORDER BY revenue_per_employee DESC;
GO


/*=========================================================
19. Correlation Indicators
=========================================================*/

SELECT

AVG(CAST(employee_count AS DECIMAL(18,2))) AS avg_employees,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS avg_revenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS avg_growth

FROM inc5000_cleaned;

GO


/*=========================================================
20. Exploratory Summary
=========================================================*/

SELECT

COUNT(*) AS total_companies,

COUNT(DISTINCT industry_name) AS industries,

COUNT(DISTINCT state_name) AS states,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth,

AVG(CAST(employee_count AS DECIMAL(18,2))) AS average_employees

FROM inc5000_cleaned;
GO