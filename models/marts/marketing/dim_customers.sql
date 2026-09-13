with customers as (

    select *
    from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select *
    from {{ ref('stg_jaffle_shop__orders')}}

),

employees as (

    select *
    from {{ ref('employees')}}

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by customer_id

),

stripe_payments as (
    select *
    from {{ ref('fct_orders') }}

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        sum(amount) as lifetime_value,
        employees.EMPLOYEE_ID

    from customers

    left join orders using (customer_id)

    left join customer_orders using (customer_id)

    left join stripe_payments using (order_id)

    left join employees on employees.CUSTOMER_ID = customers.CUSTOMER_ID

    group by
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.number_of_orders,
        employees.EMPLOYEE_ID

)

select * from final
