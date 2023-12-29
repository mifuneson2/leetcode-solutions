-- 1127. User Purchase Platform
-- https://leetcode.com/problems/user-purchase-platform/

-- Write your PostgreSQL query statement below
with date_range as (
    select spend_date from spending
    union
    select spend_date from spending
    order by spend_date
)
,device_types(platform) as (
    values 
    ('desktop'), 
    ('mobile'), 
    ('both') 
)
, standardized_rows as (
    select 
        s.spend_date
        ,d.*
    from date_range s cross join device_types d
)
,flattened as (
    select
        coalesce(d.spend_date,m.spend_date) as spend_date
        ,coalesce(d.user_id, m.user_id) as user_id
        ,d.amount as desktop_spend
        ,m.amount as mobile_spend
    from (
        select *
        from spending
        where platform = 'desktop'
    ) d
    full outer join (
        select *
        from spending
        where platform = 'mobile'
    ) m
    on m.user_id = d.user_id 
        and m.spend_date = d.spend_date
        and m.platform = 'mobile' 
        and d.platform = 'desktop'
    order by 1,2
)
,classified as (
    select
        spend_date
        ,user_id
        ,case 
            when desktop_spend is not null and mobile_spend is not null then 'both'
            when desktop_spend is not null then 'desktop'
            when mobile_spend is not null  then 'mobile'
            else 'error'
        end as platform
        ,coalesce(desktop_spend,0) + coalesce(mobile_spend,0) as total_amount
    from flattened
    order by 1,2
)
,organized as (
    select
        spend_date
        ,platform
        ,sum(total_amount) as total_amount
        ,count(distinct user_id) as total_users
    from classified
    group by 1,2
    order by 1,2
)

        
select 
    s.spend_date
    ,s.platform
    ,coalesce(o.total_amount,0) as total_amount
    ,coalesce(o.total_users,0) as total_users
 from standardized_rows s
 left join organized o on s.spend_date = o.spend_date and s.platform = o.platform
