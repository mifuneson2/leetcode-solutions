# 2991. Top Three Wineries 
# https://leetcode.com/problems/top-three-wineries/
# tags: database, hard, no_posted_solution, new_problem, concat, window

# Write your MySQL query statement below

with winery_pts as (
    select 
        country
        ,winery
        ,sum(points) as points
    from wineries
    group by 1,2
)

,winery_rankings as (
    select 
        country
        ,winery
        ,points
        ,row_number() over (partition by country order by points desc, winery) as ranking
    from winery_pts 
)

, country_table as (
    select 
        a.country
        ,concat(a.winery, ' (', a.points,')' ) as top_winery
        ,coalesce(concat(b.winery, ' (', b.points,')' ), 'No second winery') as second_winery
        ,coalesce(concat(c.winery, ' (', c.points,')' ), 'No third winery') as third_winery
    from (
        select
            country
            ,winery
            ,points
        from winery_rankings
        where ranking = 1
    ) a
    left join (
        select
            country
            ,winery
            ,points
        from winery_rankings
        where ranking = 2
    ) b on a.country = b.country
    left join (
        select
            country
            ,winery
            ,points
        from winery_rankings
        where ranking = 3
    ) c on a.country = c.country

    order by a.country
)

select * from country_table