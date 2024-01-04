-- 1635. Hopper Company Queries I
-- https://leetcode.com/problems/hopper-company-queries-i/
-- tags: database, hard

-- Write your PostgreSQL query statement below

with report_months as (
    select generate_series(date'2020-01-01', date'2020-12-01', '1 month'::interval) as month 
)
,driver_active_months as (
    select
        d.driver_id
        ,d.join_date
        ,date_trunc('month', d.join_date) as join_month
        ,r.month
        ,case
            when r.month >= date_trunc('month', d.join_date) then 1 
        else 0 end as driver_active
        from drivers d cross join report_months r
)
,monthly_active_drivers as (
    select 
        month
        ,sum(driver_active) as active_drivers
    from driver_active_months
    group by 1
    order by 1
)
,monthly_accepted_rides as (
    select
        date_trunc('month', r.requested_at) as month
        ,count(a.ride_id) as accepted_rides
    from rides r
    join acceptedrides a on r.ride_id = a.ride_id
    and requested_at between date'2020-01-01' and date'2020-12-31'
    group by 1
    order by 1
)


select
    date_part('month', d.month) as month
    ,d.active_drivers
    ,coalesce(r.accepted_rides,0) as accepted_rides
from monthly_active_drivers d 
left join monthly_accepted_rides r on d.month = r.month
order by 1