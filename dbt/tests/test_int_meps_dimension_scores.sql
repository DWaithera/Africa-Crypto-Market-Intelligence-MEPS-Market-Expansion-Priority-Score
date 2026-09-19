/*
    Validate MEPS dimension scores.

    Checks:
        - Every dimension score remains within [0, 1].
*/

with dimension_data as (

    select *
    from {{ ref('int_meps_dimension_scores') }}

),

range_failures as (

    select
        country_code,
        dimension_name,
        dimension_score

    from dimension_data

    unpivot (
        dimension_score for dimension_name in (
            market_attractiveness_score,
            digital_readiness_score,
            financial_accessibility_score,
            crypto_demand_score,
            crypto_activity_score
        )
    )

    where dimension_score < 0
       or dimension_score > 1

)

select *
from range_failures