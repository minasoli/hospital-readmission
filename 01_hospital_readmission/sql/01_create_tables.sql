-- ============================================================
-- Project: Hospital 30-Day Readmission Analysis
-- Script:  01_create_tables.sql
-- Author:  Mina | Healthcare Data Portfolio
-- Purpose: Create and load the staging and analytical tables
-- ============================================================

-- Drop and recreate for clean load
DROP TABLE IF EXISTS staging.readmissions_raw;
DROP TABLE IF EXISTS dbo.fact_readmissions;
DROP TABLE IF EXISTS dbo.dim_hospital;
DROP TABLE IF EXISTS dbo.dim_diagnosis;
DROP TABLE IF EXISTS dbo.dim_payer;

-- ── Staging table (raw CSV load target) ──────────────────────
CREATE TABLE staging.readmissions_raw (
    patient_id              INT,
    hospital                VARCHAR(100),
    admit_date              DATE,
    discharge_date          DATE,
    length_of_stay          INT,
    age                     INT,
    gender                  CHAR(1),
    primary_diagnosis       VARCHAR(100),
    payer                   VARCHAR(50),
    discharge_disposition   VARCHAR(50),
    readmitted_30day        BIT,
    days_to_readmission     INT NULL,
    attending_physician_id  VARCHAR(10)
);

-- ── Dimension: Hospital ───────────────────────────────────────
CREATE TABLE dbo.dim_hospital (
    hospital_key    INT IDENTITY(1,1) PRIMARY KEY,
    hospital_name   VARCHAR(100) NOT NULL,
    region          VARCHAR(50)  NULL
);

-- ── Dimension: Diagnosis ──────────────────────────────────────
CREATE TABLE dbo.dim_diagnosis (
    diagnosis_key       INT IDENTITY(1,1) PRIMARY KEY,
    diagnosis_name      VARCHAR(100) NOT NULL,
    diagnosis_category  VARCHAR(50)  NULL   -- Cardiovascular, Respiratory, etc.
);

-- ── Dimension: Payer ──────────────────────────────────────────
CREATE TABLE dbo.dim_payer (
    payer_key   INT IDENTITY(1,1) PRIMARY KEY,
    payer_name  VARCHAR(50) NOT NULL,
    payer_type  VARCHAR(30) NULL   -- Government, Commercial, Self-Pay
);

-- ── Fact: Readmissions ────────────────────────────────────────
CREATE TABLE dbo.fact_readmissions (
    encounter_key           INT IDENTITY(1,1) PRIMARY KEY,
    patient_id              INT          NOT NULL,
    hospital_key            INT          NOT NULL REFERENCES dbo.dim_hospital(hospital_key),
    diagnosis_key           INT          NOT NULL REFERENCES dbo.dim_diagnosis(diagnosis_key),
    payer_key               INT          NOT NULL REFERENCES dbo.dim_payer(payer_key),
    admit_date              DATE         NOT NULL,
    discharge_date          DATE         NOT NULL,
    length_of_stay          INT          NOT NULL,
    age                     INT          NOT NULL,
    age_band                VARCHAR(20)  NOT NULL,   -- derived
    gender                  CHAR(1)      NOT NULL,
    discharge_disposition   VARCHAR(50)  NOT NULL,
    readmitted_30day        BIT          NOT NULL,
    days_to_readmission     INT          NULL,
    attending_physician_id  VARCHAR(10)  NOT NULL,
    admit_month             INT          NOT NULL,   -- derived
    admit_quarter           VARCHAR(6)   NOT NULL    -- derived e.g. 2023-Q1
);
