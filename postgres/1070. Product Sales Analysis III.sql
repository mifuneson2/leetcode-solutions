-- Write your PostgreSQL query statement below

select 
    s.product_id
    ,s.year as first_year
    ,s.quantity
    ,s.price


from Sales s
where (s.product_id, s.year /*, s.sale_id*/)
in (
    select product_id, min(year)--, min(sales_id)
    from Sales
    group by product_id
)

