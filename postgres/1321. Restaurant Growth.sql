-- Write your PostgreSQL query statement below

with daily_sales as (
    select
        visited_on
        ,sum(amount) as amount
    from Customer
    group by visited_on
    order by visited_on
), mv_avg_sales as (
    select
    visited_on
    ,sum(amount) over (order by visited_on rows between 6 preceding and current row) as amount
    ,round(
        sum(amount) over (order by visited_on rows between 6 preceding and current row)::decimal / 7
        ,2
    ) as average_amount
    from daily_sales
)

select 
    *
from mv_avg_sales
where visited_on >= (select min(visited_on) from Customer)+6
order by visited_on asc