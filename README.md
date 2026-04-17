<div align="center">
 
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=for-the-badge&logo=postgresql)
![Power BI](https://img.shields.io/badge/Power_BI-Complete-F2C811?style=for-the-badge&logo=powerbi)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

Interactive analytics dashboard analyzing BMW sales performance, regional insights, and EV adoption trends (2018-2023)

[View Live Dashboard](bmw.pbix) [View SQL Code](bmw.session.sql) 
 
</div>
 
---

# BMW Sales Performance Analysis

---

##  Project Overview
 
This project provides a comprehensive analysis of BMW sales data across multiple regions and models, with a focus on identifying revenue drivers, regional performance, and the influence of macroeconomic factors on electric vehicle (EV) adoption.
 
### Business Questions Addressed
 
1. **What are the main drivers of revenue growth?**
2. **Which regions and models perform best?**
3. **Is EV adoption increasing over time?**
4. **Do fuel prices and GDP growth influence EV adoption?**

---

## Key Findings
1. Revenue growth is primarily driven by increases in unit sales rather than pricing. From 2018 to 2025, revenue grew by approximately 22%, closely tracking unit growth, while average prices remained largely stable (within ±0.4% YoY). This indicates a volume-driven growth strategy rather than reliance on price increases.
2. Revenue is evenly distributed across all regions, with each contributing roughly 25% of total revenue, highlighting a well-diversified global strategy.
Top region: China (slightly leading in total revenue)
Top model: X7 (~18% market share), driven by premium pricing
EV models (iX, i4): Contribute over 25% of total revenue, showing strong performance
Overall, BMW maintains a balanced product portfolio, combining high-margin luxury vehicles with high-volume mid-range models.
3. Yes, EV adoption has increased significantly across all regions, rising from approximately 2% in 2018 to nearly 20% in 2025.
Growth was rapid in early years (100%+ YoY) and has since stabilized to ~13–15% YoY, indicating a transition from early adoption to a more mature growth phase.
Adoption trends are consistent globally, suggesting a synchronized shift toward electrification.
4. Fuel prices show a strong positive correlation with EV adoption (r ≈ 0.95), indicating that higher fuel costs are closely associated with increased EV demand. As fuel prices rise, consumers are more likely to shift toward electric vehicles as a cost-saving alternative.
In contrast, GDP growth shows little to no correlation with EV adoption, as EV share continues to increase steadily despite fluctuations in economic growth across all regions.
Overall, this suggests that EV adoption is influenced more by energy costs and market incentives rather than broader macroeconomic conditions, with fuel prices acting as a key contributing factor alongside policy and technological advancements.

---

##  Technologies Used
 
### Data Analysis
- **PostgreSQL** - Data storage and SQL analytics
- **SQL** - Window functions, CTEs, correlation analysis
 
### Visualization - Currently Working
- **Power BI** - Interactive dashboards with DAX measures
 
### Tools
- **Excel/CSV** - Data export and manipulation
- **Git/GitHub** - Version control and collaboration

---


## Getting Started
 
### Prerequisites
- PostgreSQL 12+ installed
- Power BI Desktop (optional, for dashboards)
 
### Installation
 
1. **Clone the repository**
   ```bash
   git clone https://github.com/Alanbui2000/bmw-sales-analysis.git
   cd bmw-sales-analysis
   ```
 
2. **Set up database**
   ```bash
   # Create database
   createdb bmw_sales_db
   
   # Load schema
   found on sql file
   
   # Import data (adjust path to your CSV)
   psql -d bmw_sales_db -c "\COPY bmw_data FROM 'data/bmw_sales_data.csv' CSV HEADER" # issues with importing data use PostgreSQL and load in database 
   
   ```
---

##  Analysis Highlights
 
### SQL Techniques Demonstrated
 
 **Window Functions**
- `LAG()` for year-over-year comparisons
- `RANK()` for model/region rankings
- `PARTITION BY` for grouped calculations
 
 **Common Table Expressions (CTEs)**
- Multi-step analysis with readable code
- Complex metrics breakdown
 
 **Correlation Analysis**
- `CORR()` function for statistical relationships
- GDP and fuel price impact quantification
 
 **Data Validation**
- NULL checks with `FILTER` clause
- Duplicate detection
- Range validation
 
 **Aggregation & Grouping**
- Regional/temporal analysis
- Model portfolio segmentation
- Market share calculations

- ### Power BI Features
 
 **Interactive Dashboards**
- 5 comprehensive pages
- Cross-filtering and drill-through
 **Advanced Visualizations**
- Waterfall charts (revenue decomposition)
- Scatter plots (correlation analysis)

---

## Dashboards
 
### Power BI Dashboard
 
<div align="center">

![Power BI Executive Summary](.png)
*Executive Summary Dashboard - Key Performance Indicators*
 
![Power BI Revenue Analysis](.png)
*Revenue Analysis Dashboard - Growth Drivers*
 
</div>
**Features:**
- Interactive filters (Year, Region, Model)
- Drill-through to detailed views

Download .pbix File](bmw.pbix)
 
---
## Insights & Recommendations
 
### Strategic Recommendations

1. Accelerate Investment in Electric Vehicles (EVs)
With EV adoption rising from ~2% to ~20% and a strong correlation with fuel prices (r ≈ 0.95), BMW should continue expanding its EV lineup (e.g., iX, i4) and invest in battery technology and charging infrastructure partnerships to capture growing demand.

2. Leverage Premium Models to Maximize Profitability
High-end models like the X7 generate the most revenue due to premium pricing. BMW should continue prioritizing luxury segments while maintaining brand positioning, as these models significantly boost margins despite lower relative volumes.

3. Optimize Production Around Seasonal Demand Peaks
Sales consistently peak in March, June, September, and December. Aligning inventory, marketing campaigns, and supply chain operations with these periods can improve efficiency and maximize revenue during high-demand months.

4. Maintain a Balanced Global Market Strategy
Revenue is evenly distributed (~25% per region), reducing geographic risk. BMW should continue this diversification strategy while prioritizing high-growth regions like China and the U.S., which show strong upward trends.

5. Align Pricing Strategy with Volume Growth
Since revenue growth is primarily volume-driven and prices remain stable, BMW should focus on increasing sales volume through market expansion, financing options, and product accessibility rather than relying on price increases.
