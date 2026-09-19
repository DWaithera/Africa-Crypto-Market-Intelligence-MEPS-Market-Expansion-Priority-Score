/*
    MEPS dimension scoring model.

    Purpose:
        Aggregate normalized MEPS features into the five
        approved MEPS dimension scores.

    Design principles:
        - Equal weighting of features within each dimension.
        - Dimension scores remain on a 0-1 scale.
        - No final MEPS score is calculated here.
        - No market ranking is calculated here.
*/

with features as (

    select
        country_code,
        country,

        population_feature,
        gdp_per_capita_feature,
        remittances_pct_gdp_feature,

        internet_penetration_feature,
        smartphone_adoption_feature,

        account_ownership_feature,
        digital_payment_usage_feature,

        crypto_search_interest_feature,
        crypto_adoption_rank_feature

    from {{ ref('int_meps_features') }}

)

select
    country_code,
    country,

    (
        population_feature
        + gdp_per_capita_feature
        + remittances_pct_gdp_feature
    ) / 3.0 as market_attractiveness_score,

    (
        internet_penetration_feature
        + smartphone_adoption_feature
    ) / 2.0 as digital_readiness_score,

    (
        account_ownership_feature
        + digital_payment_usage_feature
    ) / 2.0 as financial_accessibility_score,

    crypto_search_interest_feature as crypto_demand_score,

    crypto_adoption_rank_feature as crypto_activity_score

from features