/*
===========================================================
 File Name : 05_views.sql
 Project   : Inc. 5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Kunal Yadav
===========================================================

Description
-----------
Creates reusable SQL Views for reporting and business
analysis.

Views Included
--------------
1. Company Summary
2. Revenue Analysis
3. Growth Analysis
4. Industry Summary
5. State Summary
6. City Summary
7. Revenue Per Employee
8. Top Companies
9. Company Size
10. Executive Dashboard

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
1. Company Summary View
=========================================================*/

CREATE OR ALTER VIEW vw_company_summary
AS

SELECT

company_id,
company_rank,
company_name,
industry_name,
annual_revenue_usd,
growth_rate_percent,
employee_count,
city_name,
state_name,
years_on_inc5000

FROM inc5000_cleaned;
GO


/*=========================================================
2. Revenue Analysis View
=========================================================*/

CREATE OR ALTER VIEW vw_revenue_analysis
AS

SELECT

company_id,
company_name,
industry_name,
annual_revenue_usd,

CASE

WHEN annual_revenue_usd < 10000000
THEN 'Below $10M'

WHEN annual_revenue_usd < 50000000
THEN '$10M - $49M'

WHEN annual_revenue_usd < 100000000
THEN '$50M - $99M'

ELSE '$100M+'

END AS revenue_category

FROM inc5000_cleaned;
GO


/*=========================================================
3. Growth Analysis View
=========================================================*/

CREATE OR ALTER VIEW vw_growth_analysis
AS

SELECT

company_name,
industry_name,
growth_rate_percent,

CASE

WHEN growth_rate_percent < 100
THEN 'Low Growth'

WHEN growth_rate_percent < 500
THEN 'Moderate Growth'

WHEN growth_rate_percent < 1000
THEN 'High Growth'

ELSE 'Hyper Growth'

END AS growth_category

FROM inc5000_cleaned;
GO


/*=========================================================
4. Industry Summary View
=========================================================*/

CREATE OR ALTER VIEW vw_industry_summary
AS

SELECT

industry_name,

COUNT(*) AS total_companies,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth,

SUM(employee_count) AS total_employees

FROM inc5000_cleaned

GROUP BY industry_name;
GO


/*=========================================================
5. State Summary View
=========================================================*/

CREATE OR ALTER VIEW vw_state_summary
AS

SELECT

state_name,
state_code,

COUNT(*) AS total_companies,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth,

SUM(employee_count) AS total_employees

FROM inc5000_cleaned

GROUP BY
state_name,
state_code;
GO


/*=========================================================
6. City Summary View
=========================================================*/

CREATE OR ALTER VIEW vw_city_summary
AS

SELECT

city_name,

COUNT(*) AS total_companies,

SUM(annual_revenue_usd) AS total_revenue,

AVG(growth_rate_percent) AS average_growth

FROM inc5000_cleaned

GROUP BY city_name;
GO


/*=========================================================
7. Revenue Per Employee View
=========================================================*/

CREATE OR ALTER VIEW vw_revenue_per_employee
AS

SELECT

company_name,

industry_name,

annual_revenue_usd,

employee_count,

CASE

WHEN employee_count = 0
THEN NULL

ELSE
CAST(annual_revenue_usd AS DECIMAL(18,2))
/
employee_count

END AS revenue_per_employee

FROM inc5000_cleaned;
GO


/*=========================================================
8. Top Companies View
=========================================================*/

CREATE OR ALTER VIEW vw_top_companies
AS

SELECT

company_rank,
company_name,
industry_name,
annual_revenue_usd,
growth_rate_percent,
employee_count

FROM inc5000_cleaned

WHERE company_rank <= 100;
GO


/*=========================================================
9. Company Size View
=========================================================*/

CREATE OR ALTER VIEW vw_company_size
AS

SELECT

company_name,

employee_count,

CASE

WHEN employee_count <= 10
THEN 'Micro'

WHEN employee_count <= 50
THEN 'Small'

WHEN employee_count <= 250
THEN 'Medium'

WHEN employee_count <= 1000
THEN 'Large'

ELSE 'Enterprise'

END AS company_size

FROM inc5000_cleaned;
GO


/*=========================================================
10. Executive Dashboard View
=========================================================*/

CREATE OR ALTER VIEW vw_executive_dashboard
AS

SELECT

COUNT(*) AS total_companies,

COUNT(DISTINCT industry_name) AS total_industries,

COUNT(DISTINCT state_code) AS total_states,

SUM(annual_revenue_usd) AS total_revenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth,

SUM(employee_count) AS total_employees

FROM inc5000_cleaned;
GO


/*=========================================================
11. Metro Area Summary View
=========================================================*/

CREATE OR ALTER VIEW vw_metro_summary
AS

SELECT

metro_area,

COUNT(*) AS total_companies,

SUM(annual_revenue_usd) AS total_revenue,

AVG(growth_rate_percent) AS average_growth

FROM inc5000_cleaned

WHERE metro_area IS NOT NULL

GROUP BY metro_area;
GO


/*=========================================================
12. Long-Term Companies View
=========================================================*/

CREATE OR ALTER VIEW vw_long_term_companies
AS

SELECT

company_name,
industry_name,
years_on_inc5000,
growth_rate_percent,
annual_revenue_usd

FROM inc5000_cleaned

WHERE years_on_inc5000 >= 5;
GO


/*=========================================================
13. Hyper Growth Companies View
=========================================================*/

CREATE OR ALTER VIEW vw_hyper_growth_companies
AS

SELECT

company_rank,
company_name,
industry_name,
growth_rate_percent,
annual_revenue_usd

FROM inc5000_cleaned

WHERE growth_rate_percent >= 1000;
GO


/*=========================================================
14. Largest Employers View
=========================================================*/

CREATE OR ALTER VIEW vw_largest_employers
AS

SELECT

company_name,
industry_name,
employee_count,
annual_revenue_usd

FROM inc5000_cleaned

WHERE employee_count > 0;
GO


/*=========================================================
15. View Validation
=========================================================*/

SELECT TOP (10) * FROM vw_company_summary;
SELECT TOP (10) * FROM vw_revenue_analysis;
SELECT TOP (10) * FROM vw_growth_analysis;
SELECT TOP (10) * FROM vw_industry_summary;
SELECT TOP (10) * FROM vw_state_summary;
GO