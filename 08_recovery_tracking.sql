-- ============================================
-- Goldman Sachs Stock Analysis (1999-2026)
-- File 08: Recovery Tracking (2010-2013)
-- Description: Tracks monthly average closing
-- price beginning in 2010 to identify when GS
-- stock returned to pre-crisis price levels
-- following the 2008 collapse. Starting in 2010
-- rather than 2009 establishes a true post-crisis
-- baseline, excluding the volatile tail end of
-- the crisis period.
-- ============================================

SELECT 
    FORMAT_DATE('%Y-%m', DATE(Date)) AS Month,
    ROUND(AVG(Close), 2) AS Avg_Close
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2010-01-01' AND '2013-12-31'
GROUP BY Month
ORDER BY Month;
