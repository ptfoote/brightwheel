-- model: staging/salesforce/source1

with source as (

    select * from "brightwheel"."public"."source1"

),

clean as (

    select
        name,
        credential_type,
        credential_number,
        status,
        expiration_date,
        disciplinary_action,
        address,
        state,
        county,
        phone,
        first_issue_date,
        primary_contact_name,
        primary_contact_role

    from source

)

select * from clean