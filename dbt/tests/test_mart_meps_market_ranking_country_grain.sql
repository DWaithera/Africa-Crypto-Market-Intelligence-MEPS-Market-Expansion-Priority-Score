/*
    Validate one ranking record per MEPS market.
*/

select
    country_code,
    count(*) as record_count

from {{ ref('mart_meps_market_ranking') }}

group by country_code

having count(*) > 1