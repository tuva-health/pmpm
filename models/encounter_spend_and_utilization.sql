
{{ config(materialized='table') }}

with encounter as 
(
    select
        patient_id
       ,year(encounter_end_date) as year
       ,lpad(month(encounter_end_date),2,0) as month
       ,concat(year(encounter_end_date),lpad(month(encounter_end_date),2,0)) AS year_month
       ,encounter_type
       ,paid_amount
    from {{var('encounter')}}
)
, pharmacy as 
(
    select
        patient_id
        ,year(to_date(dispensing_date, 'YYYY-MM-DD')) as year
        ,lpad(month(to_date(dispensing_date, 'YYYY-MM-DD')),2,0) as month
        ,concat(year(to_date(dispensing_date, 'YYYY-MM-DD')),lpad(month(to_date(dispensing_date, 'YYYY-MM-DD')),2,0)) AS year_month
        ,'pharmacy' as encounter_type
        ,paid_amount
    from {{var('pharmacy_claim')}}
)

select 
    patient_id
    ,encounter_type
    ,year_month
    ,count(*) as count_encounters
    ,sum(paid_amount) as paid_amount
from encounter
group by 
    patient_id
    ,encounter_type
    ,year_month

union all

select 
    patient_id
    ,encounter_type
    ,year_month
    ,count(*) as count_encounters
    ,sum(paid_amount) as paid_amount
from pharmacy
group by 
    patient_id
    ,encounter_type
    ,year_month