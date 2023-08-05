-- Show all of the patients grouped into weight groups.Show the total amount of patients in each weight group.Order the list by the weight group decending.For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
select count(*) as c,
    (floor(weight/10)*10) as weight_group
from patients
group by weight_group
order by weight_group desc;

-- Show patient_id, weight, height, isObese from the patients table.Display isObese as a boolean 0 or 1.Obese is defined as weight(kg)/(height(m)2) >= 30.weight is in units kg.height is in units cm.
select patient_id,weight,height,
(case
  	when floor(weight/power(height/100.0,2))>=30 then 1
    else 0
    end
	)as isObese
  from patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty.Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'Check patients, admissions, and doctors tables for required information.
select p.patient_id,
p.first_name,
p.last_name,
d.specialty
from patients p 
join admissions a 
on p.patient_id = a.patient_id
join doctors d 
on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa';

-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.The password must be the following, in order:1. patient_id 2. the numerical length of patient's last_name 3. year of patient's birth_date
select
  p.patient_id,
  (
    concat(
      p.patient_id,
      len(last_name),
      year(birth_date)
    )
  ) as temp_pwd
from patients p
  join admissions a on p.patient_id = a.patient_id
group by p.patient_id;

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
select 
(
case when patient_id%2==0 then 'Yes' else 'No' end
) as has_insurance,
sum(
case when patient_id%2==0 then 10 else 50 end  
) as cost
from admissions
group by has_insurance;

-- Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
select province_name
from (
    select
      province_name,
      sum(gender = 'M') as m_count,
      sum(gender = 'F') as f_count
    from patients pa
      join province_names pr on pa.province_id = pr.province_id
    group by province_name
  )
where m_count > f_count;

-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:- First_name contains an 'r' after the first two letters.- Identifies their gender as 'F'- Born in February, May, or December- Their weight would be between 60kg and 80kg- Their patient_id is an odd number- They are from the city 'Kingston'
select * 
from patients
where
(first_name like '__r%')
and
(gender = 'F')
and
(month(birth_date) in (2,5,12))
and
(weight between 60 and 80)
and
(patient_id%2==1)
and
(city='Kingston');

-- Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
select
  Concat(Round(avg(gender = 'M') * 100, 2), '%') as av
from patients;

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
select admission_date,
count(admission_date) as admission_day,
count(admission_date)
- 
lag(count(admission_date)) over(order by admission_date)
from admissions
group by admission_date;

-- Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select province_name
from province_names
order by province_name='Ontario' desc,province_name;

-- We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
select 
d.doctor_id,
concat(first_name,' ',last_name) as full_name,specialty,
year(a.admission_date) as selected_year,
count(*) as total_admissions
from doctors d 
left join admissions a 
on d.doctor_id = a.attending_doctor_id
group by full_name,selected_year
;



























