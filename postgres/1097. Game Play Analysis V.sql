-- 1097. Game Play Analysis V
-- https://leetcode.com/problems/game-play-analysis-v/
-- tags: database, hard, distinct_on

-- Write your PostgreSQL query statement below
with player_day1_retention as (
    select
        d1.player_id
        ,d1.event_date as install_dt
        ,case
            when d2.player_id is null then 0
            else 1
        end as d1_retained
    from (
        select distinct on (player_id)
            player_id
            ,event_date
        from activity
        order by player_id, event_date
    ) d1
    left join activity d2 on d1.player_id = d2.player_id and d2.event_date = d1.event_date + 1
)
    
select 
    install_dt
    ,count(player_id) as installs
    ,round(coalesce(sum(d1_retained) * 1.00 / count(player_id) , 0),2) as "Day1_retention"
from player_day1_retention
group by 1
order by 1