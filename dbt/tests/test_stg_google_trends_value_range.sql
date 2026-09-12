select *
from {{ ref('stg_google_trends') }}
where value is not null
  and (value < 0 or value > 100)