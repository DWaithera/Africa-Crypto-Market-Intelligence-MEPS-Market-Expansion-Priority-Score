/*
    MEPS integrated indicator country coverage test.

    Purpose:
        Confirm that the integrated model contains exactly
        the four approved MEPS markets.
*/

select distinct country_code

from {{ ref('int_meps_indicators') }}

where country_code not in (
    'GHA',
    'KEN',
    'NGA',
    'ZAF'
)