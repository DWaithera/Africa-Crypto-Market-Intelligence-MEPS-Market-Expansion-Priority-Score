/*
    Validate that all MEPS normalized features are populated.
*/

select
    country_code

from {{ ref('int_meps_features') }}

where population_feature is null
   or gdp_per_capita_feature is null
   or remittances_pct_gdp_feature is null
   or internet_penetration_feature is null
   or smartphone_adoption_feature is null
   or account_ownership_feature is null
   or digital_payment_usage_feature is null
   or crypto_search_interest_feature is null
   or crypto_adoption_rank_feature is null