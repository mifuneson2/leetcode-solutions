-- Write your PostgreSQL query statement below
select 
    sell_date
    ,count(1) as num_sold
    ,string_agg(product, ',') as products

from (
    --use union to quickly dedupe rows
    select sell_date, product
    from Activities
    union 
    select sell_date, product
    from Activities
    order by sell_date, product
)

group by sell_date
order by sell_date asc, products asc