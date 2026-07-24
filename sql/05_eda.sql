/*
==========================================================
PROJECT:
India Hospital Readmission Analytics (2015–2024)

FILE:
05_exploratory_data_analysis.sql

DESCRIPTION:
Exploratory Data Analysis (EDA)

This script answers key business questions related to:

1. Executive KPIs
2. Patient Analytics
3. Hospital Performance
4. Readmission Analysis
5. Diagnosis Analysis
6. Financial Analysis
7. Clinical Analysis
8. Time Trend Analysis

==========================================================
*/

/* What is the total number of patients? */
select distinct count(*) as total_patients
from patients;



/* What is the total number of hospital admissions? */
select distinct count(*) as total_admissions
from admissions;



/* How many hospitals are included in the dataset? */
select distinct count(hospital_id) as total_hospitals
from hospitals;


/* What is the total healthcare expenditure? */
select round(sum(total_cost_inr),2) as total_expenditure
from bills 
;


/* What is the average treatment cost per admission? */
select round(avg(total_cost_inr),2) as average_cost
from bills;


/* What is the average hospital length of stay? */
select round(avg(los_days),2) as average_los
from admissions;



/* What is the overall 30-day readmission rate? */
select 
	 round(
			100.0 * sum(case when readmitted_30d = True then 1 else 0 end) / count(*) , 2
	 ) as overall_readmitt_rate
from admissions;







