/*
    Validate that ranking, MEPS score, and all dimension
    scores are populated.
*/

select
    country_code

from {{ ref('mart_meps_market_ranking') }}

where market_rank is null
   or meps_score is null
   or market_attractiveness_score is null
   or digital_readiness_score is null
   or financial_accessibility_score is null
   or crypto_demand_score is null
   or crypto_activity_score is null