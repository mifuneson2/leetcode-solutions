select
    s.student_id
    ,s.student_name
    ,j.subject_name
    ,count(e) as attended_exams

from (select distinct student_id, student_name from students) s
cross join (select distinct subject_name from subjects) j
left join examinations e on e.subject_name = j.subject_name
and s.student_id = e.student_id
group by s.student_id, s.student_name, j.subject_name
order by s.student_id, j.subject_name;