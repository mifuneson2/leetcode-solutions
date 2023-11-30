-- Write your PostgreSQL query statement below
select
    product_name
    ,sum(unit) as unit
from Orders join Products on Orders.product_id = Products.product_id
where date_trunc('month',order_date) = date'2020-02-01'
group by product_name
having sum(unit) >= 100