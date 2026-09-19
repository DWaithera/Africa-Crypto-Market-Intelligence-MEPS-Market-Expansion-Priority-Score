/*
    Validate MEPS sensitivity scores and ranks.

    Checks:
        - Scenario scores remain within [0, 1].
        - Scenario ranks are valid positive integers.
*/

select
    country_code,
    scenario,
    scenario_meps_score,
    scenario_rank

from {{ ref('int_meps_sensitivity') }}

where scenario_meps_score < 0
   or scenario_meps_score > 1
   or scenario_rank < 1