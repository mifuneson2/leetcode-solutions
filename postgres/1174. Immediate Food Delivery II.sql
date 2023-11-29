
-- Write your PostgreSQL query statement below
select
    round((count(distinct case when d.order_date = d.customer_pref_delivery_date then f.customer_id else null end)::decimal / count(distinct f.customer_id))*100,2) as immediate_percentage


from (
    select customer_id, min(order_date) as first_order_date
    from Delivery
    group by customer_id
) f 
inner join Delivery d 
    on f.customer_id = d.customer_id and f.first_order_date = d.order_date