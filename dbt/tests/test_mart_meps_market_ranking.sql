/*
    Validate MEPS market ranking.

    Checks:
        - Market ranks are within the expected range 1-4.
*/

select
    market_rank,
    country_code

from {{ ref('mart_meps_market_ranking') }}

where market_rank < 1
   or market_rank > 4