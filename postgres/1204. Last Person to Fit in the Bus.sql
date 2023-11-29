-- Write your PostgreSQL query statement below
with cte as (
    select
        q.turn
        ,q.person_id
        ,q.person_name
        ,q.weight 
        ,sum(q.weight) over (order by q.turn asc) as total_weight
    from Queue q
    order by turn
)
select 
    person_name
from cte
where total_weight <= 1000
order by turn desc
limit 1
