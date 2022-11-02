
{{ config(materialized='table') }}

with encounters as (
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
    patient_id,
    year_month,
    year,
    month,
    coalesce(acute_inpatient,0) as acute_inpatient,
    coalesce(ambulatory_surgical_center,0) as ambulatory_surgical_center,
    coalesce(dialysis_center,0) as dialysis_center,
    coalesce(emergency_department,0) as emergency_department,
    coalesce(home_health,0) as home_health,
    coalesce(hospice,0) as hospice,
    coalesce(inpatient_psychiatric,0) as inpatient_psychiatric,
    coalesce(inpatient_rehabilitation,0) as inpatient_rehabilitation,
    coalesce(mental_health_center,0) as mental_health_center,
    coalesce(office_visit,0) as office_visit,
    coalesce(other,0) as other,
    coalesce(outpatient_rehabilitation,0) as outpatient_rehabilitation,
    coalesce(outpatient,0) as outpatient,
    coalesce(professional_only_acute_inpatient,0) as professional_only_acute_inpatient,
    coalesce(skilled_nursing_facility,0) as skilled_nursing_facility,
    coalesce(substance_abuse_treatment_facility,0) as substance_abuse_treatment_facility,
    coalesce(telehealth,0) as telehealth,
    coalesce(unmapped,0) as unmapped,
    coalesce(urgent_care,0) as urgent_care
from encounters
pivot (
    sum(paid_amount)
    for encounter_type in ('acute inpatient',
                            'ambulatory surgical center',
                            'dialysis center',
                            'emergency department',
                            'home health',
                            'hospice',
                            'inpatient psychiatric',
                            'inpatient rehabilitation',
                            'mental health center',
                            'office visit',
                            'other',
                            'outpatient rehabilitation',
                            'outpatient',
                            'professional only acute inpatient',
                            'skilled nursing facility',
                            'substance abuse treatment facility',
                            'telehealth',
                            'unmapped',
                            'urgent care')
    ) as pvt
    (
        patient_id,
        year_month,
        year,
        month,
        acute_inpatient,
        ambulatory_surgical_center,
        dialysis_center,
        emergency_department,
        home_health,
        hospice,
        inpatient_psychiatric,
        inpatient_rehabilitation,
        mental_health_center,
        office_visit,
        other,
        outpatient_rehabilitation,
        outpatient,
        professional_only_acute_inpatient,
        skilled_nursing_facility,
        substance_abuse_treatment_facility,
        telehealth,
        unmapped,
        urgent_care
    )