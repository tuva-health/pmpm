{{ config(materialized='table') }}

with src as
         (select
              patient_id,
              -- member_id,
              coverage_start_date as start_date,
              coverage_end_date as end_date,
              payer,
              payer_type
              -- dual_status_code,
              -- medicare_status_code
          from {{ var('coverage') }}
         )
, months as (
    select 1 as month
    union
    select 2 as month
    union
    select 3 as month
    union
    select 4 as month
    union
    select 5 as month
    union
    select 6 as month
    union
    select 7 as month
    union
    select 8 as month
    union
    select 9 as month
    union
    select 10 as month
    union
    select 11 as month
    union
    select 12 as month)
,years as (
    select 2013 as year
    union
    select 2014 as year
    union
    select 2015 as year
    union
    select 2016 as year
    union
    select 2017 as year
    union
    select 2018 as year
    union
    select 2019 as year
    union
    select 2020 as year
    union
    select 2021 as year
    union
    select 2022 as year
    union
    select 2023 as year)
,dates as (
    select
        year
        ,month
        ,(year::varchar||'-'||month::varchar||'-01')::date as month_start
        ,dateadd(day,-1,dateadd(month,1,(year::varchar||'-'||month::varchar||'-01')::date)) as month_end
    from years
    cross join months
)
select patient_id,
       -- member_id,
       concat(year,lpad(month,2,0)) as year_month,
       year,
       lpad(month,2,0) as month,
       start_date,
       end_date,
       payer,
       payer_type
       -- dual_status_code,
       -- medicare_status_code
from src
inner join dates
    on src.start_date <= dates.month_end 
    and  src.end_date >= dates.month_start