-- from: https://leetcode.com/problems/the-number-of-seniors-and-juniors-to-join-the-company/
-- tags: database, hard

-- Write your PostgreSQL query statement below
with senior_employees_cum_salaries as (
    select
        experience
        ,employee_id
        ,salary
        ,sum(salary) over (order by salary asc, employee_id) as cum_salary
    from candidates
    where experience = 'Senior'
)
,junior_employees_cum_salaries as (
    select
        experience
        ,employee_id
        ,salary
        ,sum(salary) over (order by salary asc, employee_id) as cum_salary
    from candidates
    where experience = 'Junior'
)
, hired_seniors as (
    select 
        *
    from senior_employees_cum_salaries
    where cum_salary <= 70000
)
, junior_budget as (
    select 70000 - coalesce(
            (select cum_salary 
            from hired_seniors 
            order by cum_salary desc 
            limit 1)
        ,0) as junior_budget
)
,hired_juniors as (

    select 
        *
    from junior_employees_cum_salaries
    where cum_salary <= (select junior_budget from junior_budget)
)

select 
    'Senior' as experience
    ,(select count(1) from hired_seniors) as accepted_candidates

union

select
    'Junior' as experience 
    ,(select count(1) from hired_juniors) as accepted_candidates

order by experience desc
