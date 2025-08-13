-- DROP ako već postoji
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;

-- STUDENTS
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    email VARCHAR(100)
);

-- PROFESSORS
CREATE TABLE professors (
    professor_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100)
);

-- COURSES
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

-- ENROLLMENTS
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- GRADES
CREATE TABLE grades (
    grade_id INT PRIMARY KEY,
    enrollment_id INT,
    grade DECIMAL(3,1),
    exam_date DATE,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

-- INSERT STUDENTS
INSERT INTO students VALUES
(1, 'Ana Kovačić', '2000-03-14', 'ana.kovacic@email.com'),
(2, 'Marko Perić', '1999-07-21', 'marko.peric@email.com'),
(3, 'Ivana Novak', '2001-11-05', 'ivana.novak@email.com');

-- INSERT PROFESSORS
INSERT INTO professors VALUES
(1, 'dr. sc. Ivica Matić', 'Računarstvo'),
(2, 'dr. sc. Marina Horvat', 'Matematika');

-- INSERT COURSES
INSERT INTO courses VALUES
(101, 'Uvod u programiranje', 1),
(102, 'Algoritmi i strukture podataka', 1),
(201, 'Matematika 1', 2);

-- INSERT ENROLLMENTS
INSERT INTO enrollments VALUES
(1001, 1, 101, '2024-10-01'),
(1002, 1, 102, '2024-10-01'),
(1003, 2, 101, '2024-10-01'),
(1004, 2, 201, '2024-10-01'),
(1005, 3, 201, '2024-10-01');

-- INSERT GRADES
INSERT INTO grades VALUES
(5001, 1001, 4.5, '2025-01-15'),
(5002, 1002, 5.0, '2025-02-20'),
(5003, 1003, 3.5, '2025-01-18'),
(5004, 1004, 4.0, '2025-02-25'),
(5005, 1005, 4.8, '2025-01-30');


select
s.name as student_name,
c.course_name,
g.grade,
g.exam_date
from students s
join enrollments e on s.student_id=e.student_id
join courses c on c.course_id=e.course_id
join grades g on g.enrollment_id=e.enrollment_id
where g.exam_date =(
select max(g2.exam_date)
from grades g2
where g2.enrollment_id=e.enrollment_id
)


select
s.name as student,
avg(g.grade) as prosjek,
case
when avg(g.grade)=5 then'Odlican'
when avg(g.grade) >=4 then 'vrlo dobar'
when avg(g.grade) >=3 then 'dobar'
when avg(g.grade) >=2 then 'dovoljan'
else 'nedovoljan'
end as prosjecna_ocjena
from students s
join enrollments e on s.student_id=e.student_id
join grades g on g.enrollment_id=e.enrollment_id
group by s.name
order by prosjek desc


select
c.course_name as kurs,
avg(g.grade) as prosjecna_ocjena,
count(e.student_id) as broj_studenata,
count(g.grade) as broj_ocjena
from courses c
join enrollments e on e.enrollment_id=e.course_id
join grades g on g.enrollment_id=e.enrollment_id
group by c.course_name
having count(student_id)<=3
order by prosjecna_ocjena desc



CREATE VIEW StudentAverageGrades AS
select
s.student_id,
s.name as student,
avg(g.grade) as prosjecna_ocjena
from students s
join grades g on g.enrollment_id=s.student_id
group by s.student_id,s.name

SELECT * FROM StudentAverageGrades;


CREATE FUNCTION fnStudentAverage(@student_id INT)
returns decimal(5,2)
as
begin
declare @average decimal(5,2)
select @average=avg(cast (grade as decimal(5,2)))
from students
where student_id=@student_id

return 
@average
end
