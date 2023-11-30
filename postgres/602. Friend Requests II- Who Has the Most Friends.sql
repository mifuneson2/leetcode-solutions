-- Write your PostgreSQL query statement below
with friender as (
    select requester_id as user from RequestAccepted
    union
    select accepter_id as user from RequestAccepted
), friendships as (
    select 
        requester_id as friend1, accepter_id as friend2
    from RequestAccepted
    union
    select
        accepter_id as friend1, requester_id as friend2
    from RequestAccepted
)

select 
    friend1 as id
    ,count(1) as num
from friendships
group by friend1
order by num desc
limit 1