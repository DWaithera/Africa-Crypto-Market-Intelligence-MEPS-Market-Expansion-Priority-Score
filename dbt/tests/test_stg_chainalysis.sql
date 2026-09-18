/*
    MEPS Chainalysis staging model test.

    Purpose:
        Confirm that the Chainalysis staging model contains
        exactly one record per country + indicator + year.
*/

select
    country_code,
    indicator,
    year,
    count(*) as record_count

from {{ ref('stg_chainalysis') }}

group by
    country_code,
    indicator,
    year

having count(*) > 1