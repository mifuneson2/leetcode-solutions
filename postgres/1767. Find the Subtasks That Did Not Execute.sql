-- https://leetcode.com/problems/find-the-subtasks-that-did-not-execute/
-- tags: database, hard

-- Write your PostgreSQL query statement below
with task_subtask as (
    
    select
        task_id
        ,s.num as subtask_id
    from tasks t
    cross join lateral generate_series(1, t.subtasks_count) as s(num)
)

select *
from task_subtask ts
where (ts.task_id, ts.subtask_id)
not in (select task_id, subtask_id from executed)