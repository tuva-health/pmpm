{{ config(materialized='table') }}

with member_months as
(
    select distinct patient_id, year_month
    from {{ref('member_months')}}
)
, encounter_spend_and_utilization as
(
    select *
    from {{ref('encounter_spend_and_utilization')}}
)
, cte_spend_and_visits as
(
    select 
        patient_id
        ,year_month
        ,sum(paid_amount) as total_paid_amount
        ,sum(case when encounter_type <> 'pharmacy' then paid_amount else 0 end) as medical_paid_amount
        ,sum(case when encounter_type = 'pharmacy' then paid_amount else 0 end) as pharmacy_paid_amount
        ,sum(case when encounter_type = 'acute inpatient' then paid_amount else 0 end) as acute_inpatient_paid_amount
        ,sum(case when encounter_type = 'emergency department' then paid_amount else 0 end) as emergency_department_paid_amount
        ,sum(case when encounter_type = 'acute inpatient' then count_encounters else 0 end) as acute_inpatient_visits
        ,sum(case when encounter_type <> 'emergency department' then count_encounters else 0 end) as emergency_department_visits
    from encounter_spend_and_utilization
    group by
        patient_id
        ,year_month 
)

select 
    mm.patient_id
    ,mm.year_month
    --,plan or payer field
    ,sv.total_paid_amount
    ,sv.medical_paid_amount
    ,sv.pharmacy_paid_amount
    ,sv.acute_inpatient_paid_amount
    ,sv.emergency_department_paid_amount
    ,sv.acute_inpatient_visits
    ,sv.emergency_department_visits
from member_months mm
left join cte_spend_and_visits sv
    on mm.patient_id = sv.patient_id
    and mm.year_month = sv.year_month