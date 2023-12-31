-- 1225. Report Contiguous Dates
-- https://leetcode.com/problems/report-contiguous-dates/description/
-- tags: database, hard

-- Write your PostgreSQL query statement below


with combined_log as (
    select 
        success_date as job_date
        ,'succeeded' as job_status
    from succeeded
    where success_date between date'2019-01-01' and date'2019-12-31'

    union
    
    select
        fail_date as job_date
        ,'failed' as job_status
    from failed
    where fail_date between date'2019-01-01' and date'2019-12-31'

    order by 1
)
,status_changes as (
    select
        job_date,
        job_status,
        case 
            when lag(job_status) over (order by job_date) = job_status then 0
            else 1
        end as status_change
    from combined_log
)
,grouped_status as (
    select
        job_status,
        job_date,
        sum(status_change) over (order by job_date) as group_id
    from status_changes
)

select
    job_status as period_state,
    min(job_date) as start_date,
    max(job_date) as end_date
from grouped_status
group by job_status, group_id
order by start_date;
