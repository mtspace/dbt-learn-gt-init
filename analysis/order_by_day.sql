with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)
, daily as (
    select
        order_date,
        count(*) as number_of_orders,
        {% for order_status in ['returned','completed','return_pending'] %}
            sum(case when status = '{{ order_status }}' then 1 else 0 end) as {{ order_status }}_total {% if not loop.last %},{% endif %}
        {% endfor %}
    from orders
    group by 1
)
, compared as (
    select
        *,
        lag(number_of_orders) over (order by order_date) as previous_day_orders,
    from daily
)
select * 
from compared