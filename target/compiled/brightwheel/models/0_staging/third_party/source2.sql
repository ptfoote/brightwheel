-- model: staging/salesforce/source2

with source as (

    select * from "brightwheel"."public"."source2"

),

clean as (
    select
        type_license,
        company,
        accepts_subsidy,
        year_round,
        daytime_hours,
        star_level,
        mon,
        tues,
        wed,
        thurs,
        friday,
        saturday,
        sunday,
        primary_caregiver,
        phone,
        email,
        address1,
        address2,
        city,
        state,
        zip,
        subsidy_contract_number,
        total_cap,
        ages_accepted_1,
        aa2 as ages_accepted_2,
        aa3 as ages_accepted_3,
        aa4 as ages_accepted_4,
        license_monitoring_since,
        school_year_only,
        evening_hours

    from source

)

select * from clean