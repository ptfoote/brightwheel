
  create view "brightwheel"."brightwheel_exam"."salesforce_leads__dbt_tmp"
    
    
  as (
    -- model: staging/salesforce/salesforce_leads

with source as (

    select * from "brightwheel"."public"."salesforce_leads"

),

clean as (
    select
        id,
        is_deleted,
        last_name,
        first_name,
        title,
        company,
        street,
        city,
        state,
        postal_code,
        country,
        phone,
        mobile_phone,
        email,
        website,
        lead_source,
        status,
        is_converted,
        created_date,
        last_modified_date,
        last_activity_date,
        last_viewed_date,
        last_referenced_date,
        email_bounced_reason,
        email_bounced_date,
        outreach_stage_c as outreach_stage,
        current_enrollment_c as current_enrollment,
        capacity_c as capacity,
        lead_source_last_updated_c as lead_source_last_updated,
        brightwheel_school_uuid_c as brightwheel_school_uuid

    from source

)

select * from clean
  );