
/* ==========================================================
    Table: Patients
    Description:
    Contains patient demographic information such as age,
    gender, state, insurance type, and comorbidity count.
========================================================= */
COPY patients
FROM 'D:/Data analysis Project Datasets & Project/Hospital-Readmission-Analytics/data/raw/patients.csv'
DELIMITER ','
CSV HEADER;




/* ==========================================================
    Table: Hospitals
    Description:
    Stores information about hospitals including location,
    capacity, tier, and teaching status.
========================================================= */
COPY hospitals
FROM 'D:/Data analysis Project Datasets & Project/Hospital-Readmission-Analytics/data/raw/hospitals.csv'
DELIMITER ','
CSV HEADER;



/* ==========================================================
    Table: Admissions
    Description:
    Stores every hospital admission for each patient.
    Links patients with hospitals and contains
    admission details, clinical indicators,
    and readmission outcomes.
========================================================== */
COPY admissions
FROM 'D:/Data analysis Project Datasets & Project/Hospital-Readmission-Analytics/data/raw/admissions.csv'
DELIMITER ','
CSV HEADER;



/* ==========================================================
    Table: Diagnoses
    Description:
    Contains diagnosis codes for each admission.
    Links admissions with their corresponding diagnoses.
========================================================= */
COPY diagnoses
FROM 'D:/Data analysis Project Datasets & Project/Hospital-Readmission-Analytics/data/raw/diagnoses.csv'
DELIMITER ','
CSV HEADER;








/* ==========================================================
    Table: Bills

    Description:
    Stores every bill for each admission.
    Links admissions with billing details, costs, and subsidies.
==========================================================*/
COPY bills
FROM 'D:/Data analysis Project Datasets & Project/Hospital-Readmission-Analytics/data/raw/billing.csv'
DELIMITER ','
CSV HEADER;




