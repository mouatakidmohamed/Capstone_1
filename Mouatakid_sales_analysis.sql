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
QUESTION 4-a) (Maryland Territory):
As the assigned sales territory is Maryland (Northeast Region), I am analyzing:

a)
- Total revenue generated in Maryland
- The start date of sales activity in the dataset
- The end date of sales activity in the dataset

This helps understand the overall performance and time coverage of the Maryland sales data.
*/

SELECT 
    SUM(ss.Sale_Amount) AS Total_InStore_Revenue,
    MIN(ss.Transaction_Date) AS Start_Date,
    MAX(ss.Transaction_Date) AS End_Date
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland';

-- Total Revenue: 11451615.09
-- Start_Date: 2022-01-01
-- End_Date : 2025-12-31

/*
QUESTION 4-b) (Maryland):
This query shows the month-by-month revenue breakdown for Maryland.
*/

SELECT 
    YEAR(ss.Transaction_Date) AS Year,
    MONTH(ss.Transaction_Date) AS Month,
    SUM(ss.Sale_Amount) AS Monthly_Revenue
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'
GROUP BY YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date)
ORDER BY Year, Month;

/*
This query returns 48 rows representing monthly revenue for Maryland stores.
Each row shows total sales for a specific month, allowing analysis of trends,
seasonality, and performance changes over time.
*/

/*
QUESTION 4-c) (Maryland - Region Comparison)

This query compares total revenue from Maryland
against the total revenue of the Northeast region
to understand Maryland's contribution to the region.
*/

SELECT 
    Location,
    SUM(Revenue) AS Total_Revenue
FROM (
    
    -- Maryland revenue
    SELECT 
        'Maryland' AS Location,
        ss.Sale_Amount AS Revenue
    FROM store_sales ss
    JOIN store_locations sl
        ON ss.Store_ID = sl.StoreId
    WHERE sl.State = 'Maryland'

    UNION ALL

    -- Northeast region revenue
    SELECT 
        m.Region AS Location,
        ss.Sale_Amount AS Revenue
    FROM store_sales ss
    JOIN store_locations sl
        ON ss.Store_ID = sl.StoreId
    JOIN management m
        ON sl.State = m.State
    WHERE m.Region = (
        SELECT Region 
        FROM management 
        WHERE State = 'Maryland'
    )

) combined
GROUP BY Location;

/*
RESULT:
- Maryland Revenue: 11,451,615.09
- Northeast Region Revenue: 24,237,526.98

ANALYSIS:
Maryland contributes approximately 47% of the total Northeast region revenue.
This shows Maryland is a major contributor to regional performance,
but there is still growth potential compared to the full region.
*/

/*
QUESTION 4-d) (Maryland - Product Category Analysis)

This query calculates:
- Number of transactions per month
- Average transaction size
- Grouped by product category

*/

SELECT 
    YEAR(ss.Transaction_Date) AS Year,   -- splits data into months
    MONTH(ss.Transaction_Date) AS Month,
    ic.Category AS Category,
    COUNT(*) AS Number_of_Transactions,  -- how many sales happened
    AVG(ss.Sale_Amount) AS Avg_Transaction_Size
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
JOIN products p
    ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
    ON p.Categoryid = ic.Categoryid
WHERE sl.State = 'Maryland'
GROUP BY 
    YEAR(ss.Transaction_Date),
    MONTH(ss.Transaction_Date),
    ic.Category
ORDER BY Year, Month, Category;

/*
This query analyzes transaction volume and average transaction size
by product category on a monthly basis.

RESULTS:
- Shows how different categories perform over time
- Identifies high-performing product categories
- Helps understand customer buying behavior in Maryland
*/

/*
QUESTION 4-e) (Maryland - Store Performance Ranking)

This query ranks each store in Maryland based on total revenue.
It identifies the highest and lowest performing stores.
*/

SELECT 
    sl.StoreId,
    sl.StoreLocation,
    SUM(ss.Sale_Amount) AS Total_Revenue
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'
GROUP BY sl.StoreId, sl.StoreLocation
ORDER BY Total_Revenue DESC;

/*
RESULT:
Stores are ranked by total revenue in Maryland.

KEY FINDINGS:
- North Harford is the dominant store with 8.7M revenue,
  significantly outperforming all other stores.
- The remaining stores generate under 600K each,
  showing a strong imbalance in performance distribution.
- Most stores fall within a similar low-performing range.

BUSINESS IMPACT:
The company should analyze North Harford’s strategy
and replicate it across lower-performing stores
to improve overall Maryland revenue.
*/


/*
- Recommendation for where to focus sales attention in the next quarter:
 
Based on the analysis of Maryland store performance, the following actions are recommended:

1. Focus on understanding the success of North Harford,
   as it generates the majority of revenue (8.7M), far exceeding all other stores.

2. Investigate operational strategies, customer base, and product mix at North Harford
   and replicate successful practices across underperforming stores.

3. Improve performance of mid- and low-tier stores (e.g., Annapolis, Queen Anne’s County, Baltimore),
   which are generating significantly lower revenue.

4. Consider targeted marketing campaigns and local promotions in weaker stores
   to increase customer engagement and sales.

FINAL STRATEGY:
Leverage North Harford as a benchmark store and apply its best practices
across the Maryland territory to balance performance and increase overall revenue.
*/


