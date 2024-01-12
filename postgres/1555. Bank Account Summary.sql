-- 1555. Bank Account Summary
-- https://leetcode.com/problems/bank-account-summary/
-- tags: database, medium, no_posted_solution, frequently_asked

-- Write your PostgreSQL query statement below


with paid_by_xacts as (
    select 
        paid_by
        ,sum(amount) as debits
        from transactions
        group by 1
)
,paid_to_xacts as (
    select
        paid_to
        ,sum(amount) as credits
        from transactions
        group by 1
)
,reconcile_table as (
    select
        u.user_id
        ,u.user_name
        ,u.credit as starting_balance
        ,coalesce(d.debits,0) as debits
        ,coalesce(c.credits,0) as credits
        ,u.credit - coalesce(d.debits,0) + coalesce(c.credits,0) as credit
        ,case 
            when (u.credit - coalesce(d.debits,0) + coalesce(c.credits,0)) < 0 then 'Yes'
            else 'No'
        end as credit_limit_breached
    from users u
    left join paid_by_xacts d on u.user_id = d.paid_by
    left join paid_to_xacts c on u.user_id = c.paid_to
)

select 
    user_id
    ,user_name
    ,credit
    ,credit_limit_breached
from reconcile_table
