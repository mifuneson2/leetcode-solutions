-- 1369. Get the Second Most Recent Activity
-- https://leetcode.com/problems/get-the-second-most-recent-activity/
-- tags: database, hard, no_posted_solution 

-- Write your PostgreSQL query statement below

with ordered_activities as (
        select
        username
        ,activity
        ,startDate
        ,endDate
        ,row_number() over (partition by username order by enddate desc) as activity_order
        ,count(username) over (partition by username) as ttl_activities
    from useractivity
)

select
    username
    ,activity
    ,startDate
    ,endDate
from ordered_activities
where (ttl_activities > 1 and activity_order = 2) 
    or (ttl_activities = 1 and activity_order = 1)
