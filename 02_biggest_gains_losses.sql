-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 02: Biggest Single-Day Gains and Losses
-- Description: Identifies the 10 largest single
-- day price gains and losses in GS history
-- ============================================

-- 10 biggest single-day gains
SELECT 
    DATE(Date) AS Date,
    ROUND(Open, 2) AS Open,
    ROUND(Close, 2) AS Close,
    ROUND(Close - Open, 2) AS Daily_Gain
FROM `g-sachs.fin_sheets.master_dataset`
ORDER BY Daily_Gain DESC
LIMIT 10;

-- 10 biggest single-day losses
SELECT 
    DATE(Date) AS Date,
    ROUND(Open, 2) AS Open,
    ROUND(Close, 2) AS Close,
    ROUND(Open - Close, 2) AS Daily_Loss
FROM `g-sachs.fin_sheets.master_dataset`
ORDER BY Daily_Loss DESC
LIMIT 10;
