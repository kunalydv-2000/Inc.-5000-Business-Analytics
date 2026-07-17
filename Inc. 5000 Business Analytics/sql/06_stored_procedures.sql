/*
===========================================================
 File Name : 06_stored_procedures.sql
 Project   : Inc.5000 Business Growth Analytics
 Database  : Inc5000Analytics
 Author    : Kunal Yadav
===========================================================

Description
-----------
Creates reusable stored procedures for business reporting.

===========================================================
*/

USE Inc5000Analytics;
GO

/*=========================================================
1. Executive Dashboard
=========================================================*/

CREATE OR ALTER PROCEDURE sp_ExecutiveDashboard
AS
BEGIN

SET NOCOUNT ON;

SELECT

COUNT(*) AS TotalCompanies,

COUNT(DISTINCT industry_name) AS TotalIndustries,

COUNT(DISTINCT state_code) AS TotalStates,

SUM(annual_revenue_usd) AS TotalRevenue,

AVG(CAST(annual_revenue_usd AS DECIMAL(18,2))) AS AverageRevenue,

AVG(CAST(growth_rate_percent AS DECIMAL(18,2))) AS AverageGrowth,

SUM(employee_count) AS TotalEmployees

FROM inc5000_cleaned;

END;
GO


/*=========================================================
2. Top Companies by Revenue
=========================================================*/

CREATE OR ALTER PROCEDURE sp_TopCompaniesByRevenue
    @Top INT = 10
AS
BEGIN

SET NOCOUNT ON;

SELECT TOP (@Top)

company_rank,
company_name,
industry_name,
annual_revenue_usd,
employee_count

FROM inc5000_cleaned

ORDER BY annual_revenue_usd DESC;

END;
GO


/*=========================================================
3. Fastest Growing Companies
=========================================================*/

CREATE OR ALTER PROCEDURE sp_TopGrowthCompanies
    @Top INT = 10
AS
BEGIN

SET NOCOUNT ON;

SELECT TOP (@Top)

company_rank,
company_name,
industry_name,
growth_rate_percent

FROM inc5000_cleaned

ORDER BY growth_rate_percent DESC;

END;
GO


/*=========================================================
4. Industry Performance
=========================================================*/

CREATE OR ALTER PROCEDURE sp_IndustrySummary
AS
BEGIN

SET NOCOUNT ON;

SELECT

industry_name,

COUNT(*) AS TotalCompanies,

SUM(annual_revenue_usd) AS TotalRevenue,

AVG(growth_rate_percent) AS AverageGrowth,

SUM(employee_count) AS TotalEmployees

FROM inc5000_cleaned

GROUP BY industry_name

ORDER BY TotalRevenue DESC;

END;
GO


/*=========================================================
5. State Performance
=========================================================*/

CREATE OR ALTER PROCEDURE sp_StateSummary
AS
BEGIN

SET NOCOUNT ON;

SELECT

state_name,

COUNT(*) AS Companies,

SUM(annual_revenue_usd) AS TotalRevenue,

AVG(growth_rate_percent) AS AverageGrowth,

SUM(employee_count) AS TotalEmployees

FROM inc5000_cleaned

GROUP BY state_name

ORDER BY TotalRevenue DESC;

END;
GO


/*=========================================================
6. Company Profile
=========================================================*/

CREATE OR ALTER PROCEDURE sp_CompanyProfile

@CompanyName VARCHAR(200)

AS
BEGIN

SET NOCOUNT ON;

SELECT *

FROM inc5000_cleaned

WHERE company_name = @CompanyName;

END;
GO


/*=========================================================
7. Industry Filter
=========================================================*/

CREATE OR ALTER PROCEDURE sp_FilterByIndustry

@Industry VARCHAR(100)

AS
BEGIN

SET NOCOUNT ON;

SELECT *

FROM inc5000_cleaned

WHERE industry_name = @Industry

ORDER BY annual_revenue_usd DESC;

END;
GO


/*=========================================================
8. State Filter
=========================================================*/

CREATE OR ALTER PROCEDURE sp_FilterByState

@StateCode CHAR(2)

AS
BEGIN

SET NOCOUNT ON;

SELECT *

FROM inc5000_cleaned

WHERE state_code = @StateCode

ORDER BY annual_revenue_usd DESC;

END;
GO


/*=========================================================
9. Revenue Category Report
=========================================================*/

CREATE OR ALTER PROCEDURE sp_RevenueCategoryReport
AS
BEGIN

SET NOCOUNT ON;

SELECT

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'

WHEN annual_revenue_usd < 50000000 THEN '$10M-$49M'

WHEN annual_revenue_usd < 100000000 THEN '$50M-$99M'

ELSE '$100M+'

END AS RevenueCategory,

COUNT(*) AS Companies,

SUM(annual_revenue_usd) AS TotalRevenue

FROM inc5000_cleaned

GROUP BY

CASE

WHEN annual_revenue_usd < 10000000 THEN 'Below $10M'

WHEN annual_revenue_usd < 50000000 THEN '$10M-$49M'

WHEN annual_revenue_usd < 100000000 THEN '$50M-$99M'

ELSE '$100M+'

END

ORDER BY TotalRevenue DESC;

END;
GO


/*=========================================================
10. Company Size Report
=========================================================*/

CREATE OR ALTER PROCEDURE sp_CompanySizeReport
AS
BEGIN

SET NOCOUNT ON;

SELECT

CASE

WHEN employee_count <=10 THEN 'Micro'

WHEN employee_count <=50 THEN 'Small'

WHEN employee_count <=250 THEN 'Medium'

WHEN employee_count <=1000 THEN 'Large'

ELSE 'Enterprise'

END AS CompanySize,

COUNT(*) AS Companies,

AVG(annual_revenue_usd) AS AverageRevenue

FROM inc5000_cleaned

GROUP BY

CASE

WHEN employee_count <=10 THEN 'Micro'

WHEN employee_count <=50 THEN 'Small'

WHEN employee_count <=250 THEN 'Medium'

WHEN employee_count <=1000 THEN 'Large'

ELSE 'Enterprise'

END

ORDER BY Companies DESC;

END;
GO


/*=========================================================
11. Revenue Per Employee
=========================================================*/

CREATE OR ALTER PROCEDURE sp_RevenuePerEmployee
AS
BEGIN

SET NOCOUNT ON;

SELECT

company_name,

industry_name,

annual_revenue_usd,

employee_count,

CAST(annual_revenue_usd AS DECIMAL(18,2))
/
NULLIF(employee_count,0)

AS RevenuePerEmployee

FROM inc5000_cleaned

WHERE employee_count > 0

ORDER BY RevenuePerEmployee DESC;

END;
GO


/*=========================================================
12. Companies by Years on List
=========================================================*/

CREATE OR ALTER PROCEDURE sp_YearsOnListSummary
AS
BEGIN

SET NOCOUNT ON;

SELECT

years_on_inc5000,

COUNT(*) AS Companies,

AVG(growth_rate_percent) AS AverageGrowth,

SUM(annual_revenue_usd) AS TotalRevenue

FROM inc5000_cleaned

GROUP BY years_on_inc5000

ORDER BY years_on_inc5000 DESC;

END;
GO


/*=========================================================
13. Hyper Growth Companies
=========================================================*/

CREATE OR ALTER PROCEDURE sp_HyperGrowthCompanies
AS
BEGIN

SET NOCOUNT ON;

SELECT

company_rank,
company_name,
industry_name,
growth_rate_percent,
annual_revenue_usd

FROM inc5000_cleaned

WHERE growth_rate_percent >= 1000

ORDER BY growth_rate_percent DESC;

END;
GO


/*=========================================================
14. Search Company
=========================================================*/

CREATE OR ALTER PROCEDURE sp_SearchCompany

@Keyword VARCHAR(100)

AS
BEGIN

SET NOCOUNT ON;

SELECT *

FROM inc5000_cleaned

WHERE company_name LIKE '%' + @Keyword + '%'

ORDER BY company_rank;

END;
GO


/*=========================================================
15. Largest Employers
=========================================================*/

CREATE OR ALTER PROCEDURE sp_LargestEmployers

@Top INT = 20

AS
BEGIN

SET NOCOUNT ON;

SELECT TOP (@Top)

company_name,

industry_name,

employee_count,

annual_revenue_usd

FROM inc5000_cleaned

ORDER BY employee_count DESC;

END;
GO


/*=========================================================
Sample Execution
=========================================================*/

EXEC sp_ExecutiveDashboard;

EXEC sp_TopCompaniesByRevenue 10;

EXEC sp_TopGrowthCompanies 10;

EXEC sp_IndustrySummary;

EXEC sp_StateSummary;

EXEC sp_FilterByIndustry 'Software';

EXEC sp_FilterByState 'CA';

EXEC sp_CompanyProfile 'Dropbox';

EXEC sp_RevenueCategoryReport;

EXEC sp_CompanySizeReport;

EXEC sp_RevenuePerEmployee;

EXEC sp_YearsOnListSummary;

EXEC sp_HyperGrowthCompanies;

EXEC sp_SearchCompany 'Tech';

EXEC sp_LargestEmployers 15;

GO