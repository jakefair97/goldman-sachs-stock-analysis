# Goldman Sachs Stock Analysis (1999–2026)
## Project Overview
This project analyzes Goldman Sachs (GS) stock data spanning 27 years using SQL in Google BigQuery. The dataset contains 6,755 trading records covering daily open, close, high, low, and volume data from May 1999 through March 2026.

The analysis is structured in two parts:
1. **Broad historical analysis** — identifying long-term trends, volatility, and performance patterns across the full dataset
2. **2008 Financial Crisis deep dive** — zooming in on the period surrounding the crisis to understand how price and trading volume were affected and how long recovery took

---

## Dataset
- **URL:** https://www.kaggle.com/datasets/anadiskt/goldman-sachs-gs-stock-data-19992026
- **Source:** Barchart (via proxy)
- **Table:** `g-sachs.fin_sheets.master_dataset`
- **Fields:** Date, Open, High, Low, Close, Volume, Dividends, Stock Splits, Source
- **Total Records:** 6,755 trading days

---

## Part 1: Broad Historical Analysis

### Key Findings
- GS stock closed higher than it opened on **3,433 out of 6,755 trading days (50.82%)**
- The **biggest single-day gain** was **$64.18**
- The **biggest single-day loss** was **$52.16**

---

### How often did GS close higher than it opened?
```sql
SELECT COUNT(*)
FROM `g-sachs.fin_sheets.master_dataset`
WHERE Close > Open
```

---

### 10 Biggest Single-Day Gains
```sql
SELECT *, (Close - Open) AS diff
FROM `g-sachs.fin_sheets.master_dataset`
ORDER BY diff DESC
LIMIT 10
```

---

### 10 Biggest Single-Day Losses
```sql
SELECT *, (Open - Close) AS diff
FROM `g-sachs.fin_sheets.master_dataset`
ORDER BY diff DESC
LIMIT 10
```

---

### Average Closing Price Per Quarter
Establishing a long-term baseline of how GS closing price has trended across each quarter from 1999 through 2026.
```sql
SELECT 
    EXTRACT(YEAR FROM Date) AS Year, 
    EXTRACT(QUARTER FROM Date) AS Quarter, 
    AVG(Close) AS Avg_Close
FROM `g-sachs.fin_sheets.master_dataset`
GROUP BY Year, Quarter
ORDER BY Year, Quarter
```

---

### Average Trading Volume Per Quarter
A preliminary look at volume trends revealed a notable spike in trading volume during 2008 and 2009, suggesting heightened market activity during the financial crisis — prompting the deeper analysis in Part 2.
```sql
SELECT 
    EXTRACT(YEAR FROM Date) AS Year, 
    EXTRACT(QUARTER FROM Date) AS Quarter, 
    ROUND(AVG(Volume)) AS Avg_Vol
FROM `g-sachs.fin_sheets.master_dataset`
GROUP BY Year, Quarter
ORDER BY Year, Quarter
```

---

### Quarter-Over-Quarter Price Change
To understand how GS stock performance shifted from one quarter to the next, this query uses a **CTE** to calculate quarterly average closing prices, then applies a **LAG window function** to compare each quarter against the prior quarter and calculate the percentage change.
```sql
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
```

---

## Part 2: 2008 Financial Crisis Deep Dive

### Context
The volume analysis in Part 1 revealed a dramatic spike in trading activity during Q3 and Q4 of 2008 alongside a steep decline in closing price. This section zooms in on the crisis period to quantify the impact on GS stock and track the subsequent recovery.

---

### Monthly Average Closing Price and Volume (2007–2009)
Starting in 2007 establishes a pre-crisis baseline, making the magnitude of the 2008 collapse more visible in context.
```sql
SELECT 
    FORMAT_DATE('%Y-%m', DATE(Date)) AS Month,
    ROUND(AVG(Close), 2) AS Avg_Close,
    ROUND(AVG(Volume), 0) AS Avg_Volume
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2007-01-01' AND '2009-12-31'
GROUP BY Month
ORDER BY Month;
```

---

### Peak Volume Days During the Crisis
Identifying the highest volume trading days during the crisis to determine whether peak volume corresponded with the steepest price declines.
```sql
SELECT 
    DATE(Date) AS Date,
    ROUND(Close, 2) AS Close,
    Volume,
    ROUND(Close - Open, 2) AS Daily_Change
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2008-01-01' AND '2009-06-30'
ORDER BY Volume DESC
LIMIT 10;
```

---

### Quarter-Over-Quarter Price and Volume Trend During the Crisis
Tracking both average closing price and average trading volume by quarter to show how the two metrics moved in relation to each other throughout the crisis period.
```sql
SELECT 
    EXTRACT(YEAR FROM DATE(Date)) AS Year,
    CONCAT('Q', CAST(EXTRACT(QUARTER FROM DATE(Date)) AS STRING)) AS Quarter,
    ROUND(AVG(Close), 2) AS Avg_Close,
    ROUND(AVG(Volume), 0) AS Avg_Volume
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2007-01-01' AND '2009-12-31'
GROUP BY Year, Quarter
ORDER BY Year, Quarter;
```

---

### Recovery Tracking (2010–2013)
Tracking monthly average closing price beginning in 2010 to identify when GS stock returned to pre-crisis price levels following the 2008 collapse.
```sql
SELECT 
    FORMAT_DATE('%Y-%m', DATE(Date)) AS Month,
    ROUND(AVG(Close), 2) AS Avg_Close
FROM `g-sachs.fin_sheets.master_dataset`
WHERE DATE(Date) BETWEEN '2010-01-01' AND '2013-12-31'
GROUP BY Month
ORDER BY Month;
```

---

## Tools Used
- **Google BigQuery** — SQL queries and data analysis
- **SQL Concepts Demonstrated:** Aggregations, filtering, CTEs, window functions (LAG), date functions, quarter extraction

---

## Key Findings

### Broad Historical Analysis
- GS stock closed higher than it opened on **3,433 out of 6,755 trading days (50.82%)**, suggesting a slight but consistent long-term upward bias
- The **biggest single-day gain was $64.18** (April 9, 2025) and the **biggest single-day loss was $52.16** (February 27, 2026), both occurring in recent years reflecting elevated price levels

### 2008 Financial Crisis
- The crisis had a dramatic impact on both price and volume. Average quarterly closing price fell from **$163.06 in Q4 2007** to a low of **$64.02 in Q4 2008** — a decline of approximately **61%** in just one year
- Trading volume surged in lockstep with the price collapse. Average quarterly volume spiked from **7.8M in Q1 2007** to a peak of **25.9M in Q1 2009**, more than tripling as panic selling accelerated
- The highest single volume day during the crisis was **September 18, 2008** with over **114.5 million shares traded** — the same week Lehman Brothers collapsed — with GS closing at $79.86
- By **November 20, 2008**, GS stock had fallen to an average close of just **$38.57**, representing the floor of the crisis period

### Recovery
- Recovery was slow and uneven. Despite an initial rebound in 2009, GS stock did not consistently trade above its **2007 average closing price of $155.32** until **April 2015** — nearly **seven years after the crisis peak**
- The recovery was further disrupted in 2011-2012, when average monthly closing prices fell back below $80, suggesting that broader macroeconomic headwinds continued to suppress GS stock well after the initial crisis

---

## About
Analysis conducted by Jacob Fairweather as part of a data analytics portfolio project.  
[LinkedIn](https://www.linkedin.com/in/jacob-fairweather/) | [Tableau](https://public.tableau.com/app/profile/jacob.fairweather/vizzes) | [GitHub](https://github.com/jakefair97)
