-- 2010. The Number of Seniors and Juniors to Join the Company II
-- https://leetcode.com/problems/the-number-of-seniors-and-juniors-to-join-the-company-ii/
-- tags: database, hard, no_posted_solution, recursive

-- Write your PostgreSQL query statement below

with recursive candidates_ranked as (
    select
        employee_id
        ,experience
        ,salary
        ,row_number() over (order by experience desc, salary) as hiring_pref
    from candidates
    order by 4
)

,hiring_plan as (
    select
        hiring_pref
        ,employee_id
        ,experience
        ,salary
        ,case
            when salary <= 70000 then true
            else false
        end as to_hire
        ,case
            when salary <= 70000 then 70000-salary
            else 70000
        end as remaining_budget
    from candidates_ranked
    where hiring_pref = 1

    union

    select
        r.hiring_pref
        ,r.employee_id
        ,r.experience
        ,r.salary
        ,case
            when r.salary <= p.remaining_budget then true
            else false
        end as to_hire
        ,case
            when r.salary <= p.remaining_budget 
                then p.remaining_budget - r.salary
            else p.remaining_budget
        end as remaining_budget
    from candidates_ranked r, hiring_plan p
    where r.hiring_pref = p.hiring_pref+1
)

select employee_id
from hiring_plan
where to_hire = true
