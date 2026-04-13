
-- ============================================================================
-- BMW SALES ANALYSIS 
-- ============================================================================
-- Author: [Alan Bui]
-- Database: PostgreSQL
-- Purpose: Analyze BMW sales performance, EV adoption trends, and macro impacts
-- Dataset: BMW sales data (2018-2023) across regions and models
-- ============================================================================

-- Connection verification
SELECT current_database();
SELECT inet_server_addr(), inet_server_port();
SELECT current_user;

-- ============================================================================
-- BUSINESS QUESTIONS
-- ============================================================================
/*  Business Questions 

    1. What are the main drivers of revenue growth
    2. Which regions and models perform best
    3. Is EV adoption increasing over time
    4. Do fuel prices and GDP growth influence EV adoption

*/

-- Create the data table
CREATE TABLE bmw_data (
    year INT,
    month INT,
    region VARCHAR(50),
    model VARCHAR(100),
    units_sold INT,
    avg_price_eur NUMERIC,
    revenue_eur NUMERIC,
    bev_share NUMERIC,
    premium_share NUMERIC,
    gdp_growth NUMERIC,
    fuel_price_index NUMERIC
);
-- Understand the data --
    -- Data Overview--
SELECT * 
FROM bmw_data
LIMIT 10;

    -- Count--
SELECT COUNT(*) AS Total_count
FROM bmw_data;

    -- Regions --
SELECT DISTINCT region 
FROM bmw_data;

    -- Models --
SELECT DISTINCT model
FROM bmw_data;

    -- Check missing values --
SELECT 
    COUNT(*) AS null_count,
    COUNT(*) FILTER (WHERE revenue_eur IS NULL) AS null_revenue,
    COUNT(*) FILTER (WHERE units_sold IS NULL) AS null_units,
    COUNT(*) FILTER (WHERE bev_share IS NULL) AS null_bev_share
FROM bmw_data;

-- Check for duplicates
SELECT year, month, region, model, COUNT(*)
FROM bmw_data
GROUP BY year, month, region, model
HAVING COUNT(*) > 1;

-- Check date range
SELECT MIN(year) AS start_year, MAX(year) AS end_year,
       MIN(month) AS start_month, MAX(month) AS end_month
FROM bmw_data;

-- Check for impossible values
SELECT COUNT(*) AS negative_values
FROM bmw_data
WHERE units_sold < 0 OR avg_price_eur < 0 OR revenue_eur < 0;

-- Core KPI --
    -- Total revenue and Units sold --
SELECT SUM(revenue_eur) AS total_revenue, SUM(units_sold) AS total_units
FROM bmw_data;

-- Time Based Analysis --
    -- Units Sold by Year --
SELECT 
    year,
    SUM(revenue_eur) AS revenue,
    LAG(SUM(revenue_eur)) OVER (ORDER BY year) AS prev_year,
    ROUND(
        (SUM(revenue_eur) - LAG(SUM(revenue_eur)) OVER (ORDER BY year)) 
        / LAG(SUM(revenue_eur)) OVER (ORDER BY year) * 100, 2
    ) AS growth_pct
FROM bmw_data
GROUP BY year
ORDER BY year;

-- ============================================================================
-- TIME-BASED ANALYSIS (Question 1: Revenue Growth Drivers)
-- ============================================================================
    
-- 1. What are the main drivers of revenue growth

-- Yearly Revenue Growth
WITH yearly_revenue AS (
    SELECT 
        year,
        SUM(revenue_eur) AS revenue,
        SUM(units_sold) AS units
    FROM bmw_data
    GROUP BY year
)

SELECT 
    year,
    revenue,
    units,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) 
        / LAG(revenue) OVER (ORDER BY year) * 100, 
        2
    ) AS yoy_revenue_growth_pct,
    ROUND(
        (units - LAG(units) OVER (ORDER BY year)) 
        / LAG(units) OVER (ORDER BY year)::NUMERIC * 100, 
        2
    ) AS yoy_units_growth_pct
FROM yearly_revenue
ORDER BY year;

-- Revenue growth is primarily driven by increases in unit sales rather than pricing.
-- Across all years, revenue growth closely tracks unit growth, indicating a volume-driven strategy.
-- The sharp increase in 2020 reflects a major expansion or recovery phase, while the steady growth from 2023–2025 suggests a mature and stable market with consistent demand.

-- Monthly Trend 
CREATE VIEW Monthly_Trends AS(
SELECT 
    year,
    month,
    SUM(revenue_eur) AS monthly_revenue,
    SUM(units_sold) AS monthly_units,
    ROUND(AVG(avg_price_eur), 2) AS avg_price
FROM bmw_data
GROUP BY year, month
ORDER BY year, month
)

-- Average Selling Price Trend
SELECT 
    year,
    ROUND(AVG(avg_price_eur), 2) AS avg_price_eur,
    ROUND(
        (AVG(avg_price_eur) - LAG(AVG(avg_price_eur)) OVER (ORDER BY year)) 
        / LAG(AVG(avg_price_eur)) OVER (ORDER BY year) * 100, 
        2
    ) AS yoy_price_change_pct
FROM bmw_data
GROUP BY year
ORDER BY year;

-- BMW’s revenue growth is predominantly volume-driven.
-- Unit sales growth closely mirrors revenue growth across all years, while average prices remain flat with minimal fluctuation.
-- This indicates that the company’s growth strategy focuses on expanding sales volume rather than increasing prices, suggesting strong demand and market expansion rather than premium pricing leverage.
 
-- Seasonality Analysis
SELECT 
    month,
    ROUND(AVG(units_sold), 0) AS avg_monthly_units,
    ROUND(STDDEV(units_sold), 0) AS units_volatility,
    ROUND(AVG(revenue_eur), 0) AS avg_monthly_revenue
FROM bmw_data
GROUP BY month
ORDER BY month;

--- BMW sales exhibit clear seasonal patterns, with peak performance occurring in March, June, September, and December.
--- These periods show significantly higher unit sales and revenue, indicating quarterly demand cycles. In contrast, other months maintain a stable baseline level of sales.
--- Additionally, peak months show higher volatility, suggesting that while demand is strong, it is also less predictable.
--- This seasonal pattern reinforces that revenue fluctuations are primarily driven by changes in unit volume rather than pricing.
-- ============================================================================
-- REGIONAL PERFORMANCE ANALYSIS (Question 2)
-- ============================================================================

-- Revenue by Region (Market Size)
SELECT region,
    SUM(revenue_eur) AS revenue,
    SUM(units_sold) AS units,
    ROUND(SUM(revenue_eur) / SUM(units_sold), 0) AS revenue_per_unit,
    ROUND(SUM(revenue_eur) * 100/ (SELECT SUM(revenue_eur) FROM bmw_data), 2) AS revenue_share_pct
FROM bmw_data
GROUP BY region
ORDER BY revenue DESC;

-- BMW demonstrates a highly balanced global performance, with each region contributing roughly 25% of total revenue.
-- This even distribution highlights a well-diversified market strategy that minimizes dependence on any single region.

-- EV Adoption by Region
SELECT 
    region,
    ROUND(AVG(bev_share), 3) AS avg_bev_share_pct,
    COUNT(DISTINCT model) AS models_offered
FROM bmw_data
GROUP BY region
ORDER BY avg_bev_share_pct DESC;

-- All regions average the share ev share with china being behind by 1 percent.
-- Shows how EV sales in each region is consistent and not one is lagging behind
 
-- Regional Growth Trends
SELECT 
    region,
    year,
    SUM(revenue_eur) AS revenue
FROM bmw_data
GROUP BY region, year
ORDER BY year, region;

-- BMW’s regional revenues show consistent long-term growth across all markets, with increasing convergence over time.
-- China stands out as the most stable growth driver, while the U.S. shows strong acceleration in recent years. Europe exhibits cyclical behavior, and the Rest of World segment demonstrates higher volatility, including a decline in the final year.
 
-- Regional EV Adoption Trend
CREATE VIEW vw_bev_yoy_growth AS
SELECT 
    year,
    region,
    AVG(bev_share) AS bev_share,

    LAG(AVG(bev_share)) OVER (
        PARTITION BY region ORDER BY year
    ) AS prev_year_bev,

    ROUND(
        (AVG(bev_share) - LAG(AVG(bev_share)) OVER (PARTITION BY region ORDER BY year))
        / LAG(AVG(bev_share)) OVER (PARTITION BY region ORDER BY year),
        4
    ) AS yoy_bev_growth_pct

FROM bmw_data
GROUP BY year, region;
-- As growth rates continue to stabilize, future gains in EV share will likely depend on innovation, infrastructure, and policy support rather than early adoption momentum.

-- ============================================================================
-- MODEL PERFORMANCE ANALYSIS (Question 2 - Models)
-- ============================================================================
 
 -- Top Models by Revenue
SELECT 
    model,
    SUM(revenue_eur) AS total_revenue,
    SUM(units_sold) AS total_units,
    ROUND(SUM(revenue_eur) / SUM(units_sold), 2) AS revenue_per_unit,
    ROUND(SUM(revenue_eur) * 100.0 / (SELECT SUM(revenue_eur) FROM bmw_data), 2) AS market_share_pct,
    ROUND(AVG(avg_price_eur), 2) AS avg_price
FROM bmw_data
GROUP BY model
ORDER BY total_revenue DESC

-- The X7 leads in total revenue due to its premium pricing, demonstrating the strong impact of high-end models. At the same time, mid-range models such as the X5 and 5 Series provide consistent volume-driven revenue.
-- Overall, the balanced distribution of market share across models reduces dependency on any single product while supporting both volume and margin growth.

-- Model Market Share by Region (Top 3 per Region)
WITH model_regional_revenue AS (
    SELECT 
        region,
        model,
        SUM(revenue_eur) AS revenue,
        SUM(units_sold) AS units,
        RANK() OVER (PARTITION BY region ORDER BY SUM(revenue_eur) DESC) AS revenue_rank
    FROM bmw_data
    GROUP BY region, model
)
SELECT 
    region,
    model,
    ROUND(revenue / 1000000, 2) AS revenue_millions,
    units,
    revenue_rank
FROM model_regional_revenue 
WHERE revenue_rank <= 3
ORDER BY region, revenue_rank;

-- BMW’s product leadership is highly consistent across regions, with the X7 emerging as the top revenue-generating model globally.
-- The iX ranks second in every region, highlighting strong and uniform demand for electric vehicles worldwide.
-- ============================================================================
-- EV ADOPTION ANALYSIS (Question 3)
-- ============================================================================
 
-- EV Adoption Trend Over Time
SELECT 
    year, 
    region,
    ROUND(AVG(bev_share), 2) AS avg_bev_share_pct,
    MIN(bev_share) AS min_bev_share,
    MAX(bev_share) AS max_bev_share
FROM bmw_data
GROUP BY year, region
ORDER BY year, region;
 
-- INSIGHT: Overall upward trend indicates increasing EV adoption in every region every year

-- ============================================================================
-- MACROECONOMIC IMPACT ANALYSIS (Question 4)
-- ============================================================================
 
-- GDP Growth vs EV Adoption by Region
SELECT 
    year, 
    ROUND(AVG(gdp_growth), 2) AS avg_gdp_growth_pct,
    ROUND(AVG(bev_share), 2) AS avg_bev_share_pct,
    region
FROM bmw_data
GROUP BY year, region
ORDER BY year, region;

-- EV adoption shows a consistent upward trend across all regions, increasing from approximately 2% in 2018 to nearly 20% in 2025, despite fluctuations in GDP growth.
-- There is no strong correlation between GDP growth and EV adoption, as BEV share continues to rise even during periods of slower economic growth.

-- Calculate correlation by region
WITH regional_correlations AS (
    SELECT 
        region,
        CORR(gdp_growth, bev_share) AS gdp_bev_correlation,
        CORR(fuel_price_index, bev_share) AS fuel_bev_correlation,
        COUNT(*) AS sample_size
    FROM bmw_data
    WHERE gdp_growth IS NOT NULL 
      AND bev_share IS NOT NULL 
      AND fuel_price_index IS NOT NULL
    GROUP BY region
)
SELECT 
    region,
    ROUND(gdp_bev_correlation::numeric, 3) AS gdp_ev_corr,
    ROUND(fuel_bev_correlation::numeric, 3) AS fuel_ev_corr,
    sample_size,
    CASE 
        WHEN ABS(gdp_bev_correlation) > 0.7 THEN 'Strong'
        WHEN ABS(gdp_bev_correlation) > 0.4 THEN 'Moderate'
        WHEN ABS(gdp_bev_correlation) > 0.2 THEN 'Weak'
        ELSE 'None'
    END AS gdp_relationship_strength,
    CASE 
        WHEN ABS(fuel_bev_correlation) > 0.7 THEN 'Strong'
        WHEN ABS(fuel_bev_correlation) > 0.4 THEN 'Moderate'
        WHEN ABS(fuel_bev_correlation) > 0.2 THEN 'Weak'
        ELSE 'None'
    END AS fuel_relationship_strength
FROM regional_correlations
ORDER BY ABS(fuel_bev_correlation) DESC;

-- EV adoption is strongly driven by fuel prices rather than macroeconomic growth. Across all regions, 
-- fuel price indices show a near-perfect positive correlation (~0.95) with EV share, indicating that rising fuel 
-- costs significantly accelerate the transition to electric vehicles. In contrast, GDP growth shows no meaningful relationship with EV adoption, suggesting that economic expansion alone is not a key driver of EV demand.

-- Overall correlation (all regions combined)
SELECT 
    ROUND(CORR(gdp_growth, bev_share)::numeric, 3) AS overall_gdp_ev_corr,
    ROUND(CORR(fuel_price_index, bev_share)::numeric, 3) AS overall_fuel_ev_corr,
    COUNT(*) AS total_observations
FROM bmw_data
WHERE gdp_growth IS NOT NULL 
  AND bev_share IS NOT NULL 
  AND fuel_price_index IS NOT NULL;

-- EV adoption is strongly correlated with fuel prices (0.95) but not with GDP growth, indicating that cost factors drive adoption more than economic expansion.
-- ============================================================================
-- REUSABLE VIEWS FOR DASHBOARDS
-- ============================================================================
 
-- Annual KPIs
CREATE OR REPLACE VIEW v_yearly_metrics AS
-- Purpose: Aggregate annual performance metrics for executive reporting
SELECT 
    year,
    SUM(revenue_eur) AS total_revenue,
    SUM(units_sold) AS total_units,
    ROUND(AVG(bev_share), 2) AS avg_bev_share_pct,
    ROUND(AVG(avg_price_eur), 2) AS avg_price_eur
FROM bmw_data
GROUP BY year
ORDER BY year;
 
-- Regional EV Trend
CREATE OR REPLACE VIEW v_regional_bev_trend AS
-- Purpose: Track EV adoption evolution by region for trend analysis
SELECT 
    year,
    region,
    ROUND(AVG(bev_share), 2) AS bev_share_pct,
    SUM(units_sold) AS units
FROM bmw_data
GROUP BY year, region
ORDER BY year, region;
 
-- Macro Impact Summary
CREATE OR REPLACE VIEW v_macro_impact AS
-- Purpose: Consolidate macroeconomic factors with EV metrics
SELECT 
    year,
    region,
    ROUND(AVG(gdp_growth), 2) AS gdp_growth_pct,
    ROUND(AVG(fuel_price_index), 2) AS fuel_price_index,
    ROUND(AVG(bev_share), 2) AS bev_share_pct
FROM bmw_data
GROUP BY year, region
ORDER BY year, region;

CREATE OR REPLACE VIEW yoy_revenue AS
SELECT
    year,
    region,
    SUM(revenue_eur) AS revenue,

    LAG(SUM(revenue_eur)) OVER (
        PARTITION BY region
        ORDER BY year
    ) AS prev_revenue,

    ROUND(
        (SUM(revenue_eur) - LAG(SUM(revenue_eur)) OVER (
            PARTITION BY region ORDER BY year
        )) / LAG(SUM(revenue_eur)) OVER (
            PARTITION BY region ORDER BY year
        ),
        4
    ) AS yoy_growth

FROM bmw_data
GROUP BY year, region;

-- ============================================================================
-- END OF ANALYSIS
-- ============================================================================

-- SUMMARY OF FINDINGS:
-- 
-- Question 1: Revenue Growth Drivers
-- • Revenue grew ~22% from 2018 to 2025
-- • Growth primarily driven by volume (~95%+) vs price (~<1% change YoY)
-- • China showed strongest and most consistent growth, reaching highest revenue by 2025
--
-- Question 2: Best Performing Regions & Models
-- • China leads with ~25.6% market share and ~€401B total revenue
-- • Top model: X7 with ~€286B revenue (~18% market share)
-- • Premium models (X7, iX) represent ~33% of revenue at significantly higher prices (€75K–€92K per unit)
--
-- Question 3: EV Adoption Trend
-- • EV share increased from ~2% (2018) to ~19–20% (2025)
-- • Adoption accelerating early, then stabilizing (~+2–3 percentage points per year recently)
-- • Europe slightly leads adoption (~20%), while other regions closely follow (~19%)
--
-- Question 4: Macroeconomic Influence on EV Adoption
-- • GDP growth correlation: Weak (no consistent relationship observed)
-- • Fuel price correlation: Not strongly evident from available data
-- • EV adoption appears driven more by structural factors than macroeconomic conditions
--
-- RECOMMENDATIONS:
-- 1. Continue expanding EV portfolio, as electrification is a strong and consistent global growth driver
-- 2. Focus on scaling production and supply chains during peak seasonal demand periods (March, June, September, December)
-- 3. Maintain balanced global market strategy while prioritizing high-growth regions like China and the U.S.