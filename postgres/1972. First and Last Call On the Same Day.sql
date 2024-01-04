-- 1972. First and Last Call On the Same Day
-- https://leetcode.com/problems/first-and-last-call-on-the-same-day/
-- tags: database, hard, window, 

-- Write your PostgreSQL query statement below

with conversations as (
    select 
        caller_id as caller1_id
        ,recipient_id as caller2_id
        ,call_time
        ,date_trunc('day', call_time) as call_date
    from calls
    union

    select 
        recipient_id as caller1_id
        ,caller_id as caller2_id
        ,call_time
        ,date_trunc('day', call_time) as call_date
    from calls
)
, ordered_convos as (
    select caller1_id
        ,call_date
        ,call_time
        ,caller2_id
        ,row_number() over (partition by caller1_id, call_date order by call_time) as call_seq
        ,row_number() over (partition by caller1_id, call_date order by call_time desc) as call_seq_end
    from conversations
    order by 1,2
)

select
    distinct o1.caller1_id as user_id
/*    ,o1.call_date
    ,o1.caller2_id
    ,o2.caller2_id */

from ordered_convos o1
join ordered_convos o2
on o1.caller1_id = o2.caller1_id
    and o1.call_date = o2.call_date
    and o1.call_seq = 1
    and o2.call_seq_end = 1
    and o1.caller2_id = o2.caller2_id