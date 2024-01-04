-- 618. Students Report By Geography
-- https://leetcode.com/problems/students-report-by-geography/
-- tags: database, hard, no_posted_solution, distinct_on, generate_series 

-- Write your PostgreSQL query statement below
with students_ordered as (
    select
        continent
        ,name
        ,row_number() over (partition by continent order by name) as c_rank
    from student
)
,
--find the max rows (should be americas but can generalize)
generate_rows as (
    select generate_series(1, max(c_rank)) as row_num
        from (
            select distinct on (continent) continent, c_rank
            from students_ordered
            order by continent, c_rank desc
        )
)

select
    a.name as America
    ,b.name as Asia
    ,c.name as Europe
from generate_rows r
left join students_ordered a on r.row_num = a.c_rank and a.continent = 'America'
left join students_ordered b on r.row_num = b.c_rank and b.continent = 'Asia'
left join students_ordered c on r.row_num = c.c_rank and c.continent = 'Europe'
