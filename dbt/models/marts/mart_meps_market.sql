/*
    MEPS analytical market mart.

    Purpose:
        Create a wide, feature-ready representation of the four
        MEPS target markets.

    Design principles:
        - One row per country.
        - Use the latest available valid observation for each indicator.
        - Preserve the original reference year for every indicator.
        - Do not normalize or score indicators here.
        - Do not silently impute missing values.

    Note:
        Different indicators have different reference years.
        The corresponding *_year columns preserve those years.
*/

with indicators as (

    select
        country_code,
        country,
        indicator,
        value,
        reference_year

    from {{ ref('int_meps_indicators') }}

),

latest_valid as (

    select
        country_code,
        country,
        indicator,
        value,
        reference_year,

        row_number() over (
            partition by country_code, indicator
            order by
                case when value is not null then 0 else 1 end,
                reference_year desc
        ) as rn

    from indicators

),

latest as (

    select
        country_code,
        country,
        indicator,
        value,
        reference_year

    from latest_valid

    where rn = 1

),

market as (

    select
        country_code,
        country,

        max(
            case
                when indicator = 'population'
                then value
            end
        ) as population,

        max(
            case
                when indicator = 'population'
                then reference_year
            end
        ) as population_year,

        max(
            case
                when indicator = 'gdp_per_capita'
                then value
            end
        ) as gdp_per_capita,

        max(
            case
                when indicator = 'gdp_per_capita'
                then reference_year
            end
        ) as gdp_per_capita_year,

        max(
            case
                when indicator = 'internet_penetration'
                then value
            end
        ) as internet_penetration,

        max(
            case
                when indicator = 'internet_penetration'
                then reference_year
            end
        ) as internet_penetration_year,

        max(
            case
                when indicator = 'remittances_pct_gdp'
                then value
            end
        ) as remittances_pct_gdp,

        max(
            case
                when indicator = 'remittances_pct_gdp'
                then reference_year
            end
        ) as remittances_pct_gdp_year,

        max(
            case
                when indicator = 'account_ownership'
                then value
            end
        ) as account_ownership,

        max(
            case
                when indicator = 'account_ownership'
                then reference_year
            end
        ) as account_ownership_year,

        max(
            case
                when indicator = 'digital_payment_usage'
                then value
            end
        ) as digital_payment_usage,

        max(
            case
                when indicator = 'digital_payment_usage'
                then reference_year
            end
        ) as digital_payment_usage_year,

        max(
            case
                when indicator = 'smartphone_adoption'
                then value
            end
        ) as smartphone_adoption,

        max(
            case
                when indicator = 'smartphone_adoption'
                then reference_year
            end
        ) as smartphone_adoption_year,

        max(
            case
                when indicator = 'crypto_search_interest'
                then value
            end
        ) as crypto_search_interest,

        max(
            case
                when indicator = 'crypto_search_interest'
                then reference_year
            end
        ) as crypto_search_interest_year,

        max(
            case
                when indicator = 'crypto_adoption_rank'
                then value
            end
        ) as crypto_adoption_rank,

        max(
            case
                when indicator = 'crypto_adoption_rank'
                then reference_year
            end
        ) as crypto_adoption_rank_year

    from latest

    group by
        country_code,
        country

)

select
    country_code,
    country,

    population,
    population_year,

    gdp_per_capita,
    gdp_per_capita_year,

    internet_penetration,
    internet_penetration_year,

    remittances_pct_gdp,
    remittances_pct_gdp_year,

    account_ownership,
    account_ownership_year,

    digital_payment_usage,
    digital_payment_usage_year,

    smartphone_adoption,
    smartphone_adoption_year,

    crypto_search_interest,
    crypto_search_interest_year,

    crypto_adoption_rank,
    crypto_adoption_rank_year

from market