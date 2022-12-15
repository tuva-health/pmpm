{{ config(materialized='table') }}

with member_months as
(
    select distinct patient_id, year_month
    from {{ref('member_months')}}
)
, claim_spend_and_utilization as
(
    select *
    from {{ref('claim_spend_and_utilization')}}
)
, cte_spend_and_visits as
(
    select 
        patient_id
        ,year_month
        ,sum(spend) as total_spend
        ,sum(case when claim_type <> 'pharmacy' then spend else 0 end) as medical_spend
        ,sum(case when claim_type = 'pharmacy' then spend else 0 end) as pharmacy_spend

    from claim_spend_and_utilization
    group by
        patient_id
        ,year_month 
)

select 
    mm.patient_id
    ,mm.year_month
    --,plan or payer field
    ,sv.total_spend
    ,sv.medical_spend
    ,sv.pharmacy_spend
from member_months mm
left join cte_spend_and_visits sv
    on mm.patient_id = sv.patient_id
    and mm.year_month = sv.year_month