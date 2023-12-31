-- 569. Median Employee Salary
-- https://leetcode.com/problems/median-employee-salary/
-- tags: database, hard

-- Write your PostgreSQL query statement below
with employees_ranked as (
    select
        company
        ,id
        ,salary
        ,row_number() over (partition by company order by salary,id) as salary_rank
        ,count(id) over (partition by company) as company_employee_ct
    from employee
)
, mid_employees as (
    select
        company
        ,id
        ,salary
        ,salary_rank
        ,company_employee_ct
        ,case
            when company_employee_ct % 2 = 1 then 'odd'
            else 'even'
        end as median_type
        ,case
            when company_employee_ct % 2 = 1
                --odd number, single median
                then (company_employee_ct + 1) / 2 
            
            else 
                --even, first median
                company_employee_ct/2
        end as median_rec_one
        ,case
            when company_employee_ct % 2 = 1
                --odd number, single median
                then (company_employee_ct + 1) / 2 
            
            else 
                --even, first median
                company_employee_ct/2 + 1
        end as median_rec_two

    from employees_ranked
)

select 
    id
    ,company
    ,salary
from mid_employees
where salary_rank = median_rec_one
    or salary_rank = median_rec_two