-- 614. Second Degree Follower
-- https://leetcode.com/problems/second-degree-follower/
-- tags: database, medium, no_posted_solution

-- Write your PostgreSQL query statement below

select 
    a.followee as follower
    ,count(a.follower) as num
from follow a
where followee in (select distinct follower from follow b)
group by 1
order by 1
