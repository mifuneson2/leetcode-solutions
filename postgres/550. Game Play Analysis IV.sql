-- Write your PostgreSQL query statement below

SELECT 
    round(count(distinct next_player_id) / count(distinct player_id)::decimal,2) as fraction 
    --,count(distinct prior_player_id) as consec_player_ct
    --,count(distinct player_id) as ttl_player_ct

FROM (
    select t.player_id as player_id
         , t.event_date as login_date
         , m.player_id as next_player_id
         , m.event_date as next_login_date
         , dense_rank() over (
             partition by t.player_id
             order by t.event_date
           ) as login_num
    from Activity t left join Activity m
    on (t.player_id = m.player_id) and (m.event_date - t.event_date = 1)
)
where login_num = 1
