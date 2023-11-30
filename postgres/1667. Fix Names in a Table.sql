-- Write your PostgreSQL query statement below
select 
    user_id
    ,upper(left(name,1)) || lower(right(name,-1)) as name
from Users
order by 1