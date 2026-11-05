with source_total as (
    select coalesce(sum(orders.total_amount), 0) as revenue
    from {{ source('shop', 'orders') }} as orders
    where orders.status = 'paid'
      and exists (
          select 1
          from {{ source('shop', 'payments') }} as payments
          where payments.order_id = orders.order_id
            and payments.payment_status = 'success'
            and payments.amount >= 0
      )
),
mart_total as (
    select coalesce(sum(order_amount), 0) as revenue
    from {{ ref('fct_orders') }}
    where is_confirmed
)
select source_total.revenue as source_revenue, mart_total.revenue as mart_revenue
from source_total
cross join mart_total
where source_total.revenue != mart_total.revenue
