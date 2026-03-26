-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 05: 2008 Crisis - Monthly Trends
-- Description: Tracks monthly average closing
-- price and trading volume from 2007-2009.
-- Starting in 2007 establishes a pre-crisis
-- baseline, making the magnitude of the 2008
-- collapse more visible in context.
-- ============================================

SELECT 
    FORMAT_DATE('%Y-%m', DATE(Date)) AS Month,
    ROUND(AVG(Close), 2) AS Avg_Close,
    ROUND(AVG(Volume), 0) AS Avg_Volume
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2007-01-01' AND '2009-12-31'
GROUP BY Month
ORDER BY Month;
