/*
    Validate one dimension-score record per MEPS market.
*/

select
    country_code,
    count(*) as record_count

from {{ ref('int_meps_dimension_scores') }}

group by country_code

having count(*) > 1