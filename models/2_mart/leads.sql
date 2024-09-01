with salesforce_leads as (

    select * from {{ ref('salesforce_leads') }} 

),

source1 as (

    select * from {{ ref('source1') }}

),

source2 as (

    select * from {{ ref('source2') }}

),

source3 as (

    select * from {{ ref('source3') }}

),

combined as (
    select
        'salesforce' as lead_source,
        null as accepts_financial_aid,
        null as max_age,
        null as min_age,
        capacity,
        null as certificate_expiration_date,
        city,
        street as address1,
        null as address2,
        company,
        phone,
        mobile_phone as phone2,
        null as county,
        email,
        first_name,
        last_name,
        null as license_status,
        null as license_issued,
        null as license_number,
        null as license_type,
        null as licensee_name,
        brightwheel_school_uuid as provider_id,
        null as schedule,
        state,
        title,
        website as website_address,
        postal_code as zip,
        null as facility_type
        
    from salesforce_leads

    union all

    select
        'source1' as lead_source,
        null as accepts_financial_aid,
        null as max_age,
        null as min_age,
        null as capacity,
        expiration_date as certificate_expiration_date,
        null as city,
        address as address1,
        null as address2,
        name as company,
        phone,
        null as phone2,
        county,
        null as email,
        split_part(primary_contact_name, ' ', 1) as first_name,
        split_part(primary_contact_name, ' ', 2) as last_name,
        status as license_status,
        first_issue_date as license_issued,
        credential_number as license_number,
        credential_type as license_type,
        primary_contact_name as licensee_name,
        null as provider_id,
        null as schedule,
        state,
        null as title,
        null as website_address,
        null as zip,
        null as facility_type

    from source1

    union all

    select
        'source2' as lead_source,
        accepts_subsidy as accepts_financial_aid,
        case
            when ages_accepted_4 = 'School-age (5 years-older)' or
                ages_accepted_3 = 'School-age (5 years-older)' or
                ages_accepted_2 = 'School-age (5 years-older)' or
                ages_accepted_1 = 'School-age (5 years-older)'
            then 'School'
            when ages_accepted_4 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_3 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_2 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_1 = 'Preschool (24-48 months; 2-4 yrs.)'
            then 'Preschool'
            when ages_accepted_4 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_3 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_2 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_1 = 'Toddlers (12-23 months; 1yr.)'
            then 'Toddler'
            when ages_accepted_1 = 'Infants (0-11 months)' or
                ages_accepted_2 = 'Infants (0-11 months)' 
                then 'Infant'
        end as max_age,
        case
            when ages_accepted_1 = 'Infants (0-11 months)' or
                ages_accepted_2 = 'Infants (0-11 months)' 
                then 'Infant'
            when ages_accepted_4 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_3 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_2 = 'Toddlers (12-23 months; 1yr.)' or
                ages_accepted_1 = 'Toddlers (12-23 months; 1yr.)'
            then 'Toddler'
            when ages_accepted_4 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_3 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_2 = 'Preschool (24-48 months; 2-4 yrs.)' or
                ages_accepted_1 = 'Preschool (24-48 months; 2-4 yrs.)'
            then 'Preschool'
            when ages_accepted_4 = 'School-age (5 years-older)' or
                ages_accepted_3 = 'School-age (5 years-older)' or
                ages_accepted_2 = 'School-age (5 years-older)' or
                ages_accepted_1 = 'School-age (5 years-older)'
            then 'School'
        end as min_age,
        null as capacity,
        null as certificate_expiration_date,
        city,
        address1,
        address2,
        company,
        phone,
        null as phone2,
        null as county,
        email,
        split_part(primary_caregiver, ' ', 1) as first_name,
        split_part(primary_caregiver, ' ', 2) as last_name,
        null as license_status,
        null as license_issued,
        null as license_number,
        type_license as license_type,
        primary_caregiver as licensee_name,
        null as provider_id,
        year_round as schedule,
        state,
        null as title,
        null as website_address,
        zip,
        null as facility_type

    from source2

    union all

    select
        'source3' as lead_source,
        null as accepts_financial_aid,
        case
            when school = 'Y' then 'School'
            when preschool = 'Y' then 'Preschool'
            when toddler = 'Y' then 'Toddler'
            when infant = 'Y' then 'Infant'
        else null end as max_age,
        case
            when infant = 'Y' then 'Infant'
            when toddler = 'Y' then 'Toddler'
            when preschool = 'Y' then 'Preschool'
            when school = 'Y' then 'School'
        end as min_age,
        capacity,
        null as certificate_expiration_date,
        city,
        address as address1,
        null as address2,
        operation_name as company,
        phone,
        null as phone2,
        county,
        email_address as email,
        null as first_name,
        null as last_name,
        status as license_status,
        issue_date as license_issued,
        facility_id as license_number,
        type as license_type,
        null as licensee_name,
        facility_id as provider_id,
        null as schedule,
        state,
        null as title,
        null as website_address,
        zip,
        type as facility_type

    from source3

),

final as (
    select
        lead_source,
        accepts_financial_aid,
        concat(concat(min_age, '-'), max_age) as ages_served,
        capacity,
        certificate_expiration_date,
        city,
        address1,
        address2,
        company,
        phone,
        phone2,
        county,
        email,
        first_name,
        last_name,
        license_status,
        license_issued,
        license_number,
        license_type,
        licensee_name,
        max_age,
        min_age,
        provider_id,
        schedule,
        state,
        title,
        website_address,
        zip,
        facility_type

    from combined

)

select * from final