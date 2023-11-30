-- Write your PostgreSQL query statement below

with single_policyholder_cities as (
    select 
       lat || ',' || lon as coord
       ,count(distinct pid) as ph_ct
    from Insurance
    group by coord
    having count(distinct pid) = 1
), multiple_tiv_2015 as (
    select 
        tiv_2015
        ,dense_rank() over (partition by tiv_2015 order by pid) as tiv2015_inst
    from Insurance
)

select
    round(sum(tiv_2016)::decimal,2) as tiv_2016
from Insurance
where 
    lat || ',' || lon in (select coord from single_policyholder_cities)
and tiv_2015 in (select tiv_2015 from multiple_tiv_2015 where tiv2015_inst = 2) 

