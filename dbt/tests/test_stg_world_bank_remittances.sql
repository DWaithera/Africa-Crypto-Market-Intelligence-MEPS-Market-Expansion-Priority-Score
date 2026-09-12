select
country_code,
indicator_code,
year,
count(*) as record_count
from {{ ref('stg_world_bank_remittances') }}
group by
country_code,
indicator_code,
year
having count(*) > 1
