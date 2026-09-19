/*
    Validate that all five MEPS dimension scores are populated.
*/

select
    country_code

from {{ ref('int_meps_dimension_scores') }}

where market_attractiveness_score is null
   or digital_readiness_score is null
   or financial_accessibility_score is null
   or crypto_demand_score is null
   or crypto_activity_score is null