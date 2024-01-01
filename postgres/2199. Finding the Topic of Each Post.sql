-- 2199. Finding the Topic of Each Post
-- https://leetcode.com/problems/finding-the-topic-of-each-post/
-- tags: database, hard, no_posted_solution

-- Write your PostgreSQL query statement below

with content_topic_matches as (
    select 
        post_id
        ,content
        ,topic_id
        ,word
    from posts p
    left join keywords k on p.content ~* ('\m' || k.word || '\M') -- use regex to join
)
,matches_deduped as (
    select post_id, topic_id from content_topic_matches
    union
    select post_id, topic_id from content_topic_matches
    order by 1,2
)

select 
    post_id
    ,coalesce(
        string_agg(topic_id::varchar, ',') 
        , 'Ambiguous!') as topic
from matches_deduped
group by 1
order by post_id