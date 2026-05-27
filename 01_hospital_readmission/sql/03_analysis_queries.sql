-- ============================================================
-- Project: Hospital 30-Day Readmission Analysis
-- Script:  03_analysis_queries.sql
-- Purpose: Core analytical queries (also used as Power BI
--          import-mode query sources)
-- ============================================================

-- ── KPI 1: Overall 30-Day Readmission Rate ───────────────────
SELECT
    COUNT(*)                                            AS total_encounters,
    SUM(CAST(readmitted_30day AS INT))                  AS total_readmissions,
    ROUND(
        100.0 * SUM(CAST(readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct
FROM dbo.fact_readmissions;


-- ── KPI 2: Readmission Rate by Hospital ──────────────────────
SELECT
    h.hospital_name,
    COUNT(*)                                            AS encounters,
    SUM(CAST(f.readmitted_30day AS INT))                AS readmissions,
    ROUND(
        100.0 * SUM(CAST(f.readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct,
    ROUND(AVG(CAST(f.length_of_stay AS FLOAT)), 1)      AS avg_los
FROM dbo.fact_readmissions f
JOIN dbo.dim_hospital h ON f.hospital_key = h.hospital_key
GROUP BY h.hospital_name
ORDER BY readmission_rate_pct DESC;


-- ── KPI 3: Readmission Rate by Primary Diagnosis ─────────────
SELECT
    d.diagnosis_name,
    d.diagnosis_category,
    COUNT(*)                                            AS encounters,
    SUM(CAST(f.readmitted_30day AS INT))                AS readmissions,
    ROUND(
        100.0 * SUM(CAST(f.readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct
FROM dbo.fact_readmissions f
JOIN dbo.dim_diagnosis d ON f.diagnosis_key = d.diagnosis_key
GROUP BY d.diagnosis_name, d.diagnosis_category
ORDER BY readmission_rate_pct DESC;


-- ── KPI 4: Readmission Rate by Payer ─────────────────────────
SELECT
    p.payer_name,
    p.payer_type,
    COUNT(*)                                            AS encounters,
    SUM(CAST(f.readmitted_30day AS INT))                AS readmissions,
    ROUND(
        100.0 * SUM(CAST(f.readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct
FROM dbo.fact_readmissions f
JOIN dbo.dim_payer p ON f.payer_key = p.payer_key
GROUP BY p.payer_name, p.payer_type
ORDER BY readmission_rate_pct DESC;


-- ── KPI 5: Readmission Rate by Age Band ──────────────────────
SELECT
    age_band,
    COUNT(*)                                            AS encounters,
    SUM(CAST(readmitted_30day AS INT))                  AS readmissions,
    ROUND(
        100.0 * SUM(CAST(readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct,
    ROUND(AVG(CAST(length_of_stay AS FLOAT)), 1)        AS avg_los
FROM dbo.fact_readmissions
GROUP BY age_band
ORDER BY age_band;


-- ── KPI 6: Monthly Readmission Trend ─────────────────────────
SELECT
    admit_quarter,
    admit_month,
    COUNT(*)                                            AS encounters,
    SUM(CAST(readmitted_30day AS INT))                  AS readmissions,
    ROUND(
        100.0 * SUM(CAST(readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct
FROM dbo.fact_readmissions
GROUP BY admit_quarter, admit_month
ORDER BY admit_quarter, admit_month;


-- ── KPI 7: High-Risk Physicians (flag for quality review) ────
SELECT
    attending_physician_id,
    COUNT(*)                                            AS encounters,
    SUM(CAST(readmitted_30day AS INT))                  AS readmissions,
    ROUND(
        100.0 * SUM(CAST(readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct,
    ROUND(AVG(CAST(length_of_stay AS FLOAT)), 1)        AS avg_los
FROM dbo.fact_readmissions
GROUP BY attending_physician_id
HAVING COUNT(*) >= 10   -- minimum volume filter
ORDER BY readmission_rate_pct DESC;


-- ── KPI 8: Discharge Disposition Impact ──────────────────────
SELECT
    discharge_disposition,
    COUNT(*)                                            AS encounters,
    SUM(CAST(readmitted_30day AS INT))                  AS readmissions,
    ROUND(
        100.0 * SUM(CAST(readmitted_30day AS INT)) / COUNT(*), 2
    )                                                   AS readmission_rate_pct,
    ROUND(AVG(CAST(days_to_readmission AS FLOAT)), 1)   AS avg_days_to_readmit
FROM dbo.fact_readmissions
WHERE readmitted_30day = 1
GROUP BY discharge_disposition
ORDER BY readmission_rate_pct DESC;
