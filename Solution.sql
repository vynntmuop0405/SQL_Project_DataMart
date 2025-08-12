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
### => Monday

--How many total transactions were there for each year in the dataset?