-- 1384. Total Sales Amount by Year
-- https://leetcode.com/problems/total-sales-amount-by-year/
-- tags: database, hard, no_posted_solution

-- Write your PostgreSQL query statement below
with year_range as (
    select generate_series(
            min(date_part('year',period_start))::int
            , max(date_part('year',period_end)::int) 
    ) as report_year
    from sales
)
, report_years as (
    select 
        y.report_year
        ,s.product_id
        ,p.product_name
        ,s.average_daily_sales
        ,s.period_start
        ,s.period_end
        ,make_date(y.report_year,1,1) as report_year_start
        ,make_date(y.report_year,12,31) as report_year_end

    from year_range y
    left join sales s
    on y.report_year between date_part('year', s.period_start) 
        and date_part('year', s.period_end)
    left join product p on s.product_id = p.product_id
)

select 
    product_id
    ,product_name
    ,report_year::varchar --report year needs to be varchar to be accepted (not mentioned in the problem description)
    ,(least(report_year_end, period_end) 
        - greatest(report_year_start, period_start) + 1) * average_daily_sales
    as total_amount
from report_years
order by 1,3;