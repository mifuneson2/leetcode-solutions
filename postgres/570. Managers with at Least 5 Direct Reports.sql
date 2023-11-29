-- Write your PostgreSQL query statement below
select manager_name as name

from (
        select
            m.id as manager_id
            ,m.name as manager_name
            ,d.id as id
            --,count(d.id) as directs_ct
    from Employee m join Employee d on d.managerId = m.id
    
) group by manager_id, manager_name
having count(id) >= 5