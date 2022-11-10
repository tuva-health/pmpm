{{ config(materialized='view') }}

select
    a.patient_id
,   a.year_month
,   a.year
,   a.month
,   b.acute_inpatient
,   b.ambulatory_surgical_center
,   b.dialysis_center
,   b.emergency_department
,   b.home_health
,   b.hospice
,   b.inpatient_psychiatric
,   b.inpatient_rehabilitation
,   b.mental_health_center
,   b.office_visit
,   b.other
,   b.outpatient_rehabilitation
,   b.outpatient
,   b.professional_only_acute_inpatient
,   b.skilled_nursing_facility
,   b.substance_abuse_treatment_facility
,   b.telehealth
,   b.unmapped
,   b.urgent_care
,   b.total_encounter_counts
from {{ ref('member_months') }} a
left join {{ ref('encounter_utilization') }} b
    on a.patient_id = b.patient_id
    and a.year_month = b.year_month