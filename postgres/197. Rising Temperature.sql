-- Write your PostgreSQL query statement below
SELECT t.id
FROM Weather t JOIN Weather y on t.recordDate - y.recordDate = 1
WHERE t.temperature > y.temperature 
--and 