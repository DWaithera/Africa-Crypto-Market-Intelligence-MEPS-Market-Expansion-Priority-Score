select *
from {{ ref('stg_global_findex') }}
where value is not null
  and (value < 0 or value > 1)