## Dataset Overview

### Dataset Name

India Hospital Readmission Dataset (2015–2024)

### Total Tables

5

### Tables Included

## Table 1: Patients

### Table Purpose

Stores demographic and background information for each patient in the hospital network. This table acts as the master patient dimension and is used to analyze patient characteristics, insurance coverage, previous admissions, and demographic trends.

### Candidate Primary Key

patient_id

### Candidate Foreign Keys

None

### Expected Relationships

- One patient can have multiple hospital admissions.
- One patient can have multiple diagnosis records (through admissions).
- One patient can have multiple billing records (through admissions).

---




- Admissions
- Hospitals
- Diagnoses
- Billing

### Dataset Purpose

This dataset captures historical hospital admission, patient demographic, diagnosis, hospital, and billing information to support healthcare analytics, operational reporting, and business intelligence.

### Expected Analytical Areas

- Patient Analytics
- Hospital Performance
- Clinical Analysis
- Financial Analysis
- Readmission Analysis