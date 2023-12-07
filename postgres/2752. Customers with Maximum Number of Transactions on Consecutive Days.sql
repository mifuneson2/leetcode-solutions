--from: https://leetcode.com/problems/customers-with-maximum-number-of-transactions-on-consecutive-days/description/
--tags: hard, 35% acceptance

-- Write your PostgreSQL query statement below
with enriched_transactions as (

    select 
        *
        ,lag(transaction_date) over (partition by customer_id order by transaction_date) as prev_date
        ,lead(transaction_date) over (partition by customer_id order by transaction_date) as next_date
        ,case 
            when lag(transaction_date) over (partition by customer_id order by transaction_date) is null then 'start'
            when transaction_date - lag(transaction_date) over (partition by customer_id order by transaction_date) > 1 then 'start'
            else 'continue'
        end as run_start 
        ,case 
            when lead(transaction_date) over (partition by customer_id order by transaction_date) is null then 'end'
            when lead(transaction_date) over (partition by customer_id order by transaction_date) - transaction_date > 1 then 'end'
            else 'continue'
        end as run_end
    from transactions
    order by customer_id, transaction_date
)
, run_start as (
    select
        *
        , row_number() over (partition by customer_id order by transaction_date) as run_num
    from enriched_transactions
    where run_start = 'start'
    order by customer_id, transaction_date
)
, run_end as (
    select
        *
        , row_number() over (partition by customer_id order by transaction_date) as run_num
    from enriched_transactions
    where run_end = 'end'
    order by customer_id, transaction_date
),
run_duration as (
    select
        a.customer_id
        ,a.run_num
        ,a.transaction_date as run_start_date
        ,b.transaction_date as run_end_date
    from run_start a
    join run_end b on a.customer_id = b.customer_id and a.run_num = b.run_num

)
, consecutive_transactions as (
    select
        t.customer_id
        ,r.run_num
        ,count(1) as consecutive_days
    from transactions t 
    join run_duration r 
        on t.customer_id = r.customer_id 
        and t.transaction_date >= r.run_start_date
        and t.transaction_date <= r.run_end_date
    group by t.customer_id, r.run_num
    order by t.customer_id, r.run_num
) 
, ranked_customer as (
    select 
        *
        ,rank() over (order by consecutive_days desc) as rank
    from consecutive_transactions
)

select customer_id
from ranked_customer
where rank = 1
order by customer_id
