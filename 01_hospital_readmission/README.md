# Hospital 30-Day Readmission Analysis

**Tools:** SQL Server · Power BI · DAX  
**Domain:** Healthcare Analytics · Quality Metrics · Population Health  
**Data:** 1,200 synthetic patient encounters modeled on CMS reporting standards

---

## Project Overview

Hospital readmissions within 30 days of discharge are one of the most closely watched quality indicators in U.S. healthcare. CMS (Centers for Medicare and Medicaid Services) penalizes hospitals with above-average readmission rates through the Hospital Readmissions Reduction Program (HRRP). This project builds an end-to-end analytical solution that a quality improvement team or hospital administrator could use to identify risk factors, benchmark performance, and target intervention.

---

## Business Questions Answered

- What is our overall 30-day readmission rate, and how does it compare to the CMS national benchmark?
- Which hospitals and diagnoses have the highest readmission rates?
- Are certain payers (Medicare, Medicaid, commercial) associated with higher readmission risk?
- How does patient age and length of stay correlate with readmission?
- Which discharge dispositions (home, SNF, home health) show the worst outcomes?
- Are any attending physicians statistical outliers worth reviewing?

---

## Technical Architecture

```
CSV Source (readmissions.csv)
        │
        ▼
staging.readmissions_raw        ← raw load, no transformation
        │
        ▼
  ETL Transform (SQL)
  ┌─────────────────────────────────────────┐
  │  dim_hospital  dim_diagnosis  dim_payer  │
  │              fact_readmissions           │
  └─────────────────────────────────────────┘
        │
        ▼
   Power BI Report
   (KPI Cards · Bar Charts · Trend Lines · Matrix · Slicers)
```

---

## SQL Scripts

| File | Purpose |
|---|---|
| `sql/01_create_tables.sql` | Creates staging schema, dimension tables, and fact table |
| `sql/02_transform_load.sql` | Populates dimensions and loads the fact table with derived fields |
| `sql/03_analysis_queries.sql` | Eight analytical queries used as Power BI data sources |

---

## Key Findings (Sample Data)

- Overall 30-day readmission rate: ~28% (intentionally elevated vs. CMS benchmark to create meaningful variance for analysis)
- Heart Failure and Sepsis show the highest diagnosis-level readmission rates
- Medicare and Medicaid patients readmit at higher rates than commercial payers
- Patients discharged AMA (Against Medical Advice) have the shortest median days to readmission
- Readmission risk increases notably in the 75-84 and 85+ age bands

---

## Power BI Report Structure

**Page 1 — Executive Summary**  
KPI cards for overall rate, total encounters, avg LOS, and CMS benchmark variance. Monthly trend line.

**Page 2 — Hospital & Physician**  
Bar chart ranking hospitals by readmission rate. Physician outlier table with volume filter.

**Page 3 — Diagnosis & Payer**  
Treemap by diagnosis category. Side-by-side comparison of payer types.

**Page 4 — Patient Demographics**  
Age band analysis. Gender breakdown. Discharge disposition impact table.

All pages include cross-filtering slicers for Quarter, Hospital, Diagnosis Category, Payer Type, and Age Band.

---

## DAX Measures

See `powerbi/DAX_measures.md` for the full measure library including readmission rate, CMS benchmark comparison, quarter-over-quarter change, and conditional formatting logic.

---

## How to Run This Project

1. Import `data/readmissions.csv` into SQL Server using SSMS Import Wizard or BULK INSERT
2. Run `sql/01_create_tables.sql` to create the schema
3. Run `sql/02_transform_load.sql` to populate dimension and fact tables
4. Connect Power BI Desktop to your SQL Server instance
5. Use the queries in `sql/03_analysis_queries.sql` as import-mode data sources
6. Add the DAX measures from `powerbi/DAX_measures.md` to the model

---

## About

Built as part of a healthcare data analytics portfolio demonstrating SQL data modeling, ETL design, and Power BI development. Background includes hands-on experience with EHR systems (MD Synergy, eClinicalWorks) and SSIS ETL workflows in clinical settings.
