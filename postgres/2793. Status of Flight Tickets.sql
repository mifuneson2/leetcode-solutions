-- 2793. Status of Flight Tickets
-- https://leetcode.com/problems/status-of-flight-tickets/
-- tags: database, hard, no_posted_solution, window

-- Write your PostgreSQL query statement below

with passenger_priority as (
    select
        passenger_id
        ,flight_id
        ,booking_time
        ,row_number() over (partition by flight_id order by booking_time) as pri
    from passengers
)
,booking_status as(
    select
        f.flight_id
        ,f.capacity
        ,p.pri
        ,p.passenger_id
        ,case
            when f.capacity >= p.pri then 'Confirmed'
            else 'Waitlist'
        end as status
    from flights f
    join passenger_priority p
    on f.flight_id = p.flight_id
    order by 1,3
)

select passenger_id, status
from booking_status
order by 1
