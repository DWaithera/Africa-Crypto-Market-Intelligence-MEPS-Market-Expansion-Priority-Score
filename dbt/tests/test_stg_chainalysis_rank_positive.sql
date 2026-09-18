/*
    MEPS Chainalysis rank validation test.

    Purpose:
        Confirm that all Chainalysis adoption ranks
        in the staging layer are positive.
*/

select
    country_code,
    crypto_adoption_rank

from {{ ref('stg_chainalysis') }}

where crypto_adoption_rank <= 0