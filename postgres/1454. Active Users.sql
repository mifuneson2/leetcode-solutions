-- 1454. Active Users
-- https://leetcode.com/problems/active-users/
-- tags: database, medium, no_posted_solution, gap_and_island

-- Write your PostgreSQL query statement below

with logins_deduped as (
    select * from logins
    union
    select * from logins
)

, user_login_days as (
    select 
        *
        ,row_number() over (partition by id order by login_date) as rn
        from logins_deduped
)
,user_login_groups as (
    select 
        *
        ,login_date - date'2000-01-01' - rn as lgroup
    from user_login_days
)

,login_groups as (
    select
        id
        ,lgroup
        ,min(login_date) as start_date
        ,max(login_date) as end_date
        ,max(login_date) - min(login_date) + 1  as consec_days
    from user_login_groups
    group by id, lgroup
)


select id, name 
from accounts 
where id in (
    select distinct id from login_groups where consec_days >= 5
)
order by id