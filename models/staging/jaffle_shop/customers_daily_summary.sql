select
    customer_id,
    order_date, 
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_date']) }} as customer_order_id,
    count(*) as number_of_orders
from {{ ref("stg_jaffle_shop__orders") }} 
group by 1, 2
