{{ config(materialized='table') }}

{% set report_columns = ['vendor_name', 'rate_code', 'payment_type'] %}
SELECT
  EXTRACT(YEAR FROM pickup_date) AS year,
  EXTRACT(MONTH FROM pickup_date) AS month,
  {% for report_column in report_columns %}
    {{ report_column }},
  {% endfor %}
  SUM(trip_distance) AS total_trip_distance,
  SUM(passenger_count) AS num_passengers,
  SUM(total_amount) AS monthly_total_amount,
  COUNT(1) AS num_rides
FROM 
  {{ ref('nyc_taxi_trip')}}
GROUP BY
  EXTRACT(YEAR FROM pickup_date),
  EXTRACT(MONTH FROM pickup_date),
  {% for report_column in report_columns %}
    {{ report_column }}{% if not loop.last %},{% endif %}
  {% endfor %}