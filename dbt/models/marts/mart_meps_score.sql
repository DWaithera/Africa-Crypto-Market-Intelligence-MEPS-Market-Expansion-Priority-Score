/*
    MEPS final scoring model.

    Purpose:
        Calculate the composite Market Expansion Priority Score
        from the five approved MEPS dimension scores.

    Design principles:
        - Equal 20% weighting across the five dimensions.
        - Final MEPS score remains on a 0-1 scale.
        - No market ranking is calculated here.
        - Dimension scores are preserved for interpretation.
*/

with dimension_scores as (

    select
        country_code,
        country,

        market_attractiveness_score,
        digital_readiness_score,
        financial_accessibility_score,
        crypto_demand_score,
        crypto_activity_score

    from {{ ref('int_meps_dimension_scores') }}

)

select
    country_code,
    country,

    market_attractiveness_score,
    digital_readiness_score,
    financial_accessibility_score,
    crypto_demand_score,
    crypto_activity_score,

    (
        market_attractiveness_score * 0.20
        + digital_readiness_score * 0.20
        + financial_accessibility_score * 0.20
        + crypto_demand_score * 0.20
        + crypto_activity_score * 0.20
    ) as meps_score

from dimension_scores