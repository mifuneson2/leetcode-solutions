-- 1892. Page Recommendations II
-- https://leetcode.com/problems/page-recommendations-ii/
-- tags: database, hard, no_posted_solution

-- Write your PostgreSQL query statement below

with friendship_expanded as (
    select user1_id, user2_id from friendship
    union
    select user2_id, user1_id from friendship

    --order by 1,2  --comment out to improve perf
)

,like_pages_friends as (
    select
        l1.page_id as page_id
        ,l1.user_id as liking_user
        ,f.user2_id as likers_friend_id
        ,l2.page_id as u2_page_id
       
    from likes l1
    join friendship_expanded f on f.user1_id = l1.user_id
    left join likes l2 on f.user2_id = l2.user_id and l1.page_id = l2.page_id
    
    --order by 1,2,3,4  --comment out to improve perf
)
, friends_page_recos as (
    select 
        likers_friend_id
        ,page_id
        ,liking_user

    from like_pages_friends
    where u2_page_id is null
    --order by 1,2,3 --comment out to improve perf
)
,users_recommended_pages as (
    select
        likers_friend_id as user_id
        ,page_id
        ,count(distinct liking_user) as friends_likes
    from friends_page_recos
    group by 1,2
    --order by 1,2 --comment out to improve perf
)

select *
from users_recommended_pages