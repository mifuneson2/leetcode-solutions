-- Write your PostgreSQL query statement below
select 
    d.name as Department
    ,r.name as Employee
    ,r.salary as Salary
from (
    select 
        e.*
        ,dense_rank() over (
            partition by departmentId 
            order by salary desc
        ) as dept_salary_rank
    from Employee e
    order by departmentId, salary desc
) r
left join Department d on r.departmentid = d.id
where r.dept_salary_rank <=3
order by department, salary desc, employee asc