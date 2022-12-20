{{ config(enabled = var('pmpm_enabled',var('tuva_packages_enabled',True)) ) }}

with member_months as
(
    select distinct patient_id, year_month
    from {{ref('pmpm__member_months')}}
)
, claim_spend_and_utilization as
(
    select *
    from {{ref('pmpm__claim_spend_and_utilization')}}
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
    ,coalesce(sv.total_spend,0) as total_spend
    ,coalesce(sv.medical_spend,0) as medical_spend
    ,coalesce(sv.pharmacy_spend,0) as pharmacy_spend
from member_months mm
left join cte_spend_and_visits sv
    on mm.patient_id = sv.patient_id
    and mm.year_month = sv.year_month