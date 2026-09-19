/*
    MEPS sensitivity analysis model.

    Purpose:
        Test how MEPS scores and market ordering change under
        reasonable alternative dimension-weight scenarios.

    Scenarios:
        - baseline: equal 20% weighting
        - market_led: greater weight on Market Attractiveness
        - crypto_led: greater weight on Crypto Demand and Activity
        - readiness_led: greater weight on Digital Readiness
          and Financial Accessibility

    Design principles:
        - All scenarios sum to 100%.
        - The production MEPS baseline is not modified.
        - Sensitivity analysis is kept separate from the production score.
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

),

scenario_weights as (

    select
        'baseline' as scenario,
        0.20 as market_weight,
        0.20 as digital_weight,
        0.20 as financial_weight,
        0.20 as demand_weight,
        0.20 as activity_weight

    union all

    select
        'market_led',
        0.30,
        0.20,
        0.20,
        0.15,
        0.15

    union all

    select
        'crypto_led',
        0.15,
        0.15,
        0.15,
        0.25,
        0.30

    union all

    select
        'readiness_led',
        0.15,
        0.30,
        0.25,
        0.15,
        0.15

),

scenario_scores as (

    select
        d.country_code,
        d.country,
        s.scenario,

        (
            d.market_attractiveness_score * s.market_weight
            + d.digital_readiness_score * s.digital_weight
            + d.financial_accessibility_score * s.financial_weight
            + d.crypto_demand_score * s.demand_weight
            + d.crypto_activity_score * s.activity_weight
        ) as scenario_meps_score

    from dimension_scores d

    cross join scenario_weights s

)

select
    country_code,
    country,
    scenario,
    scenario_meps_score,

    rank() over (
        partition by scenario
        order by scenario_meps_score desc
    ) as scenario_rank

from scenario_scores