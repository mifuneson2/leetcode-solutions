-- Write your PostgreSQL query statement below
select e.name, b.bonus
from Employee e left join Bonus b on b.empID = e.empID
where bonus < 1000 or bonus is null;