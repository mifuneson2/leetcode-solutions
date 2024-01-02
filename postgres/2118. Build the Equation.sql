-- 2118. Build the Equation
-- https://leetcode.com/problems/build-the-equation/
-- tags: database, hard, no_posted_solution, recursive, string_concat

-- Write your PostgreSQL query statement below

with recursive terms_clean as (
    select
        power
        ,factor
        ,row_number() over (order by power asc)
    from terms
    order by power asc
)
,equation_builder as (
    select
        row_number
        ,power
        ,factor
        ,case
            when power = 0 then
                case
                    when factor > 0 then concat('+', factor, '=0')
                    when factor < 0 then concat (factor, '=0')
                end
            when power = 1 then
                case
                    when factor > 0 then concat('+',factor,'X=0')
                    when factor < 0 then concat(factor, 'X=0')
                end
            when power > 1 then
                case
                    when factor > 0 then concat('+',factor,'X^', power, '=0')
                    when factor < 0 then concat(factor, 'X^', power, '=0')
                end
        end as eq_wip

    from terms_clean
    where row_number = 1

    union

    select
        t.row_number
        ,t.power
        ,t.factor
        ,case
            when t.power = 0 then
                case
                    when t.factor > 0 then concat('+', t.factor, e.eq_wip)
                    when t.factor < 0 then concat (t.factor, e.eq_wip)
                end
            when t.power = 1 then
                case
                    when t.factor > 0 then concat('+',t.factor,'X', e.eq_wip)
                    when t.factor < 0 then concat(t.factor, 'X', e.eq_wip)
                end
            when t.power > 1 then
                case
                    when t.factor > 0 then concat('+',t.factor,'X^', t.power, e.eq_wip)
                    when t.factor < 0 then concat(t.factor, 'X^', t.power, e.eq_wip)
                end
        end as eq_wip 
        
    from terms_clean t, equation_builder e
    where t.row_number = e.row_number+1

)

select eq_wip as equation
from equation_builder
order by row_number desc
limit 1