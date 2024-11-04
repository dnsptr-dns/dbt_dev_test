{{ config(materialized="table") }}

-- This model creates a dimension table for bus routes.
-- Each bus route is assigned a unique surrogate key using a hash function.
with
    base as (
        -- Select distinct bus routes from the raw data
        select distinct bus_route from {{ ref("raw_transit_data") }}  -- Reference to the raw data model
    )

select
    md5(bus_route) as bus_route_id,  -- Generate a unique surrogate key for each bus route
    bus_route  -- The bus route name
from base
