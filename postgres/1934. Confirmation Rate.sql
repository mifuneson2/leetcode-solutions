-- Write your PostgreSQL query statement below
select 
    s.user_id
    , coalesce(round(c.confirmation_rate,2),0) as confirmation_rate

from (select distinct user_id from Signups) s
left join (
    select 
        user_id
        ,sum(case when action = 'confirmed' then 1 else 0 end) / count(1)::decimal as confirmation_rate
        from Confirmations
        group by user_id
) c on s.user_id = c.user_id