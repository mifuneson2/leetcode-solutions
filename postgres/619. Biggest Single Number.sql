-- Write your PostgreSQL query statement below

select num from (
select
    num
    --,count(num) as num_ct
from MyNumbers
group by num
having count(num) = 1
order by num desc
limit 1
)

union 
--buffer a null if no results returned, should use a max(num) function instead for future problems
select null as num 

order by num asc
limit 1