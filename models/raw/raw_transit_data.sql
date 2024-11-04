{{ config(materialized='table') }}

-- This model serves as the raw data layer, directly loading data from the BigQuery table.
-- The data is sourced from the tb_bus_ridership table in the raw_data dataset.

select
    transit_timestamp,  -- The timestamp of each transit event
    bus_route,          -- The route of the bus
    payment_method,     -- The method used for payment
    fare_class_category, -- The fare class category (e.g., Full Fare, Seniors, etc.)
    ridership,          -- The number of riders for this entry
    transfers           -- The number of transfers associated with this entry
from `gcp-learn-368515.raw_data.tb_bus_ridership`  -- Reference to the BigQuery table
