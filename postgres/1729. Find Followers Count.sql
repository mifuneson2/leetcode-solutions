-- Write your PostgreSQL query statement below
select
    user_id
    ,count(1) as followers_count
from Followers
group by 1
order by user_id