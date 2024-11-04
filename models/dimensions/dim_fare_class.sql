{{ config(materialized='table') }}

-- This model creates a dimension table for fare classes.
-- Each fare class is assigned a unique surrogate key.

with base as (
    -- Select distinct fare class categories from the raw data
    select distinct fare_class_category
    from {{ ref('raw_transit_data') }}  -- Reference to the raw data model
)

select
    md5(fare_class_category) as fare_class_id,  -- Generate a unique surrogate key for each fare class
    fare_class_category                          -- The fare class name
from base
