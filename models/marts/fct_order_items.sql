{{ config(distributed_by='order_id') }}

with items as (
    select *
    from {{ ref('stg_shop__order_items') }}
),

orders as (
    select *
    from {{ ref('fct_orders') }}
)

select
    i.order_item_id,
    i.order_id,
    i.product_id,
    o.customer_id,
    o.order_date,
    i.quantity,
    i.unit_price,
    i.discount_amount,
    i.line_amount,
    o.is_confirmed
from items as i
inner join orders as o
    on o.order_id = i.order_id