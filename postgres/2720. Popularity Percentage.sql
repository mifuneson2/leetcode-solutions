-- 2720. Popularity Percentage
-- https://leetcode.com/problems/popularity-percentage/
-- tags: database, hard, union_dedupe

-- Write your PostgreSQL query statement below

with friendships_expanded as (
    select user1, user2 from friends
    union
    select user2, user1 from friends
)
,total_friends as (
    select count(distinct user1) as ttl_platform_users
    from friendships_expanded
)

select 
    user1
    ,round(coalesce(friend_ct * 100.0 / ttl_platform_users,0),2) as percentage_popularity
from (
    select 
        user1
        ,count(distinct user2) as friend_ct
    from friendships_expanded
    group by 1
    order by 1
) cross join total_friends
