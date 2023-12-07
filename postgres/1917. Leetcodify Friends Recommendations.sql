-- Write your PostgreSQL query statement below
with daily_user_pair_listens as(
    select 
        a.day
        ,a.song_id
        ,a.user_id as user1_id
        ,b.user_id as user2_id
    from listens a join listens b
    on a.day = b.day
    and a.song_id = b.song_id
    and a.user_id != b.user_id
)
, daily_s as (
    select
        user1_id
        ,user2_id
        ,day
        ,count(distinct song_id) as matched_song_ct
    from daily_user_pair_listens
    group by 1,2,3
    having (count(distinct song_id) >= 3)
    order by 1,2,3
)
,friendship_pairs as (
    select a.user1_id, a.user2_id from Friendship a
    union
    select b.user2_id as user1_id, b.user1_id as user2_id from Friendship b
)


select 
    distinct user1_id as user_id
    ,user2_id as recommended_id
from daily_s a
where (a.user1_id, a.user2_id) not in (
    select user1_id, user2_id
    from friendship_pairs
)


