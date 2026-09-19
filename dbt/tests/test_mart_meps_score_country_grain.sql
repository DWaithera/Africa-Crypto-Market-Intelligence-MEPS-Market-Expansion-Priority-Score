/*
    Validate one MEPS score record per market.
*/

select
    country_code,
    count(*) as record_count

from {{ ref('mart_meps_score') }}

group by country_code

having count(*) > 1