-- 2474. Customers With Strictly Increasing Purchases
-- https://leetcode.com/problems/customers-with-strictly-increasing-purchases/
-- tags: database, hard, no_posted_solution

-- Write your PostgreSQL query statement below

with yearly_purchases as (
    select 
        customer_id
        ,date_part('year', order_date) as purchase_year
        ,sum(price) as purchases
    from orders
    group by 1,2
    order by 1,2
)
, analysis as (
    select
        customer_id
        ,purchase_year
        ,purchases
        ,case
            when purchases > lag(purchases,1,0) over (partition by customer_id order by purchase_year) 
                then 1
            else 0
        end as increased_purchases
    from yearly_purchases
)
,summary as (
    select 
        customer_id
        ,max(purchase_year) - min(purchase_year) + 1 as customer_lifetime_years
        ,sum(increased_purchases) as increasing_years
    from analysis
    group by 1
)
select customer_id
from summary
where increasing_years = customer_lifetime_years