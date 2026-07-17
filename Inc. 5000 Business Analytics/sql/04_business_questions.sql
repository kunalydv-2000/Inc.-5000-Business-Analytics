/*
===========================================================
 File Name : 04_business_questions.sql
 Project   : Inc. 5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Kunal Yadav
===========================================================

Description
-----------
Business analysis queries that answer practical questions
about company growth, revenue, workforce, industries, and
geographic performance.

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
SECTION 1 : Executive KPIs
=========================================================*/

-----------------------------------------------------------
-- Q1. Total number of companies
-----------------------------------------------------------

SELECT
    COUNT(*) AS total_companies
FROM inc5000_cleaned;
GO

-----------------------------------------------------------
-- Q2. Total revenue generated
-----------------------------------------------------------

SELECT
    SUM(annual_revenue_usd) AS total_revenue
FROM inc5000_cleaned;
GO

-----------------------------------------------------------
-- Q3. Average company revenue
-----------------------------------------------------------

SELECT
    AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS average_revenue
FROM inc5000_cleaned;
GO

-----------------------------------------------------------
-- Q4. Average company growth
-----------------------------------------------------------

SELECT
    AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS average_growth
FROM inc5000_cleaned;
GO

-----------------------------------------------------------
-- Q5. Total workforce
-----------------------------------------------------------

SELECT
    SUM(employee_count) AS total_employees
FROM inc5000_cleaned;
GO


/*=========================================================
SECTION 2 : Company Performance
=========================================================*/

-----------------------------------------------------------
-- Q6. Top 10 companies by revenue
-----------------------------------------------------------

SELECT TOP (10)

company_rank,
company_name,
industry_name,
annual_revenue_usd

FROM inc5000_cleaned

ORDER BY annual_revenue_usd DESC;
GO

-----------------------------------------------------------
-- Q7. Top 10 fastest-growing companies
-----------------------------------------------------------

SELECT TOP (10)

company_rank,
company_name,
growth_rate_percent

FROM inc5000_cleaned

ORDER BY growth_rate_percent DESC;
GO

-----------------------------------------------------------
-- Q8. Largest employers
-----------------------------------------------------------

SELECT TOP (10)

company_name,
employee_count

FROM inc5000_cleaned

ORDER BY employee_count DESC;
GO

-----------------------------------------------------------
-- Q9. Highest revenue per employee
-----------------------------------------------------------

SELECT TOP (10)

company_name,

annual_revenue_usd,

employee_count,

CAST(annual_revenue_usd AS DECIMAL(18,2))
/
NULLIF(employee_count,0) AS revenue_per_employee

FROM inc5000_cleaned

WHERE employee_count > 0

ORDER BY revenue_per_employee DESC;
GO


/*=========================================================
SECTION 3 : Industry Analysis
=========================================================*/

-----------------------------------------------------------
-- Q10. Number of companies by industry
-----------------------------------------------------------

SELECT

industry_name,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY companies DESC;
GO

-----------------------------------------------------------
-- Q11. Industry generating highest revenue
-----------------------------------------------------------

SELECT

industry_name,

SUM(annual_revenue_usd) AS total_revenue

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY total_revenue DESC;
GO

-----------------------------------------------------------
-- Q12. Industry with highest average growth
-----------------------------------------------------------

SELECT

industry_name,

AVG(growth_rate_percent) AS average_growth

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY average_growth DESC;
GO

-----------------------------------------------------------
-- Q13. Industry employing the most people
-----------------------------------------------------------

SELECT

industry_name,

SUM(employee_count) AS total_employees

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY total_employees DESC;
GO


/*=========================================================
SECTION 4 : Geographic Analysis
=========================================================*/

-----------------------------------------------------------
-- Q14. States with the most companies
-----------------------------------------------------------

SELECT TOP (10)

state_name,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY companies DESC;
GO

-----------------------------------------------------------
-- Q15. States generating highest revenue
-----------------------------------------------------------

SELECT TOP (10)

state_name,

SUM(annual_revenue_usd) AS total_revenue

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY total_revenue DESC;
GO

-----------------------------------------------------------
-- Q16. Cities with the highest number of companies
-----------------------------------------------------------

SELECT TOP (10)

city_name,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY city_name

ORDER BY companies DESC;
GO

-----------------------------------------------------------
-- Q17. Metro areas with the highest revenue
-----------------------------------------------------------

SELECT TOP (10)

metro_area,

SUM(annual_revenue_usd) AS total_revenue

FROM inc5000_cleaned

WHERE metro_area IS NOT NULL

GROUP BY metro_area

ORDER BY total_revenue DESC;
GO


/*=========================================================
SECTION 5 : Growth Analysis
=========================================================*/

-----------------------------------------------------------
-- Q18. Companies with more than 1000% growth
-----------------------------------------------------------

SELECT

company_name,

growth_rate_percent

FROM inc5000_cleaned

WHERE growth_rate_percent >= 1000

ORDER BY growth_rate_percent DESC;
GO

-----------------------------------------------------------
-- Q19. Average growth by state
-----------------------------------------------------------

SELECT

state_name,

AVG(growth_rate_percent) AS average_growth

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY average_growth DESC;
GO

-----------------------------------------------------------
-- Q20. Average growth by years on list
-----------------------------------------------------------

SELECT

years_on_inc5000,

AVG(growth_rate_percent) AS average_growth

FROM inc5000_cleaned

GROUP BY years_on_inc5000

ORDER BY years_on_inc5000;
GO


/*=========================================================
SECTION 6 : Revenue Analysis
=========================================================*/

-----------------------------------------------------------
-- Q21. Revenue category distribution
-----------------------------------------------------------

SELECT

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'
WHEN annual_revenue_usd < 50000000 THEN '$10M-$49M'
WHEN annual_revenue_usd < 100000000 THEN '$50M-$99M'
ELSE '$100M+'

END AS revenue_category,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'
WHEN annual_revenue_usd < 50000000 THEN '$10M-$49M'
WHEN annual_revenue_usd < 100000000 THEN '$50M-$99M'
ELSE '$100M+'

END

ORDER BY companies DESC;
GO

-----------------------------------------------------------
-- Q22. Top revenue companies in each industry
-----------------------------------------------------------

WITH RankedCompanies AS
(
SELECT
    company_name,
    industry_name,
    annual_revenue_usd,
    ROW_NUMBER() OVER
    (
        PARTITION BY industry_name
        ORDER BY annual_revenue_usd DESC
    ) AS rn

FROM inc5000_cleaned
)

SELECT
company_name,
industry_name,
annual_revenue_usd

FROM RankedCompanies

WHERE rn = 1

ORDER BY annual_revenue_usd DESC;
GO


/*=========================================================
SECTION 7 : Workforce Analysis
=========================================================*/

-----------------------------------------------------------
-- Q23. Average workforce by industry
-----------------------------------------------------------

SELECT

industry_name,

AVG(employee_count) AS average_employees

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY average_employees DESC;
GO

-----------------------------------------------------------
-- Q24. Company size distribution
-----------------------------------------------------------

SELECT

CASE

WHEN employee_count <=10 THEN 'Micro'

WHEN employee_count <=50 THEN 'Small'

WHEN employee_count <=250 THEN 'Medium'

WHEN employee_count <=1000 THEN 'Large'

ELSE 'Enterprise'

END AS company_size,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY

CASE

WHEN employee_count <=10 THEN 'Micro'

WHEN employee_count <=50 THEN 'Small'

WHEN employee_count <=250 THEN 'Medium'

WHEN employee_count <=1000 THEN 'Large'

ELSE 'Enterprise'

END

ORDER BY companies DESC;
GO


/*=========================================================
SECTION 8 : Long-Term Performance
=========================================================*/

-----------------------------------------------------------
-- Q25. Companies appearing multiple years
-----------------------------------------------------------

SELECT

years_on_inc5000,

COUNT(*) AS companies

FROM inc5000_cleaned

GROUP BY years_on_inc5000

ORDER BY years_on_inc5000 DESC;
GO