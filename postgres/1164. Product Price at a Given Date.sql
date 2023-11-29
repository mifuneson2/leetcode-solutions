-- Write your PostgreSQL query statement below
with cte as (
    select
        product_id
        ,new_price
        ,change_date
        ,dense_rank() over (partition by product_id order by change_date desc) as mrp
    from Products
    where change_date <= date'2019-08-16'
    order by product_id, change_date desc
)
, product_list as (select distinct product_id from Products order by product_id) 

select
    pl.product_id
    ,coalesce(cte.new_price, 10) as price

from product_list pl 
left join cte on cte.product_id = pl.product_id and cte.mrp = 1