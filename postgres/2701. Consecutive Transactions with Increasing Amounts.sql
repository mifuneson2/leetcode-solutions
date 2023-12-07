-- problem at https://leetcode.com/problems/consecutive-transactions-with-increasing-amounts/ 

-- tag:database, hard, 23% acceptance rates

-- Write your PostgreSQL query statement below

with enrichedtransactions as (
    select
        customer_id
        ,transaction_id
        ,transaction_date 
        ,amount
        ,lag(amount) over (partition by customer_id order by transaction_date) as prev_amount
        ,lead(amount) over (partition by customer_id order by transaction_date) as next_amount
        ,lag(transaction_date) over (partition by customer_id order by transaction_date) as prev_date
        ,lead(transaction_date) over (partition by customer_id order by transaction_date) as next_date
    from
        transactions
    order by customer_id, transaction_date, amount
)
,seperatedtransactions as (
    select
        customer_id
        ,transaction_id
        ,transaction_date
        ,amount
        ,prev_amount
        ,case
            when prev_date is null then 'start'
            when next_date is null then 'end'
            when prev_date +1 = transaction_date and amount > prev_amount and transaction_date+1 != next_date then 'end'
            when prev_date +1 = transaction_date and amount > prev_amount and amount >= next_amount then 'end'
            when prev_date +1 = transaction_date and amount > prev_amount 
             and transaction_date +1 = next_date and amount < next_amount then 'continue'
            else 'start'
         end as era_start_boundary
         ,case
            when next_date is null then 'end'
            when transaction_date+1 != next_date then 'end'
            when transaction_date+1 = next_date and amount >= next_amount then 'end'
            else 'continue'
        end as era_end_boundary
    from
        enrichedtransactions
)
,era_boundary_start as (
    select  customer_id
            ,transaction_id
            ,transaction_date as era_start_date
            ,row_number() over (partition by customer_id order by transaction_date) as grp_id
    from seperatedtransactions
    where era_start_boundary = 'start'
    group by 1,2,3
    order by 1,2,3
)
,era_boundary_end as (
    select  customer_id
            ,transaction_id
            ,transaction_date as era_end_date
            ,row_number() over (partition by customer_id order by transaction_date) as grp_id
    from seperatedtransactions
    where era_end_boundary = 'end'
    group by 1,2,3
    order by 1,2,3
)

,era_boundaries as (
    select 
        e.customer_id
        ,e.grp_id
        ,e.era_start_date
        ,f.era_end_date
    from era_boundary_start e
    join era_boundary_end f on e.customer_id = f.customer_id and e.grp_id = f.grp_id
)
,flagged_transactions as (
    select
        a.customer_id
        ,b.grp_id
        ,b.era_start_date
        ,b.era_end_date
        ,count(1) as consecutive_days
    from  Transactions a 
    join era_boundaries b 
        on a.customer_id = b.customer_id 
        and a.transaction_date >= b.era_start_date and a.transaction_date <= b.era_end_date
    group by 1,2,3,4
    order by 1,2,3,4
)

select
    customer_id
    ,era_start_date as consecutive_start
    ,era_end_date as consecutive_end
from flagged_transactions
where consecutive_days >= 3
order by customer_id, consecutive_start
;
