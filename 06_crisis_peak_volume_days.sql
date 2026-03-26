-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 06: 2008 Crisis - Peak Volume Days
-- Description: Identifies the 10 highest volume
-- trading days during the crisis period to
-- determine whether peak volume corresponded
-- with the steepest price declines.
-- ============================================

SELECT 
    DATE(Date) AS Date,
    ROUND(Close, 2) AS Close,
    Volume,
    ROUND(Close - Open, 2) AS Daily_Change
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2008-01-01' AND '2009-06-30'
ORDER BY Volume DESC
LIMIT 10;
