/*
============================================================
FILE: Mouatakid_sales_analysis.sql
PROJECT: EmporiUm Capstone 1 - Sales_Analysis

SALES TERRITORY:
Maryland (Northeast Region)

This script analyzes sales performance including revenue,
time trends, product performance, and store rankings.
============================================================
*/


USE sample_sales;

/*
QUESTION 1 (Maryland Territory):
As the assigned sales territory is Maryland (Northeast Region), I am analyzing:

- Total revenue generated in Maryland
- The start date of sales activity in the dataset
- The end date of sales activity in the dataset

This helps understand the overall performance and time coverage of the Maryland sales data.
*/

SELECT 
    SUM(ss.Sale_Amount) AS Total_Revenue,
    MIN(ss.Transaction_Date) AS Start_Date,
    MAX(ss.Transaction_Date) AS End_Date
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland';