{% macro clean_stale_models(database = target.database, schema = target.schema, days_old = 7) %}
    {{ log("In clean_stale_models" , info=True) }}
    {% set sql %}
        select
            table_type,
            table_schema,
            table_name,
            last_altered
        from {{ database }}.information_schema.tables
        where table_schema = upper('{{ schema }}')
        and last_altered <= current_date - interval '{{ days_old }}' day
    {% endset %}

    {{ log("Running query: " ~ sql, info=True) }}
    {% set results = run_query(sql) %}
    {{ log("Query results: " ~ results, info=True) }}

    {% if execute %}
        {% for row in results %}
            {% set table_type = row[0] %}
            {% set table_schema = row[1] %}
            {% set table_name = row[2] %}

            {% if table_type == 'BASE TABLE' %}
                {# {% set drop_sql = "drop table if exists " ~ database ~ "." ~ table_schema ~ "." ~ table_name %} #}
                {% set drop_sql = "select count(*) from " ~ database ~ "." ~ table_schema ~ "." ~ table_name %}
                
                {{ log("Dropping stale model: " ~ drop_sql, info=True) }}
                {{ run_query(drop_sql) }}
            {% else %}
                {{ log("Skipping non-table object: " ~ table_type ~ " " ~ table_schema ~ "." ~ table_name, info=True) }}
            {% endif %}
        {% endfor %}
    {% endif %}
{% endmacro %}