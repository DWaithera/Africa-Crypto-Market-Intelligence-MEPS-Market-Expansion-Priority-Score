/*
    MEPS market ranking model.

    Purpose:
        Create the production market-priority view using the
        baseline MEPS score.

    Design principles:
        - Use the approved baseline 20% dimension weights.
        - Preserve all five dimension scores.
        - Rank markets by descending baseline MEPS score.
        - Use ROW_NUMBER for a deterministic one-to-one ranking.
        - Sensitivity scenarios remain separate.
*/

with meps_scores as (

    select
        country_code,
        country,

        market_attractiveness_score,
        digital_readiness_score,
        financial_accessibility_score,
        crypto_demand_score,
        crypto_activity_score,

        meps_score

    from {{ ref('mart_meps_score') }}

),

ranked as (

    select
        *,
        row_number() over (
            order by
                meps_score desc,
                country_code asc
        ) as market_rank

    from meps_scores

)

select
    market_rank,
    country_code,
    country,

    meps_score,

    market_attractiveness_score,
    digital_readiness_score,
    financial_accessibility_score,
    crypto_demand_score,
    crypto_activity_score

from ranked
