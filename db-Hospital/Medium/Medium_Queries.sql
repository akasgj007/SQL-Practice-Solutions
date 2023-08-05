-- Show unique birth years from patients and order them by ascending
select
  distinct(Year(birth_date)) as birth_year
from patients
order by birth_year;

-- Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
select first_name
from patients
group by first_name
having count(first_name) = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id,first_name
from patients
where first_name like 's%s' and len(first_name)>=6;

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.Primary diagnosis is stored in the admissions table
select
  p.patient_id,
  first_name,
  last_name
from patients p
  join admissions a on p.patient_id = a.patient_id
where diagnosis = 'Dementia';

-- Display every patient's first_name.Order the list by the length of each name and then by alphbetically
select first_name
from patients
order by
  len(first_name),
  first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table.Display the two results in the same row.
select 
	sum(gender='M') as m_c,
    sum(gender='F') as f_c
from patients;

-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select first_name,last_name,allergies
from patients
where allergies in ('Penicillin','Morphine')
order by allergies,first_name,last_name;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id,diagnosis
from admissions
group by patient_id,diagnosis
having count(*)>1;

-- Show the city and the total number of patients in the city.Order from most to least patients and then by city name ascending.
select city,count(*) as c 
from patients
group by city
order by c desc,city;

-- Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
select
  first_name,
  last_name,
  'Patient' as role
from patients
union all
select
  first_name,
  last_name,
  'Doctor' as role
from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query.
select
  allergies,
  count(allergies) as c
from patients
where allergies is not null
group by allergies
order by c desc;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select
  first_name,
  last_name,
  birth_date
from patients
where
  year(birth_date) between 1970 and 1979
order by birth_date;

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending orderEX: SMITH,jane
select concat(upper(last_name),',',lower(first_name))
from patients
order by first_name desc;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id,sum(height) as sum_height
from patients
group by province_id
having sum_height>=7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select (max(weight) - min(weight)) as diff
from patients
where last_name = 'Maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date),count(admission_date) as c 
from admissions
group by day(admission_date)
order by c desc;

-- Show all columns for patient_id 542's most recent admission_date.
select * 
from admissions
where patient_id = 542
order by admission_date desc
limit 1;

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
select patient_id,attending_doctor_id,diagnosis
from admissions
where (patient_id%2==1 and attending_doctor_id in (1,5,19))
		or 
      (cast(attending_doctor_id as varchar) like '%2%'
      	and
       len(cast(patient_id as varchar)) = 3);

-- Show first_name, last_name, and the total number of admissions attended for each doctor.Every admission has been attended by a doctor
select first_name,last_name,count(*)
from admissions a 
join doctors d 
on a.attending_doctor_id = d.doctor_id
group by attending_doctor_id;

-- For each doctor, display their id, full name, and the first and last admission date they attended.
select doctor_id,
	concat(first_name,' ',last_name) as full_name,
    min(admission_date) as first_admission_date,
    max(admission_date) as last_admission_date
from admissions a
join doctors d
on a.attending_doctor_id = d.doctor_id
group by doctor_id;

-- Display the total amount of patients for each province. Order by descending.
select pr.province_name, count(*) as c
from patients pa 
join province_names pr 
on pa.province_id = pr.province_id
group by pr.province_id
order by c desc;

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
select 
	concat(p.first_name,' ',p.last_name) as p_full_name,
    a.diagnosis,
    concat(d.first_name,' ',d.last_name) as d_full_name
from patients p 
join admissions a 
on p.patient_id = a.patient_id
join doctors d 
on d.doctor_id = a.attending_doctor_id;

-- display the number of duplicate patients based on their first_name and last_name.
select first_name,last_name, count(*) as c
from patients
group by first_name,last_name
having c>1;

-- Display patient's full name,height in the units feet rounded to 1 decimal,weight in the unit pounds rounded to 0 decimals,birth_date,gender non abbreviated.Convert CM to feet by dividing by 30.48.Convert KG to pounds by multiplying by 2.205.
select
  concat(first_name, ' ', last_name) as full_name,
  round((height / 30.48), 1) as h,
  (round((weight * 2.205), 0)) as w,
  birth_date,
  (
    case
      when gender = 'M' then 'Male'
      else 'Female'
    end
  ) as g
from patients;

-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
select
  patient_id,
  first_name,
  last_name
from patients
where patient_id not in (
    select p.patient_id
    from patients p
      join admissions a on p.patient_id = a.patient_id
  );



































