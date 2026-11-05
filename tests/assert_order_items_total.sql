with item_totals as (
    select order_id, sum(line_amount) as items_amount
    from {{ ref('fct_order_items') }}
    group by order_id
)
select
    coalesce(orders.order_id, item_totals.order_id) as order_id,
    orders.order_amount,
    item_totals.items_amount
from {{ ref('fct_orders') }} as orders
full outer join item_totals on item_totals.order_id = orders.order_id
where orders.order_id is null
   or orders.order_amount is null
   or orders.order_amount != coalesce(item_totals.items_amount, 0)
