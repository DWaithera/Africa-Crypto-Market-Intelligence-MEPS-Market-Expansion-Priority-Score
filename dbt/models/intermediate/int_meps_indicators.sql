/*
    MEPS integrated indicator model.

    Purpose:
        Standardize the five MEPS staging datasets into one
        long-form analytical indicator layer.

    Design principles:
        - Preserve source reference years.
        - Preserve raw indicator values.
        - Do not normalize or score indicators here.
        - Do not force all indicators into a common year.
        - Preserve historical observations for trajectory analysis.
*/

with world_bank as (

    select
        country_code,
        country,
        indicator_name as indicator,
        value,
        cast(year as integer) as reference_year,
        'World Bank' as source,
        'World Bank Indicators' as source_dataset

    from {{ ref('stg_world_bank') }}

),

world_bank_remittances as (

    select
        country_code,
        country,
        indicator_name as indicator,
        value,
        cast(year as integer) as reference_year,
        'World Bank' as source,
        'World Bank Remittances' as source_dataset

    from {{ ref('stg_world_bank_remittances') }}

),

global_findex as (

    select
        country_code,
        country,
        indicator,
        value,
        cast(year as integer) as reference_year,
        'World Bank' as source,
        'Global Findex 2025' as source_dataset

    from {{ ref('stg_global_findex') }}

),

google_trends as (

    select
        country_code,
        country,
        indicator,
        value,
        cast(year as integer) as reference_year,
        source,
        'Google Trends' as source_dataset

    from {{ ref('stg_google_trends') }}

),

chainalysis as (

    select
        country_code,
        country,
        indicator,
        cast(crypto_adoption_rank as double) as value,
        cast(year as integer) as reference_year,
        source,
        source_dataset

    from {{ ref('stg_chainalysis') }}

),

unioned as (

    select * from world_bank

    union all

    select * from world_bank_remittances

    union all

    select * from global_findex

    union all

    select * from google_trends

    union all

    select * from chainalysis

)

select
    country_code,
    country,
    indicator,
    value,
    reference_year,
    source,
    source_dataset

from unioned