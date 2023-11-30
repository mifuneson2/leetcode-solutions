-- Write your PostgreSQL query statement below

select
    e.reports_to as employee_id
    ,m.name as name
    ,count(1) as reports_count
    ,round(avg(e.age)) as average_age

from Employees e join Employees m on e.reports_to = m.employee_id
group by e.reports_to, m.name
order by e.reports_to