
{{ config(materialized='table') }}

with encounter as (
select
    patient_id
,   year(encounter_end_date) as year
,   lpad(month(encounter_end_date),2,0) as month
,   concat(year(encounter_end_date),lpad(month(encounter_end_date),2,0)) AS year_month
,   encounter_type
,   paid_amount
from {{ var('encounter') }}
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