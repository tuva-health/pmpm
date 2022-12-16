{{ config(enabled = var('pmpm_enabled',var('tuva_packages_enabled',True)) ) }}

with medical as 
(
    select
        patient_id
       ,year(claim_end_date) as year
       ,lpad(month(claim_end_date),2,0) as month
       ,concat(year(claim_end_date),lpad(month(claim_end_date),2,0)) AS year_month
       ,claim_type
       ,paid_amount
    from {{ var('medical_claim') }}
)
, pharmacy as 
(
    select
        patient_id
        ,year(to_date(dispensing_date)) as year
        ,lpad(month(to_date(dispensing_date)),2,0) as month
        ,concat(year(to_date(dispensing_date)),lpad(month(to_date(dispensing_date)),2,0)) as year_month
        ,'pharmacy' as claim_type
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