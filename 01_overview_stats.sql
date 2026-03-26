-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 01: Overview Statistics
-- Description: High level summary of the dataset
-- including total trading days and how often
-- GS closed higher than it opened
-- ============================================

-- Total number of trading records
SELECT COUNT(*) AS Total_Trading_Days
FROM `g-sachs.fin_sheets.master_dataset`;

-- Number and percentage of days GS closed higher than it opened
SELECT 
    COUNT(*) AS Days_Closed_Higher,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM `g-sachs.fin_sheets.master_dataset`) * 100, 2) AS Pct_Of_Total
FROM `g-sachs.fin_sheets.master_dataset`
WHERE Close > Open;
