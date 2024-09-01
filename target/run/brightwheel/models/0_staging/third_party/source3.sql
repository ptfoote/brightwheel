
  create view "brightwheel"."brightwheel_exam"."source3__dbt_tmp"
    
    
  as (
    -- model: staging/salesforce/source3

with source as (

    select * from "brightwheel"."public"."source3"

),

clean as (
    select
        operation,
        agency_number,
        operation_name,
        address,
        city,
        state,
        zip,
        county,
        phone,
        type,
        status,
        issue_date,
        capacity,
        email_address,
        facility_id,
        monitoring_frequency,
        infant,
        toddler,
        preschool,
        school

    from source

)

select * from clean
  );