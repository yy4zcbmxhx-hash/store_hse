with calendar as (
    select
        min(order_date) as first_day,
        max(order_date) as last_day,
        count(*) as days_count
    from {{ ref('dim_dates') }}
),
orders as (
    select
        min(order_date) as first_day,
        max(order_date) as last_day,
        coalesce(max(order_date) - min(order_date) + 1, 0) as expected_days
    from {{ ref('fct_orders') }}
)
select calendar.*, orders.expected_days
from calendar
cross join orders
where calendar.first_day is distinct from orders.first_day
   or calendar.last_day is distinct from orders.last_day
   or calendar.days_count != orders.expected_days
