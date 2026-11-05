{{ config(distributed_replicated=true) }}

{% set start_date = "(select min(order_date)::timestamp from " ~ ref('fct_orders') ~ ")" %}
{% set end_date = "(select max(order_date)::timestamp + interval '1 day' from " ~ ref('fct_orders') ~ ")" %}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date=start_date,
        end_date=end_date
    ) }}
)

select
    date_day::date as order_date,
    extract(year from date_day)::integer as year,
    extract(quarter from date_day)::integer as quarter,
    extract(month from date_day)::integer as month,
    extract(day from date_day)::integer as day_of_month,
    extract(isodow from date_day)::integer as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from date_spine
