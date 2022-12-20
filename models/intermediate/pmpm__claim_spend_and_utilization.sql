{{ config(enabled = var('pmpm_enabled',var('tuva_packages_enabled',True)) ) }}

with medical as 
(
    select
        patient_id
       ,date_part(year, claim_end_date) as year
       ,lpad(date_part(month, claim_end_date),2,0) as month
       ,date_part(year, claim_end_date) || lpad(date_part(month, claim_end_date),2,0) AS year_month
       ,claim_type
       ,paid_amount
    from {{ var('medical_claim') }}
)
, pharmacy as 
(
    select
        patient_id
        ,date_part(year, dispensing_date) as year
        ,lpad(date_part(month, dispensing_date),2,0) as month
        ,date_part(year, dispensing_date) || lpad(date_part(month, dispensing_date),2,0) AS year_month
        ,cast('pharmacy' as varchar) as claim_type
        ,paid_amount
    from {{ var('pharmacy_claim') }}
)

select 
    patient_id
    ,claim_type
    ,year_month
    ,count(*) as count_claims
    ,sum(paid_amount) as spend
from medical
group by 
    patient_id
    ,claim_type
    ,year_month

union all

select 
    patient_id
    ,claim_type
    ,year_month
    ,count(*) as count_claims
    ,sum(paid_amount) as spend
from pharmacy
group by 
    patient_id
    ,claim_type
    ,year_month