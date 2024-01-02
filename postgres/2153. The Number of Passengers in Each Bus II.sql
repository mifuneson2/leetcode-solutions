-- 2153. The Number of Passengers in Each Bus II
-- from: https://leetcode.com/problems/the-number-of-passengers-in-each-bus-ii/
-- tags: database, hard, recursive, no_posted_solution

-- Write your PostgreSQL query statement below

with recursive buses_clean as (
    select
        bus_id
        ,arrival_time
        ,capacity
        ,lag(arrival_time, 1,0) over (order by arrival_time) as prev_bus_time
    from buses
)
,arrivals as (
    select
        b.bus_id
        ,b.arrival_time
        ,b.capacity
        ,b.prev_bus_time
        ,count(p.passenger_id) as new_passengers
        ,row_number() over (order by b.arrival_time) as bus_arrival
    from buses_clean b
    left join passengers p 
        on p.arrival_time > b.prev_bus_time  
        and p.arrival_time <= b.arrival_time
    group by 1,2,3,4
    order by 1,2,3,4
)
-- recursive query
,boarding_schedule as (
    select 
        b.bus_arrival
        ,b.bus_id
        ,b.new_passengers
        ,least(b.capacity, b.new_passengers) as boarded
        ,new_passengers - least(b.capacity, b.new_passengers) as remaining
    from arrivals b
    where bus_arrival = 1

    union all

    select
        a.bus_arrival
        ,a.bus_id
        ,a.new_passengers
        ,least(a.capacity, a.new_passengers + s.remaining) as boarded
        ,(a.new_passengers + s.remaining) 
            - least(a.capacity, a.new_passengers + s.remaining) as remaining

    from arrivals a
        ,boarding_schedule s
    where a.bus_arrival = s.bus_arrival+1
)

select
    bus_id
    ,boarded as passengers_cnt
from boarding_schedule
order by bus_id