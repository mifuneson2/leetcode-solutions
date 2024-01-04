-- 2346. Compute the Rank as a Percentage
-- https://leetcode.com/problems/compute-the-rank-as-a-percentage/
-- tags: database, medium, no_posted_solution

-- Write your PostgreSQL query statement below

with student_ranks as (
    select 
        student_id
        ,department_id
        ,mark
        ,rank() over (partition by department_id order by mark desc)
        ,count(student_id) over (partition by department_id)
    from students
    order by 2,3 desc
)

select 
    student_id
    ,department_id
    ,case
        when count = 1 then 0 
        else coalesce(round((rank - 1) *100.0 / (count -1 ),2),0) 
    end as percentage
from student_ranks
