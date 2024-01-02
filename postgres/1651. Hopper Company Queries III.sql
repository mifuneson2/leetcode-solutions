-- 1651. Hopper Company Queries III
-- https://leetcode.com/problems/hopper-company-queries-iii/
-- tags: database, hard, no_posted_solution, generate_series, window

-- Write your PostgreSQL query statement below
with report_months as (
    select
        generate_series( date'2020-01-01'
                        ,date'2020-12-01'
                        ,interval'1 month'
        ) as month
)

,monthly_stats as (
    select
        date_trunc('month', r.requested_at) as ride_month
        ,sum(a.ride_distance) as distance
        ,sum(a.ride_duration) as duration
        ,count(a.ride_id) as ride_cts
    from acceptedrides a
    join rides r on a.ride_id = r.ride_id
    group by 1
    order by 1
)

,filtered_month_stats as (
    select 
        r.month
        ,coalesce(s.distance,0) as distance
        ,coalesce(s.duration,0) as duration
        ,s.ride_cts
    from report_months r
    left join monthly_stats s on r.month = s.ride_month
)
, report_dataset as (
    select
        date_part('month', month) as month
        ,round(
            sum(distance) over (order by month rows between current row and 2 following)/3
            ,2
        ) as average_ride_distance
        ,round(
            sum(duration) over (order by month rows between current row and 2 following)/3
            ,2
        ) as average_ride_duration
    from filtered_month_stats
    order by month
    limit 10
)

select * from report_dataset