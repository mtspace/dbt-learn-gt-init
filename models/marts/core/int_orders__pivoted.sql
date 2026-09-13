with payments as (
    select
        order_id,
        payment_method,
        amount
    from {{ ref('stg_stripe__payments') }}
    where status = 'success'
)
, pivoted as (
    {% set payment_methods = ['card', 'gift_card', 'coupon', 'bitcoin', 'bank_transfer'] %}

    select
        order_id,
        {% for method in payment_methods %}
            sum(case when payment_method = '{{ method }}' then amount else 0 end) as {{ method }}_amount
            {%- if not loop.last -%}, {% endif -%} 
        {% endfor %}
    from payments
    group by order_id
)
select * from pivoted