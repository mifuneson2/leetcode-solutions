-- 1645. Hopper Company Queries II
-- https://leetcode.com/problems/hopper-company-queries-ii/
-- tags: database, hard, no_posted_solution

-- Write your PostgreSQL query statement below
with date_range(month) as (
    --select * from generate_series(1, 12)
    select generate_series(
        '2020-01-01'::date, 
        '2020-12-01'::date,
        '1 month'::interval
    )
)
,date_range_clean as (
    select 
        month
        ,date_part('month', month) as month_num
    from date_range
)
,accepted_rides_dates as (
    select
        r.requested_at
        ,date_trunc('month', r.requested_at) as requested_month
        ,date_part('month', r.requested_at) as requested_month_num
        ,a.*
    from rides r
    right join acceptedrides a on a.ride_id = r.ride_id
    order by a.ride_id
)

,accepted_drivers_months as (
    select
        requested_month_num
        ,count (distinct driver_id) as accepted_driver_ct
    from accepted_rides_dates
    where requested_at between date'2020-01-01' and date'2020-12-31'
    group by 1
    order by 1
)

,available_driver_months as (
    select 
        d.driver_id
        ,d.join_date
        ,m.month
        ,m.month_num
        ,case
            when m.month >= date_trunc('month', d.join_date) then true
            when m.month < date_trunc('month', d.join_date) then false
            else null
        end as driver_available
    
    from drivers d
    cross join date_range_clean m 
)
,available_drivers as (
    select 
        m.month
        ,m.month_num
        , count (driver_id) as avail_driver_ct
    from date_range_clean m
    join (
        select *
        from available_driver_months
        where driver_available = true
    ) as d
    on m.month = d.month
    group by 1,2
    order by 1,2
)


select
    m.month_num as month
    ,case
        when d.avail_driver_ct = 0 then 0.00
        when d.avail_driver_ct is null then 0.00
        else round((coalesce(a.accepted_driver_ct,0) * 100.00/ d.avail_driver_ct),2)
    end as working_percentage

from date_range_clean m
left join accepted_drivers_months a on m.month_num = a.requested_month_num
left join available_drivers d on m.month_num = d.month_num
order by 1
