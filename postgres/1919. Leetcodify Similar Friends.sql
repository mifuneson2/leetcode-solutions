-- 1919. Leetcodify Similar Friends
-- https://leetcode.com/problems/leetcodify-similar-friends/
-- tags: database, hard

-- Write your PostgreSQL query statement below

with listens_clean as (
    select * from listens
    union
    select * from listens
)
, songs_friends_listened_by_day as (
    select
        l1.song_id
        ,l1.day
        ,f.user1_id
        ,f.user2_id
    from friendship f
    join listens_clean l1 on f.user1_id = l1.user_id
    join listens_clean l2 
        on f.user2_id = l2.user_id
        and l1.song_id = l2.song_id
        and l1.day = l2.day
    order by 1,2,3
)
, common_listens_day as (
    select 
        user1_id
        ,user2_id
        ,day
        ,count(distinct song_id) as songs_listened
    from songs_friends_listened_by_day 
    group by 1,2,3
    order by 1,2,3
)
select 
    user1_id
    ,user2_id
from common_listens_day
where songs_listened >= 3

--union to dedupe in case of multiple days of friends listening to 3 or more common songs
union 

select 
    user1_id
    ,user2_id
from common_listens_day
where songs_listened >= 3
