# Data Dictionary

## Project
**Inc. 5000 Company Analysis (2014)**

---

# Dataset Overview

| Attribute | Value |
|-----------|-------|
| Dataset Name | Inc. 5000 Company List (2014) |
| Granularity | One record represents one company |
| Primary Key | `id` |
| Total Columns | 19 |
| Target Audience | Business Analysts, Data Analysts, BI Developers |
| Purpose | Analyze high-growth private companies across industries, locations, revenue, workforce, and growth metrics |

---

# Data Dictionary

| Column Name | Data Type | Description | Example | Nullable | Recommended Action |
|-------------|-----------|-------------|---------|----------|--------------------|
| `_input` | Text | Internal import field generated during data collection. | NULL | Yes | Remove |
| `_num` | Integer | Sequential record number assigned during data extraction. | 1 | No | Remove |
| `_widgetName` | Text | Name of the extraction widget used to collect the data. | Company List | No | Remove |
| `_source` | Text | Source identifier used by the scraping process. | Web Scraper | No | Remove |
| `_resultNumber` | Integer | Position of the extracted record within the scraping results. | 15 | No | Remove |
| `_pageUrl` | Text | URL of the webpage from which the company information was extracted. | https://www.inc.com/inc5000 | No | Remove |
| `id` | Integer | Unique identifier assigned to each company. | 487 | No | Keep (Primary Key) |
| `rank` | Integer | Company's ranking in the Inc. 5000 list based on revenue growth. Lower values indicate better rankings. | 125 | No | Keep |
| `workers` | Integer | Total number of employees working at the company. | 185 | No | Keep |
| `company` | Text | Official company name. | Dropbox | No | Keep |
| `url` | Text | Official company website. | https://dropbox.com | Yes | Optional |
| `state_l` | Text | Full state name. | California | No | Keep |
| `state_s` | Text | Two-letter state abbreviation. | CA | No | Keep |
| `city` | Text | Headquarters city. | San Francisco | No | Keep |
| `metro` | Text | Metropolitan area of the company headquarters. | San Francisco-Oakland | Yes | Keep |
| `growth` | Decimal | Percentage growth achieved during the evaluation period. | 1543.20 | No | Keep |
| `revenue` | Decimal | Annual company revenue (USD). | 25000000 | No | Keep |
| `industry` | Text | Primary business industry or sector. | Software | No | Keep |
| `yrs_on_list` | Integer | Number of times the company has appeared on the Inc. 5000 list. | 3 | No | Keep |

---

# Column Categories

## Metadata Columns

These columns are generated during data collection and do not provide business value.

- `_input`
- `_num`
- `_widgetName`
- `_source`
- `_resultNumber`
- `_pageUrl`

**Recommendation:** Remove these columns before analysis.

---

## Identifier

| Column | Purpose |
|---------|----------|
| id | Unique identifier for each company |

---

## Ranking Information

| Column | Description |
|---------|-------------|
| rank | Position in the Inc. 5000 rankings |

---

## Company Information

| Column | Description |
|---------|-------------|
| company | Company name |
| url | Company website |
| industry | Business industry |

---

## Geographic Information

| Column | Description |
|---------|-------------|
| city | Headquarters city |
| metro | Metropolitan area |
| state_l | Full state name |
| state_s | State abbreviation |

---

## Business Performance

| Column | Description |
|---------|-------------|
| growth | Company growth percentage |
| revenue | Annual revenue (USD) |
| workers | Number of employees |
| yrs_on_list | Number of years on the Inc. 5000 list |

---

# Recommended Column Names

| Current Name | Recommended Name |
|--------------|------------------|
| state_l | state_name |
| state_s | state_code |
| workers | employee_count |
| growth | growth_percentage |
| revenue | revenue_usd |
| yrs_on_list | years_on_list |

---

# Data Types After Cleaning

| Column | Data Type |
|---------|-----------|
| id | Integer |
| rank | Integer |
| company | String |
| industry | String |
| revenue_usd | Decimal |
| growth_percentage | Decimal |
| employee_count | Integer |
| city | String |
| metro | String |
| state_name | String |
| state_code | String |
| years_on_list | Integer |
| url | String |

---

# Primary Key

| Column | Reason |
|---------|--------|
| id | Unique identifier for each company record |

---

# Analytical Columns

These columns are used in dashboards and business analysis.

- rank
- company
- industry
- revenue
- growth
- workers
- city
- metro
- state_l
- state_s
- yrs_on_list

---

# Recommended Calculated Columns

| Calculated Column | Formula | Purpose |
|-------------------|---------|---------|
| Revenue per Employee | revenue / workers | Measure operational efficiency |
| Revenue (Millions) | revenue / 1,000,000 | Improve chart readability |
| Company Size | Based on employee count | Categorize organizations by size |
| Revenue Category | Revenue bins | Segment companies by revenue |
| Growth Category | Growth bins | Classify growth performance |
| Rank Group | Top 100, Top 500, etc. | Simplify ranking analysis |
| Employee Size Band | Employee count bins | Workforce segmentation |
| State Region | Mapping by state | Regional analysis |

---

# Data Quality Rules

| Rule | Expected Result |
|------|-----------------|
| id must be unique | Pass |
| rank must be between 1 and 5000 | Pass |
| revenue must be greater than 0 | Pass |
| workers must be greater than 0 | Pass |
| growth must be greater than 0 | Pass |
| company should not be NULL | Pass |
| industry should not be NULL | Pass |
| state should not be NULL | Pass |

---

# Columns Used in Dashboard KPIs

- Total Companies
- Total Revenue
- Average Revenue
- Average Growth
- Total Employees
- Average Employees
- Top Ranked Company
- Top Industry
- Top State

---

# Final Analysis Dataset

After preprocessing, the recommended columns for analysis are:

1. id
2. rank
3. company
4. industry
5. revenue_usd
6. growth_percentage
7. employee_count
8. city
9. metro
10. state_name
11. state_code
12. years_on_list
13. url (optional)

---

# Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | July 2026 | Initial data dictionary created for the Inc. 5000 Company List (2014) dataset. |