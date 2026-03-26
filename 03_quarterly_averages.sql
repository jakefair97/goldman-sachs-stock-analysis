-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 03: Quarterly Averages
-- Description: Calculates average closing price
-- and average trading volume per quarter across
-- the full dataset to establish long-term trends.
-- A preliminary review of volume data revealed
-- a notable spike in 2008-2009, prompting the
-- crisis deep dive in files 05-08.
-- ============================================

-- Average closing price per quarter
SELECT 
    EXTRACT(YEAR FROM DATE(Date)) AS Year,
    CONCAT('Q', CAST(EXTRACT(QUARTER FROM DATE(Date)) AS STRING)) AS Quarter,
    ROUND(AVG(Close), 2) AS Avg_Close
FROM `g-sachs.fin_sheets.master_dataset`
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- Average trading volume per quarter
SELECT 
    EXTRACT(YEAR FROM DATE(Date)) AS Year,
    CONCAT('Q', CAST(EXTRACT(QUARTER FROM DATE(Date)) AS STRING)) AS Quarter,
    ROUND(AVG(Volume)) AS Avg_Volume
FROM `g-sachs.fin_sheets.master_dataset`
GROUP BY Year, Quarter
ORDER BY Year, Quarter;
