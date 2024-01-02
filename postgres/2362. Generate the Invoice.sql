-- 2362. Generate the Invoice
-- https://leetcode.com/problems/generate-the-invoice/
-- tags: database, hard, no_posted_solution 

-- Write your PostgreSQL query statement below

with purchase_cost as (
    select
        u.invoice_id
        ,u.product_id
        ,u.quantity
        ,r.price as product_price
        ,r.price * u.quantity as cost
    from purchases u
    join products r on u.product_id = r.product_id
)
,invoice_totals as (
    select
        invoice_id
        ,sum(cost) as invoice_cost
        ,row_number() over (order by sum(cost) desc, invoice_id) as invoice_rank
    from purchase_cost
    group by 1
)

select 
    product_id
    ,quantity
    ,cost as price
from purchase_cost
where invoice_id in (select invoice_id from invoice_totals where invoice_rank = 1)