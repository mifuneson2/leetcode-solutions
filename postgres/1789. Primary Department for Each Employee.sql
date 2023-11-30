-- Write your PostgreSQL query statement below
with ranked_departments as (
    select 
        employee_id
        ,department_id
        ,row_number() over (partition by employee_id order by primary_flag desc) as row_num

    from Employee
), multi_department_employees as (
    select
        employee_id
        ,count(department_id) as dept_ct
        ,sum(case when primary_flag = 'Y' then 1 else 0 end) as primary_dept_flags
    from Employee
    group by 1
    order by 1
)

select
    employee_id
    ,department_id
from ranked_departments
where row_num = 1
and employee_id not in (
    --remove edge case of employees with multiple departments but none are primary
    select employee_id
    from multi_department_employees
    where dept_ct > 1
    and primary_dept_flags < 1
)