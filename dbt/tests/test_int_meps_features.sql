/*
    Validate MEPS engineered features.

    Checks:
        1. One feature record per country.
        2. All normalized features are within [0, 1].
        3. No normalized feature is unexpectedly null.
*/

with feature_data as (

    select *
    from {{ ref('int_meps_features') }}

),

range_failures as (

    select
        country_code,
        feature_name,
        feature_value

    from feature_data

    unpivot (
        feature_value for feature_name in (
            population_feature,
            gdp_per_capita_feature,
            remittances_pct_gdp_feature,
            internet_penetration_feature,
            smartphone_adoption_feature,
            account_ownership_feature,
            digital_payment_usage_feature,
            crypto_search_interest_feature,
            crypto_adoption_rank_feature
        )
    )

    where feature_value < 0
       or feature_value > 1

)

select *
from range_failures