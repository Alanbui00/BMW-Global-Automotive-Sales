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

---

##  Technologies Used
 
### Data Analysis
- **PostgreSQL** - Data storage and SQL analytics
- **SQL** - Window functions, CTEs, correlation analysis
 
### Visualization
- **Power BI** - Interactive dashboards with DAX measures
 
### Tools
- **Excel/CSV** - Data export and manipulation
- **Git/GitHub** - Version control and collaboration

---

## Repository Structure

--

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
 
