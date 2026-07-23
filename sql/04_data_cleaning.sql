
/* Checking Null Value in admissions table */
select *
from admissions
where admission_id is null 
or patient_id  is null
or hospital_id is null 
or admit_date is null
or discharge_date is null
or admit_type is null
or ward_type is null
or discharge_type  is null
or los_days is null
or num_procedures is null
or charlson_index is null
or hba1c is null
or creatinine is null
or haemoglobin is null
or systolic_bp is null
or readmitted_30d is null
or readmitted_7d is null
;


/* Checking Null value in bills table */
select *
from bills
where bill_id is null 
or admission_id  is null
or total_cost_inr is null 
or govt_subsidy_inr is null
or out_of_pocket_inr is null
or cost_category is null;


/* Checking Null value in dignoses table */
select *
from diagnoses
where diag_id is null
or admission_id  is null
or icd10_code is null 
or diag_desc is null
or diag_rank is null
or diag_category is null;


/* Checking Null values in hospitals table */
select * 
from hospitals
where hospital_id is null 
or name  is null
or state is null 
or tier is null
or beds is null
or teaching is null;

/* Checking Null Vaues in patients table */
select *
from patients
where patient_id is null
or age  is null
or gender is null 
or state is null
or bpl_card is null
or insurance_type is null
or comorbidity_count is null
or prev_admissions is null;




/* Checking Duplicate Values in Tables */

/* Checking Duplicates Values in admissions table */
with Row_Num_Count as
(select * ,
	  row_number() over(
	  PARTITION BY patient_id,
				   hospital_id,
	  			   admit_date,
	  			   discharge_date

				   ORDER BY admission_id,patient_id,hospital_id
				   
	  ) as row_num
from admissions
)
select * from Row_Num_Count
where row_num > 1;


/* Checking Duplicate values in bills table */
select bill_id , count(*) as duplicate_count
from bills
group by bill_id 
having count(*) > 1;





/* Checking Duplicate values in dignoses table */
select diag_id , count(*) as duplicate_count
from diagnoses
group by diag_id 
having count(*) > 1;




/* Checking Duplicate values in hospital table */
select hospital_id, count(*) as duplicate_count
from hospitals
group by hospital_id
having count(*) > 1;


/* Checking Duplicate values in patients table */
select patient_id,count(*) as duplicate_count
from patients
group by patient_id
having count(*) > 1;




/* Checking Logical Data Validations */



/* Date Validation Check in admissions Table */
select admission_id,patient_id ,hospital_id , admit_date,discharge_date
from admissions
where discharge_date < admit_date;



/* Value validation check in   admissions table*/
select * 
from admissions
where los_days < 0;


/* Age Validation check in patients table */
select * 
from patients
where age > 120 or age < 0;


/* Bed count check in hospitals table */
select * 
from hospitals
where beds <= 0;


/* Negative Currency Check in bills table */
select * 
from bills
where total_cost_inr < 0;


select * 
from bills
where   govt_subsidy_inr > total_cost_inr;


select adm.admission_id,adm.patient_id,pat.patient_id
from admissions as adm
left join patients as pat
	on adm.patient_id = pat.patient_id
where pat.patient_id is null
;



