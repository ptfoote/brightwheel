This is my submission for the Brightwheel technical exam. The below README will educate you on how to ingest the provided files and initalize a DBT project from scratch.

### Using the starter project
Note: This was done on a new Mac leveraging Apple Silicon and the below set up instructions may differ depending on your machine.


## Prerequisites
1. Install [Rosetta](https://support.apple.com/en-us/102527) to enable applications to run that were built for Intel processors. This will run in the background.

2. Install [Python 3.8](https://www.python.org/downloads/macos/), specifically I chose the 3.8 release.

3. Install [Brew](https://brew.sh) so that we can later install postgres. Run the following commands to update your .zsh profile with the approporiate system links.
``` bash
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/paulfoote/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```

4. I chose Postgres for my database as I am quite comfortable with it. You can chose your own but it will impact the dbt adapter option you need to install later and file syntax.

``` bash
brew install postgresql@16
```

## Installation
### Postgres
1. Create a Postgres database named brightwheel
``` bash
createdb brightwheel
```

Note: I chose to load data leveraging copy statements into postgresql to preserve time for data modeling. This will be futher discussed in long term considerations.
2. Download each google spreadsheet tab as it's own file to your `Downloads` folder.

3. Create the postgres table stucture to store each table

``` sql
CREATE TABLE salesforce_leads (
    id BIGINT PRIMARY KEY,  -- Automatically increments and serves as the unique identifier for each lead
    is_deleted VARCHAR(255),     -- Indicates if the lead has been deleted (true or false)
    last_name VARCHAR(255), -- Last name of the lead
    first_name VARCHAR(255), -- First name of the lead
    title VARCHAR(255),     -- Job title of the lead`
    company VARCHAR(255),   -- Company name of the lead
    street VARCHAR(255),    -- Street address of the lead
    city VARCHAR(255),      -- City of the lead
    state VARCHAR(255),     -- State or region of the lead
    postal_code VARCHAR(20), -- Postal or ZIP code of the lead
    country VARCHAR(255),   -- Country of the lead
    phone VARCHAR(20),      -- Phone number of the lead
    mobile_phone VARCHAR(20), -- Mobile phone number of the lead
    email VARCHAR(255),     -- Email address of the lead
    website VARCHAR(255),   -- Website URL associated with the lead
    lead_source VARCHAR(255), -- Source from which the lead originated
    status VARCHAR(255),    -- Current status of the lead
    is_converted VARCHAR(255),   -- Indicates if the lead has been converted (true or false)
    created_date VARCHAR(255), -- Date and time when the lead was created
    last_modified_date VARCHAR(255), -- Date and time when the lead was last modified
    last_activity_date VARCHAR(255), -- Date and time of the last activity on the lead
    last_viewed_date VARCHAR(255), -- Date and time when the lead was last viewed
    last_referenced_date VARCHAR(255), -- Date and time when the lead was last referenced
    email_bounced_reason VARCHAR(255), -- Reason for email bounce
    email_bounced_date VARCHAR(255), -- Date and time when the email bounced
    outreach_stage_c VARCHAR(255), -- Custom field for outreach stage
    current_enrollment_c VARCHAR(255), -- Custom field for current enrollment status
    capacity_c VARCHAR(255), -- Custom field for capacity
    lead_source_last_updated_c VARCHAR(255), -- Custom field for last updated date of lead source
    brightwheel_school_uuid_c VARCHAR(255) -- Custom field for Brightwheel school UUID
);
```

``` sql
CREATE TABLE source1 (
    name VARCHAR(255) NOT NULL,               -- Name field, required, with a maximum length of 255 characters
    credential_type VARCHAR(255) NOT NULL,    -- Credential Type field, required, with a maximum length of 255 characters
    credential_number VARCHAR(255) UNIQUE,    -- Credential Number field, unique, with a maximum length of 255 characters
    status VARCHAR(255),                      -- Status field, optional, with a maximum length of 255 characters
    expiration_date VARCHAR(255),                     -- Expiration Date field, with a date type
    disciplinary_action VARCHAR(255),                 -- Disciplinary Action field, optional, with a text type for potentially long descriptions
    address VARCHAR(255),                     -- Address field, with a maximum length of 255 characters
    state VARCHAR(255),                       -- State field, with a maximum length of 255 characters
    county VARCHAR(255),                      -- County field, with a maximum length of 255 characters
    phone VARCHAR(20),                        -- Phone field, with a maximum length of 20 characters
    first_issue_date VARCHAR(255),                    -- First Issue Date field, with a date type
    primary_contact_name VARCHAR(255),        -- Primary Contact Name field, with a maximum length of 255 characters
    primary_contact_role VARCHAR(255)         -- Primary Contact Role field, with a maximum length of 255 characters
);
```

```sql
CREATE TABLE source2 (
    type_license VARCHAR(255),                  -- Type License field, with a maximum length of 255 characters
    company VARCHAR(255),                       -- Company field, with a maximum length of 255 characters
    accepts_subsidy VARCHAR(255),                    -- Accepts Subsidy field, true or false
    year_round VARCHAR(255),                         -- Year Round field, true or false
    daytime_hours VARCHAR(255),                 -- Daytime Hours field, with a maximum length of 255 characters
    star_level VARCHAR(255),                    -- Star Level field, with a maximum length of 255 characters
    mon VARCHAR(255),                           -- Monday's hours, with a maximum length of 255 characters
    tues VARCHAR(255),                          -- Tuesday's hours, with a maximum length of 255 characters
    wed VARCHAR(255),                           -- Wednesday's hours, with a maximum length of 255 characters
    thurs VARCHAR(255),                         -- Thursday's hours, with a maximum length of 255 characters
    friday VARCHAR(255),                        -- Friday's hours, with a maximum length of 255 characters
    saturday VARCHAR(255),                      -- Saturday's hours, with a maximum length of 255 characters
    sunday VARCHAR(255),                        -- Sunday's hours, with a maximum length of 255 characters
    primary_caregiver VARCHAR(255),             -- Primary Caregiver field, with a maximum length of 255 characters
    phone VARCHAR(20),                          -- Phone field, with a maximum length of 20 characters
    email VARCHAR(255),                         -- Email field, with a maximum length of 255 characters
    address1 VARCHAR(255),                      -- Address Line 1 field, with a maximum length of 255 characters
    address2 VARCHAR(255),                      -- Address Line 2 field, with a maximum length of 255 characters
    city VARCHAR(255),                          -- City field, with a maximum length of 255 characters
    state VARCHAR(255),                         -- State field, with a maximum length of 255 characters
    zip VARCHAR(20),                            -- Zip Code field, with a maximum length of 20 characters
    subsidy_contract_number VARCHAR(255),       -- Subsidy Contract Number field, with a maximum length of 255 characters
    total_cap VARCHAR(255),                          -- Total Capacity field, numeric type to handle numbers with precision
    ages_accepted_1 VARCHAR(255),               -- Ages Accepted 1 field, with a maximum length of 255 characters
    aa2 VARCHAR(255),                           -- AA2 field, with a maximum length of 255 characters
    aa3 VARCHAR(255),                           -- AA3 field, with a maximum length of 255 characters
    aa4 VARCHAR(255),                           -- AA4 field, with a maximum length of 255 characters
    license_monitoring_since VARCHAR(255),              -- License Monitoring Since field, with a date type
    school_year_only VARCHAR(255),                   -- School Year Only field, true or false
    evening_hours VARCHAR(255)                  -- Evening Hours field, with a maximum length of 255 characters
);
```

``` sql
CREATE TABLE source3 (
    operation VARCHAR(255) NOT NULL,           -- Operation field, required, with a maximum length of 255 characters
    agency_number VARCHAR(255) UNIQUE,         -- Agency Number field, unique, with a maximum length of 255 characters
    operation_name VARCHAR(255),               -- Operation Name field, with a maximum length of 255 characters
    address VARCHAR(255),                      -- Address field, with a maximum length of 255 characters
    city VARCHAR(255),                         -- City field, with a maximum length of 255 characters
    state VARCHAR(255),                        -- State field, with a maximum length of 255 characters
    zip VARCHAR(20),                           -- Zip field, with a maximum length of 20 characters
    county VARCHAR(255),                       -- County field, with a maximum length of 255 characters
    phone VARCHAR(20),                         -- Phone field, with a maximum length of 20 characters
    type VARCHAR(255),                         -- Type field, with a maximum length of 255 characters
    status VARCHAR(255),                       -- Status field, with a maximum length of 255 characters
    issue_date VARCHAR(255),                           -- Issue Date field, with a date type
    capacity VARCHAR(255),                          -- Capacity field, numeric type to handle numbers with precision
    email_address VARCHAR(255),                -- Email Address field, with a maximum length of 255 characters
    facility_id VARCHAR(255),                  -- Facility ID field, with a maximum length of 255 characters
    monitoring_frequency VARCHAR(255),                   -- Monitoring field, with a maximum length of 255 characters
    infant VARCHAR(255),                            -- Infant field, true or false
    toddler VARCHAR(255),                           -- Toddler field, true or false
    preschool VARCHAR(255),                         -- Preschool field, true or false
    school VARCHAR(255)                             -- School field, true or false
);
```

4. Run the following copy statements to upload the data
``` bash
COPY salesforce_leads FROM '~/Downloads/brightwheel_salesforce_leads.csv' DELIMITER ',' csv header;
COPY source1 FROM '~/Downloads/brightwheel_source1.csv' DELIMITER ',' csv header;
COPY source2 FROM '~/Downloads/brightwheel_source2.csv' DELIMITER ',' csv header;
COPY source3 FROM '~/Downloads/brightwheel_source3.csv' DELIMITER ',' csv header;
```

### DBT:
1. Navigate to where you want to install DBT 

2. Install DBT Core with the postgres adapter
``` bash
python -m pip install dbt-core dbt-postgres
```

3. Run `dbt init` to configure your dbt project and set up your `profile.yml` if not already created.


### Long Term Considerations
Some long term considerations I would make would when considering moving this to production include:
- adding an `etl_loaded_at` field from source to enable easy identifaction of recently uploaded records and help answer questions such as 
    - Of the delta leads, what data has changed since previous loads? 
    - How many net new leads are generated by each file ingested? 
- add dbt tests for unique and non-null values for all primary keys to ensure no record fanning
- adding duplicate lead merging logic in the intermediate layer to derive more holistic data where available
- Drive enrichment around city, website and schedule
- Are there duplicate/delta leads based on phone (primary identifier)/address information (secondary identifier)? 
- Row count tests in comparison to prior runs to ensure records aren't dropped and there are no schema change issues
- I could easily see the need for each of these staging models to be their own mart model
- I could see an argument for this `mart/leads` model to have a better home in the `activation` layer and this is why you see `activation` and `intermediate` folders despite no models in them


## Fields Dropped
I chose to drop the following fields that were requested in the final output as I did not find a relevant mapped value:
- language
- operator
- curriculum_type
- license_renewed

I added `lead_source` to identify the lead file source.