/*
    MEPS integrated indicator model tests.

    Purpose:
        Validate the standardized long-form analytical layer.

    Expected grain:
        country_code + indicator + reference_year
*/

select
    country_code,
    indicator,
    reference_year,
    count(*) as record_count

from {{ ref('int_meps_indicators') }}

group by
    country_code,
    indicator,
    reference_year

having count(*) > 1