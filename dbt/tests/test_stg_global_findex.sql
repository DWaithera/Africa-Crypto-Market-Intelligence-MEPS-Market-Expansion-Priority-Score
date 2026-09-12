select
    country_code,
    indicator,
    year,
    count(*) as record_count
from {{ ref('stg_global_findex') }}
group by
    country_code,
    indicator,
    year
having count(*) > 1