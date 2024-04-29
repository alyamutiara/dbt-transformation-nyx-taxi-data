{% macro convert_currency(usd_amount) %}
    {{ usd_amount }} * 16239 AS {{ usd_amount }}_idr
{% endmacro %}