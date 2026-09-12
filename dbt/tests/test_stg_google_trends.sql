select
    country_code,
    indicator,
    year,
    count(*) as record_count
from {{ ref('stg_google_trends') }}
group by
    country_code,
    indicator,
    year
having count(*) > 1