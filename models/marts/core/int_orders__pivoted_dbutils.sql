with payments as (
    select
        order_id,
        payment_method,
        amount
    from {{ ref('stg_stripe__payments') }}
    where status = 'success'
)
, pivoted as (
    select
        order_id,
        {{ dbt_utils.pivot(
            'payment_method',
            dbt_utils.get_column_values(ref('stg_stripe__payments'), 'payment_method')
        ) }}
    from payments
    group by order_id
)
select * from pivoted