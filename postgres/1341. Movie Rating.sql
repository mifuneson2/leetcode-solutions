-- Write your PostgreSQL query statement below

select
    uu.name as results
from (
    select 
        m.user_id
        ,u.name
        ,count(movie_id) as rating_ct
    from MovieRating m join Users u on m.user_id = u.user_id 
    group by m.user_id, u.name
    order by rating_ct desc, u.name asc
    limit 1
) uu

union all


select
    uuu.title as results
from (

    select
        m.movie_id
        ,v.title
        ,avg(m.rating) as avg_rating
    from MovieRating m join Movies v on v.movie_id = m.movie_id
    where date_trunc('month',m.created_at) = date'2020-02-01'
    group by m.movie_id, v.title
    order by avg_rating desc, v.title asc
    limit 1
) uuu