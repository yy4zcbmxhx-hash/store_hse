select *
from {{ ref('dim_dates') }}
where year is distinct from extract(year from order_date)
   or quarter is distinct from extract(quarter from order_date)
   or month is distinct from extract(month from order_date)
   or day_of_month is distinct from extract(day from order_date)
   or day_of_week is distinct from extract(isodow from order_date)
   or is_weekend is distinct from (extract(isodow from order_date) in (6, 7))
