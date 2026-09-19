/*
    MEPS feature engineering model.

    Purpose:
        Transform and normalize the raw MEPS market indicators
        into comparable 0-1 analytical features.

    Design principles:
        - Preserve original indicator values.
        - Apply transformations only where methodologically justified.
        - Reduce population scale using log1p.
        - Reverse the Chainalysis adoption rank because lower rank
          represents stronger crypto activity.
        - Normalize features using Min-Max scaling across the
          four MEPS markets.
        - Do not calculate dimension scores or the final MEPS score here.
*/

with source_data as (

    select
        country_code,
        country,

        population,
        gdp_per_capita,
        remittances_pct_gdp,

        internet_penetration,
        smartphone_adoption,

        account_ownership,
        digital_payment_usage,

        crypto_search_interest,
        crypto_adoption_rank

    from {{ ref('mart_meps_market') }}

),

transformed as (

    select
        *,

        ln(population + 1) as population_transformed,

        (
            max(crypto_adoption_rank) over ()
            - crypto_adoption_rank
        ) as crypto_adoption_rank_transformed

    from source_data

),

normalized as (

    select
        *,

        case
            when max(population_transformed) over ()
                 = min(population_transformed) over ()
            then null
            else
                (
                    population_transformed
                    - min(population_transformed) over ()
                )
                /
                (
                    max(population_transformed) over ()
                    - min(population_transformed) over ()
                )
        end as population_feature,

        case
            when max(gdp_per_capita) over ()
                 = min(gdp_per_capita) over ()
            then null
            else
                (
                    gdp_per_capita
                    - min(gdp_per_capita) over ()
                )
                /
                (
                    max(gdp_per_capita) over ()
                    - min(gdp_per_capita) over ()
                )
        end as gdp_per_capita_feature,

        case
            when max(remittances_pct_gdp) over ()
                 = min(remittances_pct_gdp) over ()
            then null
            else
                (
                    remittances_pct_gdp
                    - min(remittances_pct_gdp) over ()
                )
                /
                (
                    max(remittances_pct_gdp) over ()
                    - min(remittances_pct_gdp) over ()
                )
        end as remittances_pct_gdp_feature,

        case
            when max(internet_penetration) over ()
                 = min(internet_penetration) over ()
            then null
            else
                (
                    internet_penetration
                    - min(internet_penetration) over ()
                )
                /
                (
                    max(internet_penetration) over ()
                    - min(internet_penetration) over ()
                )
        end as internet_penetration_feature,

        case
            when max(smartphone_adoption) over ()
                 = min(smartphone_adoption) over ()
            then null
            else
                (
                    smartphone_adoption
                    - min(smartphone_adoption) over ()
                )
                /
                (
                    max(smartphone_adoption) over ()
                    - min(smartphone_adoption) over ()
                )
        end as smartphone_adoption_feature,

        case
            when max(account_ownership) over ()
                 = min(account_ownership) over ()
            then null
            else
                (
                    account_ownership
                    - min(account_ownership) over ()
                )
                /
                (
                    max(account_ownership) over ()
                    - min(account_ownership) over ()
                )
        end as account_ownership_feature,

        case
            when max(digital_payment_usage) over ()
                 = min(digital_payment_usage) over ()
            then null
            else
                (
                    digital_payment_usage
                    - min(digital_payment_usage) over ()
                )
                /
                (
                    max(digital_payment_usage) over ()
                    - min(digital_payment_usage) over ()
                )
        end as digital_payment_usage_feature,

        case
            when max(crypto_search_interest) over ()
                 = min(crypto_search_interest) over ()
            then null
            else
                (
                    crypto_search_interest
                    - min(crypto_search_interest) over ()
                )
                /
                (
                    max(crypto_search_interest) over ()
                    - min(crypto_search_interest) over ()
                )
        end as crypto_search_interest_feature,

        case
            when max(crypto_adoption_rank_transformed) over ()
                 = min(crypto_adoption_rank_transformed) over ()
            then null
            else
                (
                    crypto_adoption_rank_transformed
                    - min(crypto_adoption_rank_transformed) over ()
                )
                /
                (
                    max(crypto_adoption_rank_transformed) over ()
                    - min(crypto_adoption_rank_transformed) over ()
                )
        end as crypto_adoption_rank_feature

    from transformed

)

select
    country_code,
    country,

    population,
    gdp_per_capita,
    remittances_pct_gdp,
    internet_penetration,
    smartphone_adoption,
    account_ownership,
    digital_payment_usage,
    crypto_search_interest,
    crypto_adoption_rank,

    population_transformed,
    crypto_adoption_rank_transformed,

    population_feature,
    gdp_per_capita_feature,
    remittances_pct_gdp_feature,
    internet_penetration_feature,
    smartphone_adoption_feature,
    account_ownership_feature,
    digital_payment_usage_feature,
    crypto_search_interest_feature,
    crypto_adoption_rank_feature

from normalized
