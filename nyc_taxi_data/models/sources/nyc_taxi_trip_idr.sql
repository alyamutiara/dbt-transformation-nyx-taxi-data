{{ config(materialized='table') }}

{% set fees = ['airport_fee', 'fare_amount', 'extra', 'mta_tax', 'tip_amount', 'tolls_amount', 'improvement_surcharge', 'total_amount', 'congestion_surcharge'] %}
SELECT
  * EXCEPT(
    {% for fee in fees %}
      {{ fee }}{% if not loop.last %},{% endif %}
    {% endfor %}
  ),
  {% for fee in fees %}
    {{ convert_currency(fee) }}{% if not loop.last %},{% endif %}
  {% endfor %}
FROM 
  {{ ref('nyc_taxi_trip') }}