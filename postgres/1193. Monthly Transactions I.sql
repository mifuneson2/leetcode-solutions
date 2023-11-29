-- Write your PostgreSQL query statement below
select
    to_char(t.trans_date, 'yyyy-mm') as month
    ,t.country
    ,count(1) as trans_count
    ,sum(case when t.state = 'approved' then 1 else 0 end) as approved_count
    ,sum(t.amount) as trans_total_amount
    ,sum(case when t.state = 'approved' then t.amount else 0 end) as approved_total_amount

from Transactions t
group by to_char(t.trans_date, 'yyyy-mm'), country