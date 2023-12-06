-- problem url: https://leetcode.com/problems/human-traffic-of-stadium/description/

-- Write your PostgreSQL query statement below
with filter_rows as (
    select id, visit_date, people
    from Stadium
    where people >= 100
    order by id asc
), leading_row_id as (
    select 
        a.id as d1
        ,b.id as d2
        ,c.id as d3
    from filter_rows a 
    join filter_rows b on b.id = a.id+1
    join filter_rows c on c.id = a.id+2
), selected_ids as (
    select d1 as id from leading_row_id
    union
    select d2 as id from leading_row_id
    union
    select d3 as id from leading_row_id
)

select *
from Stadium
where id in (select * from selected_ids);
