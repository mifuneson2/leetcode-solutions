-- Write your PostgreSQL query statement below
SELECT u.unique_id, e.name
FROM Employees e LEFT JOIN EmployeeUNI u on e.id = u.id