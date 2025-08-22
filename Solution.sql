-- CREATE TABLE TO FORMAT DATA
SELECT --week_date,
	   TRY_CONVERT(date, week_date, 3) AS week_date_format,
	   ((DAY(TRY_CONVERT(date, week_date, 3)) - 1) / 7) + 1 week_number,
	   MONTH(TRY_CONVERT(date, week_date, 3)) month_number,
	   YEAR(TRY_CONVERT(date, week_date, 3)) year_number,
	   --segment,
	   CASE WHEN segment LIKE '%1' THEN 'Young Adults'
			WHEN segment LIKE '%2' THEN 'Middle Adults'
			WHEN segment LIKE '%3' OR segment LIKE '%4' THEN 'Retirees'
			ELSE 'Unknown' END AS age_band,
	   CASE WHEN segment LIKE 'C%' THEN 'Couples'
			WHEN segment LIKE 'F%' THEN 'Families'
			ELSE 'Unknown' END AS demographic,
	   region, platform, customer_type, transactions, sales,
	   CAST(sales*1.0/ NULLIF(transactions,0) AS DECIMAL(18,2)) AS avg_transaction
INTO data_mart_clean_weekly_sales
FROM data_mart_weekly_sales

--What day of the week is used for each week_date value?
-- TẠO CỘT THỨ KẾ BÊN CỘT WEEKDATE
SELECT DISTINCT week_date_format,
	   DATENAME(WEEKDAY, week_date_format) AS date_name,
	   DATENAME(MONTH, week_date_format)
FROM data_mart_clean_weekly_sales

--How many total transactions were there for each year in the dataset?
SELECT year_number, COUNT(*) num_of_trans FROM data_mart_clean_weekly_sales
GROUP BY year_number

year_number	num_of_trans
2018		158
2019		119
2020		233

--What is the total sales for each region for each month?
SELECT region, month_number, year_number, SUM(sales) total_sales FROM data_mart_clean_weekly_sales
GROUP BY  region, month_number, year_number

--What is the total count of transactions for each platform
SELECT platform, COUNT(*) num_of_trans FROM data_mart_clean_weekly_sales
GROUP BY  platform

platform	num_of_trans
Retail		253
Shopify		257

--What is the percentage of sales for Retail vs Shopify for each month?
SELECT year_number, month_number, platform,
	   SUM(sales) total_sales,
	   ROUND(100.0*SUM(sales)/ SUM(SUM(sales)) OVER(PARTITION BY year_number, month_number),2) AS percentage_sales
FROM data_mart_clean_weekly_sales
GROUP BY year_number, month_number, platform
ORDER BY year_number, month_number, platform