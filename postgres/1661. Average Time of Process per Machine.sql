-- Write your PostgreSQL query statement below
SELECT s.machine_id, round(avg(e.timestamp - s.timestamp)::numeric,3) as processing_time
FROM Activity s, Activity e
where s.machine_id = e. machine_id
and s.process_id = e.process_id
and s.activity_type = 'start' and e.activity_type = 'end'
group by s.machine_id