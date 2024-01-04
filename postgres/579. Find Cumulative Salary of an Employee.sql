-- 579. Find Cumulative Salary of an Employee
-- https://leetcode.com/problems/find-cumulative-salary-of-an-employee/
-- tags: database, hard, distinct_on, window

-- Write your PostgreSQL query statement below
with most_recent_employee_month as (
    select distinct on (id)
        id, month
    from employee
    order by id, month desc
)
,report_months as (
    select generate_series(1, 12) as month
)
, employee_month_salaries as (
    select 
        e.id
        ,r.month
        ,s.salary
    from report_months r cross join (select distinct id from employee) e
    left join employee s on e.id = s.id and r.month = s.month
    order by 1,2
)
, cum_employee_month_salaries as (
    select
        id
        ,month
        ,salary
        ,sum(salary) over 
            (partition by id order by month desc rows between current row and 2 following) 
            as cum_salary

    from employee_month_salaries
    order by id, month desc
)

select
    id
    ,month
    ,cum_salary as salary
from cum_employee_month_salaries
where salary is not null
and (id, month) not in (select id, month from most_recent_employee_month)