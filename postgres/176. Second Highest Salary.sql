-- Write your PostgreSQL query statement below
with salary_ranks as (
    select
        id
        ,salary
        ,dense_rank() over (order by salary desc) as salary_rank
    from Employee
) 

select 
    SecondHighestSalary
from (
    select
        salary as SecondHighestSalary
    from salary_ranks
    where salary_rank = 2

    union 

    select null as SecondHighestSalary
) 
order by SecondHighestSalary asc
limit 1