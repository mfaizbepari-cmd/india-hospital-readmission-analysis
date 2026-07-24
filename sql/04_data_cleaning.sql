
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


/* Does every admission belong to an existing hospital? */
select adm.admission_id
from admissions as adm
left join hospitals as hos
	on adm.hospital_id = hos.hospital_id
where hos.hospital_id is null;


/* Does every diagnosis belong to an existing admission? */
select * 
from diagnoses as dia
left join admissions as adm
	on dia.admission_id = adm.admission_id
where adm.admission_id is null;



/* Does every bill belong to an existing admission? */
select *
from bills as bill
left join admissions as adm
	on bill.admission_id = adm.admission_id
where adm.admission_id is null;


/* Are there any invalid gender values? */
select * 
from patients
where gender not in ('M','F','Other')
or gender is null;



/* Are there any invalid insurance types? */
select *
from patients
where insurance_type not in ('Private','Ayushman','ESI','None')
or insurance_type is null;


/* Are there any invalid admission types?*/
select *
from admissions
where admit_type not in ('OPD','Elective','Emergency')
or admit_type is null;


/* Are there any invalid ward types? */
select *
from admissions
where ward_type not in ('HDU','ICU','General','NICU')
or ward_type is null;





/* Are there any invalid discharge types? */
select * 
from admissions
where discharge_type not in ('Expired','LAMA','Recovered','Referred')
or discharge_type is null ;


/* Are there any invalid hospital tiers? */
select *
from hospitals
where tier not in ('tier1','tier2','tier3')
or tier is null;


/* Is los_days consistent with the difference between discharge_date and admit_date? */
select admission_id,
	   admit_date,
	   discharge_date,
	   los_days,
	   (discharge_date - admit_date) as actual_los,
	   los_days = (discharge_date - admit_date) as is_consistent

from admissions

;


/* Is the patient's previous admission count negative? */
select *
from patients
where prev_admissions < 0;


/* Is the comorbidity count negative? */
select *
from patients
where comorbidity_count < 0;


/* Is the number of procedures negative? */
select * 
from admissions
where num_procedures < 0;


/* Is government subsidy + patient payment greater than the total bill? */
select bill_id
from bills
where govt_subsidy_inr + out_of_pocket_inr > total_cost_inr ;



/* Does government subsidy + patient payment equal the total bill? */
select *
from bills
where  not govt_subsidy_inr + out_of_pocket_inr   = total_cost_inr ;


/* Are HbA1c values outside a medically reasonable range? */
select *
from admissions
where hba1c < 3
or hba1c > 20;


/* Are creatinine values negative or impossible? */
select * 
from admissions
where creatinine < 0.2
or creatinine > 20;


/* Is haemoglobin negative? */
select *
from admissions
where haemoglobin < 0;


/* Is systolic blood pressure negative or unrealistically high? */
select *
from admissions
where systolic_bp < 50
or systolic_bp > 300;



/* Are there duplicate admissions for the same patient, hospital, and admission period? */
select patient_id ,
	   hospital_id,
	   admit_date,
	   discharge_date,
	   count(*) as patient_count
from admissions
group by patient_id ,
	   hospital_id,
	   admit_date,
	   discharge_date
having count(*) > 1;



/* Are duplicate diagnosis records recorded for the same admission? */
select 
	   admission_id,
	   icd10_code,
	   diag_desc,
	   count(*) as diag_count
from diagnoses
group by admission_id,
	   icd10_code,
	   diag_desc
having count(*) > 1
;



/* Are duplicate bills recorded for the same admission? */
select 
	   admission_id,
	   count(*) as bills_count 
from bills
group by admission_id
having count(*) > 1;





/* Which admissions have unusually long hospital stays? */
select *
from admissions
where los_days > 14;


/* Which bills have unusually high total costs? */
select *
from bills
where total_cost_inr > 50000;



/* Which hospitals have unusually high readmission rates?*/
select hospital_id,
		round(
				100.0 * sum(case when readmitted_30d = True then 1 else 0 end)
				/ count(*),2
		) as readmission_rate
from admissions
group by hospital_id
having 100.0 * sum(case when readmitted_30d = True then 1 else 0 end)
				/ count(*) > 10;



	


/* Which patients have an unusually high number of admissions? */
SELECT
    patient_id,
    COUNT(*) AS total_admissions
FROM admissions
GROUP BY patient_id
HAVING COUNT(*) > 2;

