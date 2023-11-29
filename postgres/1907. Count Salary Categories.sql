-- Write your PostgreSQL query statement below
with salary_cat as (
    select category
        from  (
            values ('Low Salary'), ('Average Salary'), ('High Salary')
        ) s(category)
)

select
    s.category
    ,coalesce(count(a.account_id),0) as accounts_count
from salary_cat s
left join (
    select 
        account_id
        ,case 
            --when income is null then 'Low Salary'
            when income < 20000 then 'Low Salary'
            when income <= 50000 then 'Average Salary'
            else 'High Salary'
        end as salary_category
    from Accounts
) a on s.category = a.salary_category
group by s.category