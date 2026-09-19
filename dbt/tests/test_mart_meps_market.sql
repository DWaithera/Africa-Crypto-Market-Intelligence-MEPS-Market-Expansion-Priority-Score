/*
    MEPS market mart uniqueness test.

    Purpose:
        Confirm that the analytical market mart contains
        exactly one row per approved MEPS market.
*/

select
    country_code,
    count(*) as record_count

from {{ ref('mart_meps_market') }}

group by country_code

having count(*) > 1