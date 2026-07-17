
--File Name : 01_data_cleaning.sql
--Project   : Inc. 5000 Business Growth Analytics
--Database  : Inc5000Analytics
--Author    : Kunal Yadav

USE Inc5000Analytics;
GO

--1. Preview Dataset

SELECT TOP (10) *
FROM inc5000_cleaned;
GO


--2. Total Records

SELECT COUNT(*) AS total_records
FROM inc5000_cleaned;
GO


--3. Duplicate Company ID Check

SELECT
    company_id,
    COUNT(*) AS duplicate_count
FROM inc5000_cleaned
GROUP BY company_id
HAVING COUNT(*) > 1;
GO


--4. Duplicate Company Names

SELECT
    company_name,
    COUNT(*) AS duplicate_count
FROM inc5000_cleaned
GROUP BY company_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
GO


--5. Missing Value Check

SELECT

SUM(CASE WHEN company_id IS NULL THEN 1 ELSE 0 END) AS company_id_nulls,

SUM(CASE WHEN company_rank IS NULL THEN 1 ELSE 0 END) AS company_rank_nulls,

SUM(CASE WHEN company_name IS NULL THEN 1 ELSE 0 END) AS company_name_nulls,

SUM(CASE WHEN industry_name IS NULL THEN 1 ELSE 0 END) AS industry_nulls,

SUM(CASE WHEN annual_revenue_usd IS NULL THEN 1 ELSE 0 END) AS revenue_nulls,

SUM(CASE WHEN growth_rate_percent IS NULL THEN 1 ELSE 0 END) AS growth_nulls,

SUM(CASE WHEN employee_count IS NULL THEN 1 ELSE 0 END) AS employee_nulls,

SUM(CASE WHEN city_name IS NULL THEN 1 ELSE 0 END) AS city_nulls,

SUM(CASE WHEN metro_area IS NULL THEN 1 ELSE 0 END) AS metro_nulls,

SUM(CASE WHEN state_name IS NULL THEN 1 ELSE 0 END) AS state_nulls,

SUM(CASE WHEN state_code IS NULL THEN 1 ELSE 0 END) AS state_code_nulls,

SUM(CASE WHEN years_on_inc5000 IS NULL THEN 1 ELSE 0 END) AS years_on_list_nulls,

SUM(CASE WHEN company_website IS NULL THEN 1 ELSE 0 END) AS website_nulls

FROM inc5000_cleaned;
GO


--6. Remove Leading / Trailing Spaces

UPDATE inc5000_cleaned
SET
company_name = LTRIM(RTRIM(company_name)),
industry_name = LTRIM(RTRIM(industry_name)),
city_name = LTRIM(RTRIM(city_name)),
metro_area = LTRIM(RTRIM(metro_area)),
state_name = LTRIM(RTRIM(state_name)),
state_code = UPPER(LTRIM(RTRIM(state_code))),
company_website = LTRIM(RTRIM(company_website));
GO


--7. Standardize Company Names

UPDATE inc5000_cleaned
SET company_name = UPPER(company_name);
GO


--8. Standardize Industry Names

UPDATE inc5000_cleaned
SET industry_name = UPPER(industry_name);
GO


--9. Standardize City Names

UPDATE inc5000_cleaned
SET city_name = UPPER(city_name);
GO


--10. Standardize State Names

UPDATE inc5000_cleaned
SET state_name = UPPER(state_name);
GO


--11. Employee Count Validation

SELECT *
FROM inc5000_cleaned
WHERE employee_count < 0;
GO


--12. Employee Count = 0

SELECT *
FROM inc5000_cleaned
WHERE employee_count = 0;
GO


--13. Revenue Validation

SELECT *
FROM inc5000_cleaned
WHERE annual_revenue_usd <= 0;
GO


--14. Growth Validation

SELECT *
FROM inc5000_cleaned
WHERE growth_rate_percent <= 0;
GO


--15. Invalid Ranking

SELECT *
FROM inc5000_cleaned
WHERE company_rank NOT BETWEEN 1 AND 5000;
GO


--16. Invalid Years on List

SELECT *
FROM inc5000_cleaned
WHERE years_on_inc5000 < 1;
GO


--17. Missing Website

SELECT *
FROM inc5000_cleaned
WHERE company_website IS NULL
   OR company_website = '';
GO


--18. Missing Metro Area

SELECT *
FROM inc5000_cleaned
WHERE metro_area IS NULL
   OR metro_area = '';
GO


--19. Data Quality Summary

SELECT

COUNT(*) AS total_records,

SUM(CASE WHEN employee_count = 0 THEN 1 ELSE 0 END) AS zero_employee_records,

SUM(CASE WHEN annual_revenue_usd <= 0 THEN 1 ELSE 0 END) AS invalid_revenue,

SUM(CASE WHEN growth_rate_percent <= 0 THEN 1 ELSE 0 END) AS invalid_growth,

SUM(CASE WHEN metro_area IS NULL THEN 1 ELSE 0 END) AS missing_metro,

SUM(CASE WHEN company_website IS NULL THEN 1 ELSE 0 END) AS missing_website

FROM inc5000_cleaned;
GO


--20. Final Dataset Preview

SELECT *
FROM inc5000_cleaned;
GO