-- Write your PostgreSQL query statement below
select
    id
    ,coalesce(
        case when id % 2 = 1 then lead(student,1) over (order by id asc)
            when id % 2 = 0 then lag(student,1) over (order by id asc)
            else student
        end
        , student
    )as student
from Seat
order by id