-- Write your PostgreSQL query statement below
select 
    t.request_at as Day
    ,round(sum(case when status in('cancelled_by_driver','cancelled_by_client') then 1 else 0 end) * 1.0
        / count(1) 
        , 2 --round to 2 decimals
    ) as "Cancellation Rate" 

from Trips t
left join Users c on c.users_id = client_id
left join Users d on d.users_id = driver_id
where c.banned = 'No' and d.banned = 'No'
and t.request_at >= '2013-10-01' 
and t.request_at <= '2013-10-03'
group by request_at
order by request_at