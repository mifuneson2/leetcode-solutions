-- Write your PostgreSQL query statement below
select
    activity_date as day
    ,count(distinct user_id) as active_users
from Activity
where activity_date <= date'2019-07-27'
and date'2019-07-27' - activity_date < 30
group by activity_date
