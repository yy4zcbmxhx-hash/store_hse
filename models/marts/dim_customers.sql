{{ config(distributed_by='customer_id') }}

with confirmed_orders as (
    select
        customer_id,
        order_id,
        ordered_at,
        order_amount,
        row_number() over (
            partition by customer_id
            order by ordered_at, order_id
        ) as purchase_number
    from {{ ref('fct_orders') }}
    where is_confirmed
),

customer_stats as (
    select
        customer_id,
        count(*) as confirmed_orders_count,
        sum(order_amount) as confirmed_revenue
    from confirmed_orders
    group by customer_id
),

first_orders as (
    select
        customer_id,
        order_id as first_confirmed_order_id,
        ordered_at as first_confirmed_at
    from confirmed_orders
    where purchase_number = 1
)

select
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel,
    f.first_confirmed_order_id,
    f.first_confirmed_at,
    coalesce(s.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(s.confirmed_revenue, 0) as confirmed_revenue,
    coalesce(s.confirmed_orders_count, 0) > 0 as is_buyer
from {{ ref('stg_shop__customers') }} as c
left join customer_stats as s
    on s.customer_id = c.customer_id
left join first_orders as f
    on f.customer_id = c.customer_id