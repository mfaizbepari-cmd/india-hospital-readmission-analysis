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




/*

==========================================================

        SECTION 1 — Executive KPI Analysis

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




/* What is the overall 7-day readmission rate? */
select
	round(
			100.0 * sum(case when readmitted_7d = true then 1 else 0 end) / count(*) ,2
	) as overall_7d_readmitted_rate
from admissions;



/*

==========================================================

             SECTION 2 — Patient Analysis

==========================================================

*/


/* Which age group has the highest number of admissions? */
select 
	 (  case 
	        when p.age between 0 and 17 then '0 - 17'
	        when p.age between 18 and 35 then '18 - 35' 
	        when p.age between 36 and 50 then '36 - 50'
	        when p.age between 51 and 65 then '51 - 65'
	        when p.age > 65 then '65+'
       end
	  ) as age_group,

	 count(a.admission_id) as total_admissions
from admissions as a
join patients as p
	on a.patient_id = p.patient_id

Group by
 case 
	 when p.age between 0 and 17 then '0 - 17'
	 when p.age between 18 and 35 then '18 - 35' 
	 when p.age between 36 and 50 then '36 - 50'
	 when p.age between 51 and 65 then '51 - 65'
	 when p.age > 65 then '65+'
end
order by total_admissions desc
limit 1
;
			 

/* Which age group has the highest readmission rate? */

select 
     case 
	     when p.age between 0 and 17 then '0 - 17'
	     when p.age between 18 and 35 then '18 - 35' 
	     when p.age between 36 and 50 then '36 - 50'
	     when p.age between 51 and 65 then '51 - 65'
	     when p.age > 65 then '65+'
    end as age_group,
   Round(
			100.0 * sum(case when a.readmitted_30d = True then 1 else 0 end) / count(*),2
   ) as readmitted_rate	

from patients as p
join admissions as a
	on p.patient_id = a.patient_id
group by
		     case 
	     when p.age between 0 and 17 then '0 - 17'
	     when p.age between 18 and 35 then '18 - 35' 
	     when p.age between 36 and 50 then '36 - 50'
	     when p.age between 51 and 65 then '51 - 65'
	     when p.age > 65 then '65+'
    end

order by readmitted_rate desc
limit 1;



/* Does gender influence readmission rates? */
select 
		gender,
	    round(
			   100.0 * sum(case when readmitted_30d = true then 1 else 0 end ) / count(*)  ,2
		      ) as readmitted_rate
from admissions as a
join patients as p
	on a.patient_id = p.patient_id
group by gender
order by readmitted_rate desc;



/* Which insurance type has the most admissions? */
select p.insurance_type,
	count(a.admission_id) as total_admissions
from admissions as a
join patients as p
	on a.patient_id = p.patient_id
group by p.insurance_type
order by total_admissions desc
limit 1;


/* Which insurance type has the highest average treatment cost? */
select p.insurance_type,
		round(avg(b.total_cost_inr),2) as average_cost
FROM patients p
JOIN admissions a
    ON p.patient_id = a.patient_id
JOIN bills b
    ON a.admission_id = b.admission_id
group by p.insurance_type
order by average_cost desc
limit 1;


/* Which insurance type has the highest readmission rate? */
select p.insurance_type,
		round(
			   100.0 * sum(case when a.readmitted_30d = true then 1 else 0 end) / count(*) ,2
		      ) as readmitted_rate

from patients as p
join admissions a
	on p.patient_id = a.patient_id
group by p.insurance_type
order by readmitted_rate desc
limit 1;



/* Which states contribute the most patients? */
select state,
		count(patient_id) as total_patients,
	    round(
			100.0 * count(patient_id) / (select count(patient_id) from patients) ,2
		) as contribution_percentage
from patients
group by state
order by contribution_percentage desc
limit 5;


/* Which patients have the highest number of admissions? */
select patient_id ,
		count(admission_id) as total_admissions
from admissions
group by patient_id 
order by total_admissions desc;



/*

==========================================================

            SECTION 3 — Hospital Analysis

==========================================================

*/




/* Which hospitals treat the highest number of patients? */
select h.hospital_id ,
		h.name,
		COUNT(DISTINCT a.patient_id) as total_patients
from hospitals as h
join admissions a
	on h.hospital_id = a.hospital_id
group by h.hospital_id ,h.name
order by total_patients desc
limit 10;


/* Which hospitals have the highest readmission rate? */
select h.hospital_id,
		h.name,
		round(
              100.0 * sum(case when a.readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) as readmission_rate
from hospitals h
join admissions a
	on a.hospital_id = h.hospital_id
group by h.hospital_id,h.name
order by readmission_rate desc 
limit 10;


/* Which hospitals generate the highest revenue? */
select h.hospital_id ,
		h.name,
		round(sum(b.total_cost_inr),2) as total_revenue
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
join bills b
	on a.admission_id = b.admission_id
group by h.hospital_id, h.name
order by total_revenue desc
limit 1;


/* Which hospital tiers have the highest readmission rate? */
select h.tier,
		round(
				100.0 * sum(case when a.readmitted_30d = true then 1 else 0 end) / count(*) , 2
		) as readmittion_rate

from hospitals h
join admissions a
	on a.hospital_id = h.hospital_id
group by h.tier
order by readmittion_rate desc;


/* Which states have the highest number of hospital admissions? */
select state,
		count(admission_id) as total_admissions
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
group by state
order by total_admissions desc
limit 10;


/* Which hospitals have the longest average patient stay? */
select h.hospital_id,
		h.name,
		round(avg(los_days),2) average_los
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
group by h.hospital_id,h.name
order by average_los desc
limit 10;


/* Which teaching hospitals have better readmission performance? */
select h.teaching,
		round(  100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*),2) as readmission_rate
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
group by h.teaching
order by readmission_rate asc
;



/* 

==========================================================

         SECTION 4 — Diagnosis Analysis

==========================================================

*/





/* Which diagnoses are most common? */
select d.diag_desc,
		count(admission_id) as total_admissions		
from diagnoses d
group by diag_desc
order by total_admissions desc
limit 10;


/* Which diagnosis categories occur most frequently? */
select diag_category,
		count(admission_id) total_admission
from diagnoses
group by diag_category
order by total_admission desc
limit 10 ;


/*Which diagnoses have the highest readmission rate? */
select d.diag_desc,
		round(
				100.0 * sum(case when a.readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) as readmission_rate
from diagnoses d
join admissions a
	on a.admission_id = d.admission_id
group by diag_desc
order by readmission_rate desc
limit 10;



/* Which diagnosis categories generate the highest healthcare cost? */
select d.diag_category,
		round(sum(b.total_cost_inr),2) total_cost
from diagnoses d
join bills b
	on b.admission_id = d.admission_id
group by diag_category 
order by total_cost desc
limit 10;


/* Which diagnoses require the longest hospital stay? */
select diag_desc,
		round(avg(los_days),2) as average_los
from diagnoses d
join admissions a
	on d.admission_id = a.admission_id
group by diag_desc
order by average_los desc
limit 1;



/* 

==========================================================

         SECTION 5 — Financial Analysis

==========================================================
*/


/* Which hospitals generate the highest treatment revenue? */
select h.hospital_id,
		h.name,
		round(sum(b.total_cost_inr),2) as total_revenue
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
join bills b
	on b.admission_id = a.admission_id
group by h.hospital_id , h.name
order by total_revenue desc
limit 10;




/* What is the average treatment cost by hospital tier? */
select h.tier,
		round(avg(b.total_cost_inr),2) as average_cost
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
join bills b
	on a.admission_id = b.admission_id
group by tier
order by average_cost desc;


/* Which cost categories account for the highest expenditure? */
select cost_category,
		round(sum(total_cost_inr),2) as total_expenditure
from bills 
group by cost_category
order by total_expenditure desc;


/* Which insurance type receives the highest government subsidy? */
select insurance_type ,
		round(sum(govt_subsidy_inr),2) as total_subsidy
from patients p
join admissions a
	on a.patient_id = p.patient_id
join bills b
	on b.admission_id = a.admission_id
group by insurance_type
order by total_subsidy desc
limit 1;

/* Which states receive the highest total healthcare subsidy? */
select h.state,
		round(sum(b.govt_subsidy_inr)) as total_subsidy
from hospitals h
join admissions a
	on h.hospital_id = a.hospital_id
join bills b
	on a.admission_id = b.admission_id
group by h.state
order by total_subsidy desc 
limit 10;



/* Which admissions have the highest treatment cost? */
select admit_type,
		round(sum(b.total_cost_inr),2) as total_cost
from admissions a
join bills b
	on a.admission_id = b.admission_id
group by a.admit_type
order by total_cost desc;



/* 
==========================================================

         SECTION 6 — Readmission Analysis

==========================================================
*/



		
/* Does Charlson Index influence readmission? */
select charlson_index,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) as readmission_rate
from admissions
group by charlson_index
order by charlson_index desc;


/* Does the number of procedures affect readmission? */
select num_procedures,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*),2
		) as readmission_rate
from admissions
group by num_procedures
order by num_procedures desc
limit 10;


/* Does longer hospital stay reduce or increase readmission? */
select los_days,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) as readmission_rate
from admissions
group by los_days
order by los_days;


/* Which ward types have the highest readmission rate? */
select ward_type,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) readmission_rate
from admissions
group by ward_type
order by readmission_rate desc;


/* Which admission types have the highest readmission rate? */
select admit_type,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end) / count(*) ,2
		) readmission_rate
from admissions
group by  admit_type
order by readmission_rate desc;


/* Which discharge types are associated with higher readmission? */
select  discharge_type,
		round(
				100.0 * sum(case when readmitted_30d = true then 1 else 0 end ) / count(*),2
		) readmission_rate
from admissions
group by discharge_type 
order by readmission_rate desc;







		