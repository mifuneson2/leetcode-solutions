delete
from Person
where id not in (
    --find the lowest_id for email email address
    select min(id) as id
    from Person
    group by email
)
