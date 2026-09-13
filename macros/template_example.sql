{% macro template_example() %}

    {% set query %}
        select true as boolean
    {% endset %}

    {% if execute %}
        {{ log("Executing query: " ~ query, info=True) }}
        {% set results = run_query(query) %}
        {% set results_list = results.columns[0].values() %}
        {{ log("Query results: " ~ results_list, info=True) }}

        select {{ results_list }} as is_real
    {% else %}
        {{ log("Not executing query. Set 'execute' to true to run the query.", info=True) }}
    {% endif %}

{% endmacro %}