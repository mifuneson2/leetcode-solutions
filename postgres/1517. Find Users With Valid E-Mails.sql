-- Write your PostgreSQL query statement below
with cte as (
    select *
        ,split_part(mail, '@',1) as prefix
        ,split_part(mail, '@',2) as domain
        ,regexp_matches(split_part(mail, '@',1), '^[A-Za-z][A-Za-z0-9._-]*' ) as prefix_matcher

    from Users
)
select 
    c.user_id, c.name, c.mail
from cte c
where c.domain = 'leetcode.com'
and c.prefix = c.prefix_matcher[1] --get first element in the text array, should only be 1 element