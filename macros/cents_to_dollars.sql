{%- macro cents_to_dollars(column, decimals=2) -%}
  -- amount is stored in cents, so we need to convert it to dollars
  round({{ column }} * 1.0 / 100, {{ decimals }})
{%- endmacro -%}