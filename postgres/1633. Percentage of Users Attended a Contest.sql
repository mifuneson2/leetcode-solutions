-- Write your PostgreSQL query statement below
with ttl_users as (
    select count (distinct user_id) as user_ttl 
    from Users

),
contest_cts as (
    select
        contest_id
        ,count(distinct user_id) as contest_ct
    from Register
    group by 1
    order by 1
)

select 
    c.contest_id
    ,round(c.contest_ct * 100.0 / t.user_ttl,2) as percentage
from contest_cts c
cross join ttl_users t
order by 2 desc, 1 asc

