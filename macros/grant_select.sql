{% macro grant_select(schema=target.schema, role=target.role, database=target.database) %} 
    {% set sql %}
        USE DATABASE {{ database }};
        GRANT USAGE ON SCHEMA {{ schema }} TO ROLE {{ role }};
        GRANT SELECT ON ALL TABLES IN SCHEMA {{ schema }} TO ROLE {{ role }};
        GRANT SELECT ON ALL VIEWS IN SCHEMA {{ schema }} TO ROLE {{ role }};
    {% endset %}

    {{ log ("Granting SELECT privileges on schema '" ~ schema ~ "' to role '" ~ role ~ "' in database '" ~ database ~ "'.", info=True) }}
    {% do run_query(sql) %}
    {{ log ("Finished grants", info=True) }}
{% endmacro %}