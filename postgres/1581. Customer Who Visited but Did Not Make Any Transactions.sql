-- Write your PostgreSQL query statement below
SELECT v.customer_id, count(1) as count_no_trans
FROM Visits v
WHERE v.visit_id NOT IN (SELECT DISTINCT visit_id FROM Transactions )
GROUP BY v.customer_id