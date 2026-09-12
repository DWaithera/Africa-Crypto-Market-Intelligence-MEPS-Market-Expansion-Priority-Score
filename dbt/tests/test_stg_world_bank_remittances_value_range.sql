select *
from {{ ref('stg_world_bank_remittances') }}
where value is not null
  and value < 0