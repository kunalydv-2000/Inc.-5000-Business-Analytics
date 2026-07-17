/*
===========================================================
 File Name : 02_data_validation.sql
 Project   : Inc. 5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Kunal Yadav
===========================================================

Description
-----------
This script validates the integrity and quality of the
Inc.5000 dataset after data cleaning.

Validation Areas
----------------
1. Row Count
2. Primary Key Validation
3. Duplicate Records
4. Missing Values
5. Business Rule Validation
6. Text Validation
7. Numeric Validation
8. URL Validation
9. Outlier Detection
10. Data Quality Score

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
1. Total Records
=========================================================*/

SELECT
    COUNT(*) AS total_records
FROM inc5000_cleaned;
GO


/*=========================================================
2. Company ID Should Be Unique
=========================================================*/

SELECT
    company_id,
    COUNT(*) AS duplicate_count
FROM inc5000_cleaned
GROUP BY company_id
HAVING COUNT(*) > 1;
GO


/*=========================================================
3. Company Rank Should Be Unique
=========================================================*/

SELECT
    company_rank,
    COUNT(*) AS duplicate_rank
FROM inc5000_cleaned
GROUP BY company_rank
HAVING COUNT(*) > 1;
GO


/*=========================================================
4. Company Name + State Duplicate Check
=========================================================*/

SELECT
    company_name,
    state_code,
    COUNT(*) AS duplicate_count
FROM inc5000_cleaned
GROUP BY
    company_name,
    state_code
HAVING COUNT(*) > 1;
GO


/*=========================================================
5. Missing Values Summary
=========================================================*/

SELECT

SUM(CASE WHEN company_id IS NULL THEN 1 ELSE 0 END) AS company_id,

SUM(CASE WHEN company_rank IS NULL THEN 1 ELSE 0 END) AS company_rank,

SUM(CASE WHEN company_name IS NULL THEN 1 ELSE 0 END) AS company_name,

SUM(CASE WHEN industry_name IS NULL THEN 1 ELSE 0 END) AS industry,

SUM(CASE WHEN annual_revenue_usd IS NULL THEN 1 ELSE 0 END) AS revenue,

SUM(CASE WHEN growth_rate_percent IS NULL THEN 1 ELSE 0 END) AS growth,

SUM(CASE WHEN employee_count IS NULL THEN 1 ELSE 0 END) AS employees,

SUM(CASE WHEN city_name IS NULL THEN 1 ELSE 0 END) AS city,

SUM(CASE WHEN metro_area IS NULL THEN 1 ELSE 0 END) AS metro,

SUM(CASE WHEN state_name IS NULL THEN 1 ELSE 0 END) AS state_name,

SUM(CASE WHEN state_code IS NULL THEN 1 ELSE 0 END) AS state_code,

SUM(CASE WHEN years_on_inc5000 IS NULL THEN 1 ELSE 0 END) AS years_on_list,

SUM(CASE WHEN company_website IS NULL THEN 1 ELSE 0 END) AS website

FROM inc5000_cleaned;
GO


/*=========================================================
6. Invalid Revenue
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE annual_revenue_usd <= 0;
GO


/*=========================================================
7. Invalid Growth
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE growth_rate_percent <= 0;
GO


/*=========================================================
8. Invalid Employee Count
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE employee_count < 0;
GO


/*=========================================================
9. Employee Count Equal to Zero
(Not an error, but worth reviewing)
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE employee_count = 0;
GO


/*=========================================================
10. Invalid Company Rank
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE company_rank NOT BETWEEN 1 AND 5000;
GO


/*=========================================================
11. Invalid Years on List
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE years_on_inc5000 < 1;
GO


/*=========================================================
12. Empty Company Names
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE company_name IS NULL
   OR company_name = '';
GO


/*=========================================================
13. Empty Industry
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE industry_name IS NULL
   OR industry_name = '';
GO


/*=========================================================
14. Empty City
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE city_name IS NULL
   OR city_name = '';
GO


/*=========================================================
15. Invalid State Code Length
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE LEN(state_code) <> 2;
GO


/*=========================================================
16. Invalid Website Format
=========================================================*/

SELECT *
FROM inc5000_cleaned
WHERE company_website IS NOT NULL
AND company_website <> ''
AND company_website NOT LIKE 'http%';
GO


/*=========================================================
17. Revenue Outliers
=========================================================*/

SELECT TOP (20)

company_name,
annual_revenue_usd

FROM inc5000_cleaned

ORDER BY annual_revenue_usd DESC;
GO


/*=========================================================
18. Growth Outliers
=========================================================*/

SELECT TOP (20)

company_name,
growth_rate_percent

FROM inc5000_cleaned

ORDER BY growth_rate_percent DESC;
GO


/*=========================================================
19. Largest Employers
=========================================================*/

SELECT TOP (20)

company_name,
employee_count

FROM inc5000_cleaned

ORDER BY employee_count DESC;
GO


/*=========================================================
20. Revenue Per Employee Validation
=========================================================*/

SELECT

company_name,

annual_revenue_usd,

employee_count,

CASE
    WHEN employee_count = 0 THEN NULL
    ELSE annual_revenue_usd / employee_count
END AS revenue_per_employee

FROM inc5000_cleaned

ORDER BY revenue_per_employee DESC;
GO


/*=========================================================
21. State Code Validation
=========================================================*/

SELECT DISTINCT
state_code
FROM inc5000_cleaned
ORDER BY state_code;
GO


/*=========================================================
22. Industry Validation
=========================================================*/

SELECT DISTINCT
industry_name
FROM inc5000_cleaned
ORDER BY industry_name;
GO


/*=========================================================
23. Company Rank Continuity
=========================================================*/

SELECT

MIN(company_rank) AS minimum_rank,

MAX(company_rank) AS maximum_rank,

COUNT(DISTINCT company_rank) AS unique_ranks

FROM inc5000_cleaned;
GO


/*=========================================================
24. Data Quality Summary
=========================================================*/

SELECT

COUNT(*) AS total_records,

COUNT(DISTINCT company_id) AS unique_company_ids,

COUNT(DISTINCT company_rank) AS unique_ranks,

COUNT(DISTINCT company_name) AS unique_companies,

SUM(CASE WHEN employee_count = 0 THEN 1 ELSE 0 END) AS zero_employee_records,

SUM(CASE WHEN annual_revenue_usd <= 0 THEN 1 ELSE 0 END) AS invalid_revenue,

SUM(CASE WHEN growth_rate_percent <= 0 THEN 1 ELSE 0 END) AS invalid_growth,

SUM(CASE WHEN metro_area IS NULL THEN 1 ELSE 0 END) AS missing_metro,

SUM(CASE WHEN company_website IS NULL THEN 1 ELSE 0 END) AS missing_websites
FROM inc5000_cleaned
GO


/*=========================================================
25. Validation Status
=========================================================*/

SELECT

CASE
    WHEN COUNT(*) = COUNT(DISTINCT company_id)
    THEN 'PASS'
    ELSE 'FAIL'
END AS company_id_validation,

CASE
    WHEN COUNT(*) = COUNT(DISTINCT company_rank)
    THEN 'PASS'
    ELSE 'FAIL'
END AS rank_validation,

CASE
    WHEN SUM(CASE WHEN annual_revenue_usd <= 0 THEN 1 ELSE 0 END) = 0
    THEN 'PASS'
    ELSE 'FAIL'
END AS revenue_validation,

CASE
    WHEN SUM(CASE WHEN growth_rate_percent <= 0 THEN 1 ELSE 0 END) = 0
    THEN 'PASS'
    ELSE 'FAIL'
END AS growth_validation,

CASE
    WHEN SUM(CASE WHEN employee_count < 0 THEN 1 ELSE 0 END) = 0
    THEN 'PASS'
    ELSE 'FAIL'
END AS employee_validation
FROM inc5000_cleaned;

GO