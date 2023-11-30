-- Write your PostgreSQL query statement below
select *
from Patients
where regexp_match(conditions, '\yDIAB1\w*\y') is not null
