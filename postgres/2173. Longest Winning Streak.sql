-- 2173. Longest Winning Streak
-- https://leetcode.com/problems/longest-winning-streak/
-- tags: database, hard, gaps_and_islands

-- Write your PostgreSQL query statement below
with matches_clean as (
    select 
        *
        ,row_number() over (partition by player_id order by match_day) player_match_num
        ,case
            when result = 'Win' then
                case
                    -- case: first record for the player
                    when lag(result) over (partition by player_id order by match_day) is null
                        then 'start'

                    -- case: previous record (is consecutive) but was not a win
                    when lag(result,1,'start') over 
                        (partition by player_id order by match_day) != 'Win' then 'start'
                                        
                    else 'continue'
                end
            -- lose or draw
        end as streak_start
        ,case
            when result = 'Win' then
                case
                    --case: last match record for the player
                    when lead(result) over
                        (partition by player_id order by match_day) is null then 'end'

                    --case: next match is not a win
                    when lead(result,1,'end') over
                        (partition by player_id order by match_day) != 'Win' then 'end'
                    else 'continue'
                end
        end as streak_end
    from matches
)
, player_streak_starts as (
    select 
        *
        ,row_number() over (partition by player_id order by match_day) as streak_num
    from matches_clean 
    where streak_start = 'start'
), player_streak_ends as (
    select
        *
        ,row_number() over (partition by player_id order by match_day) as streak_num
    from matches_clean
    where streak_end = 'end'
), player_streaks as(
    select
        a.player_id
        ,a.streak_num
        ,a.player_match_num as streak_start_day
        ,b.player_match_num as streak_end_day
        ,b.player_match_num - a.player_match_num + 1 as streak_length
    from player_streak_starts a
    join player_streak_ends b on a.player_id = b.player_id and a.streak_num = b.streak_num
)


select
    p.player_id
    ,coalesce(s.streak_length,0) as longest_streak

from (select distinct player_id from matches) p
left join (
    select distinct on (player_id)
        player_id
        ,streak_length
    from player_streaks
    order by player_id, streak_length desc
) s on p.player_id = s.player_id