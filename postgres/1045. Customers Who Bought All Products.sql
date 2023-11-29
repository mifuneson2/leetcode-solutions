-- Write your PostgreSQL query statement below

select
    t.customer_id as customer_id

from (
    select
        c.customer_id as customer_id
        ,count (distinct p.product_key) as ttl_product_ct
        ,count (distinct cp.product_key) as purchased_product_ct
    from 
    (select distinct customer_id
    from Customer) c
    cross join Product p
    left join Customer cp on c.customer_id = cp.customer_id and p.product_key = cp.product_key 
    group by c.customer_id
) t
where t.ttl_product_ct = t.purchased_product_ct