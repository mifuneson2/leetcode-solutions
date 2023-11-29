-- Write your PostgreSQL query statement below
select 
    r.product_id
    ,coalesce(round(sum(r.sales) / sum(r.units)::decimal,2),0) as average_price
from (
    select 
        r.product_id, s.purchase_date, s.units
        , p.price
        , s.units * p.price as sales 
    from (select distinct product_id from Prices order by product_id) r
    left join UnitsSold S on r.product_id = s.product_id
    left join Prices P 
    on s.product_id = p.product_id 
    and s.purchase_date between p.start_date and p.end_date
) r
group by r.product_id;