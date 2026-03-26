-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 04: Quarter-Over-Quarter Price Change
-- Description: Uses a CTE to calculate quarterly
-- average closing prices, then applies a LAG
-- window function to compare each quarter against
-- the prior quarter and calculate the percentage
-- change between quarters.
-- ============================================

WITH quarterly_avg AS (
    SELECT 
        EXTRACT(YEAR FROM DATE(Date)) AS Year,
        CONCAT('Q', CAST(EXTRACT(QUARTER FROM DATE(Date)) AS STRING)) AS Quarter,
        ROUND(AVG(Close), 2) AS Avg_Close
    FROM `g-sachs.fin_sheets.master_dataset`
    GROUP BY Year, Quarter
)
SELECT 
    Year,
    Quarter,
    Avg_Close,
    ROUND(LAG(Avg_Close) OVER (ORDER BY Year, Quarter), 2) AS Prev_Quarter_Avg_Close,
    ROUND((Avg_Close - LAG(Avg_Close) OVER (ORDER BY Year, Quarter)) 
        / LAG(Avg_Close) OVER (ORDER BY Year, Quarter) * 100, 2) AS QoQ_Change_Pct
FROM quarterly_avg
ORDER BY Year, Quarter;
