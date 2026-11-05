select c.category_id
from {{ ref('stg_shop__product_categories') }} as c
left join {{ ref('int_product_categories') }} as t
    on t.category_id = c.category_id
where t.category_id is null
