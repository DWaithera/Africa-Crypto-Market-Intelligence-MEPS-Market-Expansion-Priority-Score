/*
    Validate that sensitivity analysis produces
    complete scores and ranks.
*/

select
    country_code,
    scenario

from {{ ref('int_meps_sensitivity') }}

where scenario_meps_score is null
   or scenario_rank is null