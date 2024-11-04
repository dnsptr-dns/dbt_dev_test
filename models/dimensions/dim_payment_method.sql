{{ config(materialized="table") }}

-- This model creates a dimension table for payment methods.
-- Each payment method is assigned a unique surrogate key.
with
    base as (
        -- Select distinct payment methods from the raw data
        select distinct payment_method from {{ ref("raw_transit_data") }}  -- Reference to the raw data model
    )

select
    md5(payment_method) as payment_method_id,  -- Generate a unique surrogate key for each payment method
    payment_method  -- The payment method name
from base
