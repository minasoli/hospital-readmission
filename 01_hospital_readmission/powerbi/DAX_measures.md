# Power BI DAX Measures — Hospital Readmission Analysis

## Table: fact_readmissions (imported via SQL query 03_analysis_queries.sql)

---

### Core KPI Measures

```dax
-- Total Encounters
Total Encounters =
COUNTROWS(fact_readmissions)

-- Total Readmissions
Total Readmissions =
CALCULATE(
    COUNTROWS(fact_readmissions),
    fact_readmissions[readmitted_30day] = 1
)

-- 30-Day Readmission Rate
Readmission Rate % =
DIVIDE(
    [Total Readmissions],
    [Total Encounters],
    0
)

-- Average Length of Stay
Avg LOS (Days) =
AVERAGE(fact_readmissions[length_of_stay])

-- Average Days to Readmission (only for readmitted patients)
Avg Days to Readmission =
CALCULATE(
    AVERAGE(fact_readmissions[days_to_readmission]),
    fact_readmissions[readmitted_30day] = 1
)
```

---

### Benchmark Comparison Measures

```dax
-- CMS National Benchmark (hardcoded for comparison)
-- CMS 2023 average all-cause 30-day readmission rate is ~15.5%
CMS Benchmark Rate =
0.155

-- Variance from Benchmark
Variance from Benchmark =
[Readmission Rate %] - [CMS Benchmark Rate]

-- Flag: Above Benchmark
Above Benchmark =
IF([Variance from Benchmark] > 0, "Above", "At or Below")
```

---

### Time Intelligence Measures

```dax
-- Readmission Rate - Prior Quarter
Readmission Rate % PQ =
CALCULATE(
    [Readmission Rate %],
    DATEADD(fact_readmissions[admit_date], -1, QUARTER)
)

-- Quarter over Quarter Change
QoQ Change =
[Readmission Rate %] - [Readmission Rate % PQ]
```

---

### Suggested Report Pages

| Page | Visuals |
|---|---|
| Executive Summary | KPI cards (Rate, Encounters, Avg LOS), trend line by month |
| Hospital Breakdown | Bar chart by hospital, matrix with rate + LOS |
| Diagnosis Analysis | Treemap by category, bar chart by diagnosis |
| Payer Analysis | Donut chart by payer type, bar by payer name |
| Patient Demographics | Age band bar chart, gender split |
| Physician Quality | Table of high-volume physicians with rate flags |

---

### Suggested Slicers

- Admit Quarter (2023-Q1 through 2023-Q4)
- Hospital Name
- Primary Diagnosis Category
- Payer Type
- Age Band
- Gender
- Discharge Disposition
