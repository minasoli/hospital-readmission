-- ============================================================
-- Project: Hospital 30-Day Readmission Analysis
-- Script:  02_transform_load.sql
-- Purpose: Populate dimensions and fact table from staging
-- ============================================================

-- ── 1. Populate dim_hospital ──────────────────────────────────
INSERT INTO dbo.dim_hospital (hospital_name, region)
SELECT DISTINCT
    hospital,
    CASE hospital
        WHEN 'St. Mary Medical Center' THEN 'Northeast'
        WHEN 'Riverside General'       THEN 'South'
        WHEN 'Valley Health'           THEN 'Midwest'
        WHEN 'Summit Hospital'         THEN 'West'
        WHEN 'Lakeside Medical'        THEN 'Southeast'
    END
FROM staging.readmissions_raw;

-- ── 2. Populate dim_diagnosis ─────────────────────────────────
INSERT INTO dbo.dim_diagnosis (diagnosis_name, diagnosis_category)
SELECT DISTINCT
    primary_diagnosis,
    CASE primary_diagnosis
        WHEN 'Heart Failure' THEN 'Cardiovascular'
        WHEN 'AMI'           THEN 'Cardiovascular'
        WHEN 'Stroke'        THEN 'Cardiovascular'
        WHEN 'Pneumonia'     THEN 'Respiratory'
        WHEN 'COPD'          THEN 'Respiratory'
        WHEN 'Diabetes'      THEN 'Endocrine'
        WHEN 'Sepsis'        THEN 'Infectious'
        WHEN 'Hip Fracture'  THEN 'Musculoskeletal'
    END
FROM staging.readmissions_raw;

-- ── 3. Populate dim_payer ─────────────────────────────────────
INSERT INTO dbo.dim_payer (payer_name, payer_type)
SELECT DISTINCT
    payer,
    CASE payer
        WHEN 'Medicare'    THEN 'Government'
        WHEN 'Medicaid'    THEN 'Government'
        WHEN 'Blue Cross'  THEN 'Commercial'
        WHEN 'Aetna'       THEN 'Commercial'
        WHEN 'UnitedHealth'THEN 'Commercial'
        WHEN 'Self-Pay'    THEN 'Self-Pay'
    END
FROM staging.readmissions_raw;

-- ── 4. Populate fact_readmissions ─────────────────────────────
INSERT INTO dbo.fact_readmissions (
    patient_id, hospital_key, diagnosis_key, payer_key,
    admit_date, discharge_date, length_of_stay,
    age, age_band, gender, discharge_disposition,
    readmitted_30day, days_to_readmission,
    attending_physician_id, admit_month, admit_quarter
)
SELECT
    r.patient_id,
    h.hospital_key,
    d.diagnosis_key,
    p.payer_key,
    r.admit_date,
    r.discharge_date,
    r.length_of_stay,
    r.age,
    CASE
        WHEN r.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN r.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN r.age BETWEEN 65 AND 74 THEN '65-74'
        WHEN r.age BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
    END                                         AS age_band,
    r.gender,
    r.discharge_disposition,
    r.readmitted_30day,
    r.days_to_readmission,
    r.attending_physician_id,
    MONTH(r.admit_date)                         AS admit_month,
    CONCAT(YEAR(r.admit_date), '-Q',
           CEILING(MONTH(r.admit_date) / 3.0))  AS admit_quarter
FROM staging.readmissions_raw r
JOIN dbo.dim_hospital  h ON r.hospital          = h.hospital_name
JOIN dbo.dim_diagnosis d ON r.primary_diagnosis = d.diagnosis_name
JOIN dbo.dim_payer     p ON r.payer             = p.payer_name;
