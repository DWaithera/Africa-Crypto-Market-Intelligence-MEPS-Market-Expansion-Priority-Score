/*
    Validate that all MEPS dimension scores and
    the final MEPS score are populated.
*/

select
    country_code

from {{ ref('mart_meps_score') }}

where market_attractiveness_score is null
   or digital_readiness_score is null
   or financial_accessibility_score is null
   or crypto_demand_score is null
   or crypto_activity_score is null
   or meps_score is null