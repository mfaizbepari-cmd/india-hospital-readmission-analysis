/*=========================================================
    Table: Patients
    Description:
    Stores demographic and insurance information for every
    patient in the hospital network.
=========================================================*/

CREATE TABLE patients (
    patient_id UUID PRIMARY KEY,
    age SMALLINT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    state VARCHAR(50) NOT NULL,
    bpl_card BOOLEAN NOT NULL,
    insurance_type VARCHAR(20) NOT NULL,
    comorbidity_count SMALLINT NOT NULL,
    prev_admissions SMALLINT NOT NULL,

    CONSTRAINT chk_patient_age
        CHECK (age BETWEEN 0 AND 120),

    CONSTRAINT chk_comorbidity_count
        CHECK (comorbidity_count >= 0),

    CONSTRAINT chk_prev_admissions
        CHECK (prev_admissions >= 0)
);


/*=========================================================
    Table: Hospitals

    Description:
    Stores information about hospitals including location,
    capacity, tier, and teaching status.
=========================================================*/

CREATE TABLE hospitals (
    hospital_id UUID PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    state VARCHAR(50) NOT NULL,
    tier VARCHAR(10) NOT NULL,
    beds SMALLINT NOT NULL,
    teaching BOOLEAN NOT NULL,

    CONSTRAINT chk_beds
        CHECK (beds > 0),

    CONSTRAINT chk_hospital_tier
        CHECK (tier IN ('tier1', 'tier2', 'tier3'))
);



/*==========================================================
    Table: Admissions

    Description:
    Stores every hospital admission for each patient.
    Links patients with hospitals and contains
    admission details, clinical indicators,
    and readmission outcomes.
==========================================================*/

CREATE TABLE admissions (

    admission_id UUID PRIMARY KEY,

    patient_id UUID NOT NULL,

    hospital_id UUID NOT NULL,

    admit_date DATE NOT NULL,

    discharge_date DATE NOT NULL,

    los_days SMALLINT NOT NULL,

    admit_type VARCHAR(20) NOT NULL,

    ward_type VARCHAR(20) NOT NULL,

    discharge_type VARCHAR(20) NOT NULL,

    num_procedures SMALLINT NOT NULL,

    charlson_index SMALLINT NOT NULL,

    hba1c NUMERIC(4,1),

    creatinine NUMERIC(4,2),

    haemoglobin NUMERIC(4,1),

    systolic_bp SMALLINT,

    readmitted_30d BOOLEAN NOT NULL,

    readmitted_7d BOOLEAN NOT NULL,

        CONSTRAINT chk_los_days
        CHECK (los_days >= 0),

    CONSTRAINT chk_num_procedures
        CHECK (num_procedures >= 0),

    CONSTRAINT chk_charlson_index
        CHECK (charlson_index >= 0),

    CONSTRAINT chk_hba1c
        CHECK (hba1c BETWEEN 2.0 AND 20.0),

    CONSTRAINT chk_creatinine
        CHECK (creatinine BETWEEN 0.1 AND 20.0),

    CONSTRAINT chk_haemoglobin
        CHECK (haemoglobin BETWEEN 3.0 AND 25.0),

    CONSTRAINT chk_systolic_bp
        CHECK (systolic_bp BETWEEN 50 AND 300),

        CONSTRAINT fk_admission_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_admission_hospital
        FOREIGN KEY (hospital_id)
        REFERENCES hospitals(hospital_id)
);











/* ==========================================================
    Table: Diagnoses

    Description:
    Stores every diagnosis for each admission.
    Links admissions with ICD-10 codes and contains
    diagnosis details, rank, and category.
==========================================================*/
create table diagnoses (
    diag_id UUID PRIMARY KEY,
    admission_id UUID NOT NULL,
    icd10_code VARCHAR(10) NOT NULL,
    diag_desc VARCHAR(200) NOT NULL,
    diag_rank SMALLINT NOT NULL,
    diag_category VARCHAR(50) NOT NULL,
    CONSTRAINT chk_diag_rank
        CHECK (diag_rank > 0),
    CONSTRAINT fk_diag_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        
);





/* ==========================================================
    Table: Bills

    Description:
    Stores every bill for each admission.
    Links admissions with billing details, costs, and subsidies.
==========================================================*/
CREATE TABLE bills (
    bill_id UUID PRIMARY KEY,
    admission_id UUID NOT NULL,
    
    total_cost_inr NUMERIC(12,2) NOT NULL,
    
    govt_subsidy_inr NUMERIC(12,2) NOT NULL,
    
    out_of_pocket_inr NUMERIC(12,2) NOT NULL,
    
    cost_category VARCHAR(20) NOT NULL,

    CONSTRAINT chk_total_cost
    CHECK (total_cost_inr >= 0),

    CONSTRAINT chk_subsidy
        CHECK (govt_subsidy_inr >= 0),
    
    CONSTRAINT chk_out_of_pocket
        CHECK (out_of_pocket_inr >= 0),

        CONSTRAINT chk_cost_category
    CHECK (
        cost_category IN (
            'Room',
            'Lab',
            'Procedure',
            'Pharmacy'
        )
    ),
    
    CONSTRAINT fk_bill_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
);