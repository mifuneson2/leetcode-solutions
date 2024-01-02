-- 1412. Find the Quiet Students in All Exams
-- https://leetcode.com/problems/find-the-quiet-students-in-all-exams/
-- tags: database, hard, no_posted_solution, window, rank, subquery

-- Write your PostgreSQL query statement below

with exam_performances as (
    select
        exam_id
        ,student_id
        ,score
        ,rank() over (partition by exam_id order by score desc) as exam_h_rank
        ,rank() over (partition by exam_id order by score) as exam_l_rank
    from exam
    order by 1,2,3,4
)
, exams_written as (
    select
        t.student_id
        ,t.student_name
        ,count(e.exam_id) as exam_ct
    from student t
    left join exam e on t.student_id = e.student_id
    group by 1,2
    order by 1,2
)
, high_and_lower_performers as (
        select student_id,exam_id, score, exam_h_rank,exam_l_rank
        from exam_performances
        where exam_h_rank = 1
        or exam_l_rank = 1

)
select
    student_id
    ,student_name
    from exams_written
    where exam_ct != 0
    and student_id not in (
        select student_id
        from high_and_lower_performers
    )