-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 07: 2008 Crisis - Quarterly Trend
-- Description: Tracks both average closing price
-- and average trading volume by quarter during
-- the crisis period to show how the two metrics
-- moved in relation to each other.
-- ============================================

SELECT 
    EXTRACT(YEAR FROM DATE(Date)) AS Year,
    CONCAT('Q', CAST(EXTRACT(QUARTER FROM DATE(Date)) AS STRING)) AS Quarter,
    ROUND(AVG(Close), 2) AS Avg_Close,
    ROUND(AVG(Volume), 0) AS Avg_Volume
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2007-01-01' AND '2009-12-31'
GROUP BY Year, Quarter
ORDER BY Year, Quarter;
