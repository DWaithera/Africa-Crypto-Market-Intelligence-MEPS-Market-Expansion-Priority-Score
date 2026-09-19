/*
    Validate one feature record per MEPS market.
*/

select
    country_code,
    count(*) as record_count

from {{ ref('int_meps_features') }}

group by country_code

having count(*) > 1