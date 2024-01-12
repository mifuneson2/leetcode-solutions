-- 1212. Team Scores in Football Tournament
-- https://leetcode.com/problems/team-scores-in-football-tournament/
-- tags: database, medium, no_posted_solution, frequently_asked

-- Write your PostgreSQL query statement below
with match_points as (
    select
        *
        ,case 
            when host_goals > guest_goals then 3
            when host_goals = guest_goals then 1 
            else 0
        end as host_points
        ,case 
            when host_goals < guest_goals then 3
            when host_goals = guest_goals then 1 
            else 0
        end as guest_points
    from matches
)
,team_points as (
    select 
        team_id
        ,sum(points) as num_points
    from (
        select 
            host_team as team_id
            ,host_points as points
        from match_points
        union all
        select
            guest_team as team_id
            ,guest_points as points
        from match_points
    )
    group by 1
)

select t.*
    ,coalesce(p.num_points,0) as num_points
from teams t
left join team_points p on t.team_id = p.team_id
order by 3 desc, 1