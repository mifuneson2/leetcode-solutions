-- 571. Find Median Given Frequency of Numbers
-- https://leetcode.com/problems/find-median-given-frequency-of-numbers/
-- tags: database, hard, no_posted_solution, generate_series

-- Write your PostgreSQL query statement below
with uncompressed as (
    SELECT num
    FROM numbers,
        generate_series(1, frequency) AS s
    ORDER BY num
)

select 
    round(percentile_cont(0.5) within group(order by num)::numeric,1) as median 
from uncompressed