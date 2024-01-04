-- 1159. Market Analysis II
-- https://leetcode.com/problems/market-analysis-ii/
-- tags: database, hard

/* NB - the description is incorrect, the actual question (as determined by test cases) should be:
"Write an sql query to find for each seller, whether the brand of second item (by date) they sold is their favorite brand. if seller sold less than 2 items then report answer as no"
*/

-- Write your PostgreSQL query statement below

with user_sales_ranked as(
    select
        u.user_id as seller_id
        ,u.favorite_brand
        ,o.order_id
        ,o.order_date
        ,o.item_id
        ,i.item_brand
        ,row_number() over (partition by u.user_id order by order_date) as sales_seq
    from users u 
    left join orders o on u.user_id = o.seller_id
    left join items i on o.item_id = i.item_id
)

select 
    u.user_id as seller_id
    ,case
        when sales_seq is null then 'no'
        when r.favorite_brand = r.item_brand then 'yes'
        else 'no'
    end as "2nd_item_fav_brand"

 from users u
 left join user_sales_ranked r on u.user_id = r.seller_id and sales_seq = 2
 