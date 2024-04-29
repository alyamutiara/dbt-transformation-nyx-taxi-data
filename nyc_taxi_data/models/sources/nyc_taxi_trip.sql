{{ config(materialized='table') }}

SELECT 
  EXTRACT(DATE FROM lpep_pickup_datetime) AS pickup_date,
  EXTRACT(DATE FROM lpep_dropoff_datetime) AS dropoff_date,
  CASE
    WHEN VendorID = 1 THEN 'Creative Mobile Technologies, LLC'
    WHEN VendorID = 2 THEN 'VeriFone Inc.'
    ELSE 'Unknown'
  END AS vendor_name,
  CASE
    WHEN store_and_fwd_flag = 'N' THEN false
    WHEN store_and_fwd_flag = 'Y' THEN true
  END AS store_and_fwd_flag,
  CASE
    WHEN RatecodeID = 1 THEN 'Standard rate'
    WHEN RatecodeID = 2 THEN 'JFK'
    WHEN RatecodeID = 3 THEN 'Newark'
    WHEN RatecodeID = 4 THEN 'Nassau or Westchester'
    WHEN RatecodeID = 5 THEN 'Negotiated fare'
    WHEN RatecodeID = 6 THEN 'Group ride'
    ELSE 'Unknown'
  END AS rate_code,
  CASE
    WHEN payment_type = 1 THEN 'Credit card'
    WHEN payment_type = 2 THEN 'Cash'
    WHEN payment_type = 3 THEN 'No charge'
    WHEN payment_type = 4 THEN 'Dispute'
    WHEN payment_type = 5 THEN 'Unknown'
    ELSE 'Voided trip'
  END AS payment_type,
  CASE
    WHEN RateCodeID = 2 THEN 1.25
    ELSE 0.0
  END AS airport_fee,
  * EXCEPT (
    VendorID,
    store_and_fwd_flag,
    RatecodeID,
    payment_type,
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    ehail_fee
  )
FROM 
  {{ source('nycTaxi', 'raw_nyc_taxi_trip')}}