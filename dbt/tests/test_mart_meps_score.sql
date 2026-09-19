/*
    Validate MEPS composite scores.

    Checks:
        - MEPS score remains within [0, 1].
*/

with score_data as (

    select
        country_code,
        meps_score

    from {{ ref('mart_meps_score') }}

)

select
    country_code,
    meps_score

from score_data

where meps_score < 0
   or meps_score > 1