/*
    Validate four countries per sensitivity scenario.
*/

select
    scenario,
    count(*) as record_count

from {{ ref('int_meps_sensitivity') }}

group by scenario

having count(*) <> 4