/*
===========================================================
 File Name : 07_indexes.sql
 Project   : Inc.5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Your Name
===========================================================

Description
-----------
Creates indexes to improve query performance for
business reporting and analytical queries.

Indexes Included
----------------
1. Primary Key
2. Company Rank
3. Company Name
4. Industry
5. State
6. City
7. Metro Area
8. Revenue
9. Growth
10. Employee Count
11. Years on List
12. Composite Indexes
13. Covering Indexes

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
1. Primary Key
=========================================================*/

IF NOT EXISTS
(
    SELECT *
    FROM sys.indexes
    WHERE name = 'PK_inc5000_cleaned'
)
BEGIN

ALTER TABLE inc5000_cleaned
ADD CONSTRAINT PK_inc5000_cleaned
PRIMARY KEY CLUSTERED (company_id);

END;
GO


/*=========================================================
2. Company Rank Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_company_rank

ON inc5000_cleaned(company_rank);

GO


/*=========================================================
3. Company Name Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_company_name

ON inc5000_cleaned(company_name);

GO


/*=========================================================
4. Industry Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_industry

ON inc5000_cleaned(industry_name);

GO


/*=========================================================
5. State Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_state

ON inc5000_cleaned(state_code);

GO


/*=========================================================
6. City Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_city

ON inc5000_cleaned(city_name);

GO


/*=========================================================
7. Metro Area Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_metro

ON inc5000_cleaned(metro_area);

GO


/*=========================================================
8. Revenue Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_revenue

ON inc5000_cleaned(annual_revenue_usd DESC);

GO


/*=========================================================
9. Growth Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_growth

ON inc5000_cleaned(growth_rate_percent DESC);

GO


/*=========================================================
10. Employee Count Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_employee_count

ON inc5000_cleaned(employee_count DESC);

GO


/*=========================================================
11. Years on List Index
=========================================================*/

CREATE NONCLUSTERED INDEX IX_years_on_list

ON inc5000_cleaned(years_on_inc5000);

GO


/*=========================================================
12. Composite Index
Industry + Revenue
=========================================================*/

CREATE NONCLUSTERED INDEX IX_industry_revenue

ON inc5000_cleaned
(
    industry_name,
    annual_revenue_usd DESC
);

GO


/*=========================================================
13. Composite Index
State + Revenue
=========================================================*/

CREATE NONCLUSTERED INDEX IX_state_revenue

ON inc5000_cleaned
(
    state_code,
    annual_revenue_usd DESC
);

GO


/*=========================================================
14. Composite Index
Growth + Revenue
=========================================================*/

CREATE NONCLUSTERED INDEX IX_growth_revenue

ON inc5000_cleaned
(
    growth_rate_percent DESC,
    annual_revenue_usd DESC
);

GO


/*=========================================================
15. Composite Index
Industry + Growth
=========================================================*/

CREATE NONCLUSTERED INDEX IX_industry_growth

ON inc5000_cleaned
(
    industry_name,
    growth_rate_percent DESC
);

GO


/*=========================================================
16. Covering Index
Executive Dashboard
=========================================================*/

CREATE NONCLUSTERED INDEX IX_dashboard

ON inc5000_cleaned
(
    industry_name,
    state_code
)

INCLUDE
(
    annual_revenue_usd,
    growth_rate_percent,
    employee_count
);

GO


/*=========================================================
17. Covering Index
Company Lookup
=========================================================*/

CREATE NONCLUSTERED INDEX IX_company_lookup

ON inc5000_cleaned
(
    company_name
)

INCLUDE
(
    company_rank,
    industry_name,
    annual_revenue_usd,
    growth_rate_percent,
    employee_count,
    city_name,
    state_name
);

GO


/*=========================================================
18. Covering Index
Geographical Analysis
=========================================================*/

CREATE NONCLUSTERED INDEX IX_geography

ON inc5000_cleaned
(
    state_code,
    city_name
)

INCLUDE
(
    annual_revenue_usd,
    growth_rate_percent,
    employee_count
);

GO


/*=========================================================
19. Display All Indexes
=========================================================*/

SELECT

i.name AS index_name,

i.type_desc,

c.name AS column_name

FROM sys.indexes i

INNER JOIN sys.index_columns ic
ON i.object_id = ic.object_id
AND i.index_id = ic.index_id

INNER JOIN sys.columns c
ON ic.object_id = c.object_id
AND ic.column_id = c.column_id

WHERE OBJECT_NAME(i.object_id) = 'inc5000_cleaned'

ORDER BY
i.name,
ic.key_ordinal;

GO


/*=========================================================
20. Index Usage Statistics
=========================================================*/

SELECT

OBJECT_NAME(s.object_id) AS table_name,

i.name AS index_name,

s.user_seeks,

s.user_scans,

s.user_lookups,

s.user_updates

FROM sys.dm_db_index_usage_stats s

INNER JOIN sys.indexes i

ON s.object_id = i.object_id
AND s.index_id = i.index_id

WHERE OBJECT_NAME(s.object_id) = 'inc5000_cleaned';

GO