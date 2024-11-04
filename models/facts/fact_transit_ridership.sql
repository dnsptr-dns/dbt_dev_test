{{ config(materialized='table') }}

-- This model creates a fact table for transit ridership.
-- It aggregates ridership data and links to the dimension tables using foreign keys.

with base as (
    select
        transit_timestamp,
        bus_route,
        payment_method,
        fare_class_category,
        sum(ridership) as total_ridership,   -- Aggregate ridership
        sum(transfers) as total_transfers,   -- Aggregate transfers
        date(transit_timestamp) as transit_date,  -- Extract date
        time(transit_timestamp) as transit_time   -- Extract time
    from `gcp-learn-368515.raw_data.tb_bus_ridership`  
    group by
        transit_timestamp,
        bus_route,
        payment_method,
        fare_class_category  
)

-- Join with dimension tables using IDs
select
    md5(concat(transit_timestamp, base.bus_route, base.payment_method)) as fact_id,  -- Generate a unique fact identifier
    b.bus_route_id,             -- Foreign key from dim_bus_route
    p.payment_method_id,        -- Foreign key from dim_payment_method
    f.fare_class_id,            -- Foreign key from dim_fare_class
    transit_date,               -- Event date
    transit_time,               -- Event time
    total_ridership,            -- Aggregated ridership
    total_transfers             -- Aggregated transfers
from base
join {{ ref('dim_bus_route') }} b on base.bus_route = b.bus_route  
join {{ ref('dim_payment_method') }} p on base.payment_method = p.payment_method  
join {{ ref('dim_fare_class') }} f on base.fare_class_category = f.fare_class_category  
