-- 1336. Number of Transactions per Visit
-- https://leetcode.com/problems/number-of-transactions-per-visit/
-- tags: database, hard, no_posted_solution, generate_series

-- Write your PostgreSQL query statement below

with visits_transactions as (
    select 
        v.user_id
        ,v.visit_date
        ,count(t.user_id) as transactions_count
    from visits v
    left join transactions t on v.user_id = t.user_id and v.visit_date = t.transaction_date
    group by 1,2
    order by 1,2
)
, transaction_visit_freq as (
    select 
        transactions_count
        ,count(user_id) as visits_count
    from visits_transactions
    group by 1
    order by 1
)
, txn_range as (
    select generate_series(0, MAX(transactions_count)) as transactions_count
    from transaction_visit_freq
)

select 
    r.transactions_count
    ,coalesce(visits_count,0) as visits_count
from txn_range r
left join transaction_visit_freq t on  r.transactions_count =  t.transactions_count 
