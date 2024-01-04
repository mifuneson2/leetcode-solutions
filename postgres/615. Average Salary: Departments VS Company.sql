-- 615. Average Salary: Departments VS Company
-- https://leetcode.com/problems/average-salary-departments-vs-company/
-- tags: database, hard

-- Write your PostgreSQL query statement below

with employee_month_salary as (
    select
        date_trunc('month',s.pay_date) as pay_month
        ,e.department_id
        ,s.employee_id
        ,s.amount
    from salary s
    join employee e on s.employee_id = e.employee_id
    order by 1,2,3,4
)

,company_monthly_salary as (
    select
        pay_month
        ,sum(amount) * 1.00 / count(employee_id) as co_avg_salary
    from employee_month_salary
    group by 1
    order by 1
)        

select
    to_char(c.pay_month, 'yyyy-mm') as pay_month
    ,e.department_id
    ,case
        when e.dp_avg_salary > c.co_avg_salary then 'higher'
        when e.dp_avg_salary < c.co_avg_salary then 'lower'
        when e.dp_avg_salary = c.co_avg_salary then 'same'
        else 'no info'
    end as comparison
from company_monthly_salary c
left join (
    select 
        pay_month
        ,department_id
        ,sum(amount) * 1.00 / count(employee_id) as dp_avg_salary
    from employee_month_salary e
    group by 1,2
) e on c.pay_month = e.pay_month 