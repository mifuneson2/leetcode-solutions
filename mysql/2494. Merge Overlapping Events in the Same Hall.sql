# from https://leetcode.com/problems/merge-overlapping-events-in-the-same-hall/
# tags: database, hard

# Write your MySQL query statement below
with hallevents_clean as (

    -- create a clean dataset that removes duplicates and assigns an id to each of the events
    select 
        a.*
        ,row_number() over(order by hall_id, start_day) as event_id 
    from (
        select * from hallevents
        union -- union function dedupes rows
        select * from hallevents
    ) a
    order by hall_id, start_day
)
,overlapped_events as (
    select
        a.hall_id
        ,a.event_id as a_event_id
        ,a.start_day as a_start_day
        ,a.end_day as a_end_day
        ,b.event_id as b_event_id
        ,b.start_day as b_start_day
        ,b.end_day as b_end_day
    from hallevents_clean a
    left join hallevents_clean b 
        on a.hall_id = b.hall_id 
        and a.start_day < b.start_day 
        #and a.end_day <= b.end_day 
        and b.start_day<= a.end_day
)

,session_prior_end as (
    select
        *       
        ,max(end_day) over (PARTITION by hall_id 
                    order by start_day, end_day 
                    rows between unbounded preceding and 1 preceding) as latest_prior_end
    from hallevents_clean
)
/*
,session_subsequent_start as (
    select 
        *
        ,max
    
)*/


, session_breaks as (
    select
        *
        ,case
            when latest_prior_end is null then 'start'
            when start_day > latest_prior_end then 'start'
            else 'continue'
        end as new_session_start
    from session_prior_end
) 
, session_starts as (
    select 
        hall_id
        ,event_id
        ,start_day
        ,lead(start_day) over (partition by hall_id order by start_day) as next_session_start
        ,row_number() over (partition by hall_id order by start_day) as hall_event_nm
    from session_breaks
    where new_session_start = 'start'
)
, candidate_end_days as (
    select
        s.hall_id
        ,s.hall_event_nm
        ,s.start_day
        ,h.event_id as end_event_id
        ,h.start_day as can_start_day
        ,h.end_day
        ,row_number() over (partition by s.hall_id, hall_event_nm order by h.end_day desc) as latest_end_day
    from session_starts s
    join hallevents_clean h
        on s.hall_id = h.hall_id
        and s.start_day < h.end_day
        and s.start_day <= h.start_day
        and (h.end_day < s.next_session_start or s.next_session_start is null)
    order by s.hall_id,s.hall_event_nm,h.end_day desc
)



select 
    hall_id
    ,start_day
    ,end_day

from candidate_end_days
where latest_end_day = 1
order by hall_id