/*
    MEPS market mart country coverage test.

    Purpose:
        Confirm that the market mart contains only the
        four approved MEPS target markets.
*/

select distinct country_code

from {{ ref('mart_meps_market') }}

where country_code not in (
    'GHA',
    'KEN',
    'NGA',
    'ZAF'
)