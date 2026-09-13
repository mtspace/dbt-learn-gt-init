select
	ID as customer_id,
	ORDERID as order_id,
	PAYMENTMETHOD as payment_method,
	STATUS,
	{{ cents_to_dollars('AMOUNT') }} as amount,
	CREATED as created_date
from {{ source('stripe', 'payments')}}

