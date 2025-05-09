CREATE TABLE students (

id SERIAL PRIMARY KEY, -- Unique ID for each student

name VARCHAR(50) NOT NULL -- Name of the student

);


-- Create the courses table

CREATE TABLE courses (

id SERIAL PRIMARY KEY, -- Unique ID for each course

name VARCHAR(100) NOT NULL -- Name of the course

);


-- Create the enrollments table

CREATE TABLE enrollments (

id SERIAL PRIMARY KEY, -- Unique ID for each enrollment record

student_id INT REFERENCES students(id), -- Foreign key linking to the students table

course_id INT REFERENCES courses(id) -- Foreign key linking to the courses table

);


-- Insert sample data into the students table

INSERT INTO students (name) VALUES

('Ali'),

('Sarah'),

('Ahmed'),

('Fatima');


-- Insert sample data into the courses table

INSERT INTO courses (name) VALUES

('Mathematics'),

('Physics'),

('Computer Science');


-- Insert sample data into the enrollments table

INSERT INTO enrollments (student_id, course_id) VALUES

(1, 1), -- Ali enrolled in Mathematics

(2, 1), -- Sarah enrolled in Mathematics

(3, 2), -- Ahmed enrolled in Physics

(4, 1), -- Fatima enrolled in Mathematics

(3, 3); -- Ahmed enrolled in Computer Science


-- Retrieve courses with more than one enrollment using a subquery

SELECT c.name, sub.enrollments

FROM courses c

JOIN (

-- Subquery to count the number of enrollments per course

SELECT course_id, COUNT(id) AS enrollments

FROM enrollments

GROUP BY course_id

) sub ON c.id = sub.course_id

WHERE sub.enrollments > 1; -- Filter to include only courses with more than one enrollment


-- Retrieve all courses with their enrollment counts (optional)

SELECT c.name, COUNT(e.id) AS enrollments

FROM courses c

LEFT JOIN enrollments e ON c.id = e.course_id

GROUP BY c.id; -- Group by course ID to calculate enrollments for each course








-- Create a view to display all enrollments with student and course details

CREATE VIEW all_enrollments AS

SELECT
e.id AS enrollment_id, -- Unique enrollment ID

s.name AS student_name, -- Student's name

c.name AS course_name -- Course's name

FROM enrollments e

JOIN students s ON e.student_id = s.id -- Join with students table

JOIN courses c ON e.course_id = c.id; -- Join with courses table



-- Query the view

SELECT * FROM all_enrollments;




-- Create a view to find courses with no enrollments

CREATE VIEW courses_without_enrollments AS

SELECT

c.id AS course_id, -- Unique course ID

c.name AS course_name -- Course's name

FROM courses c

LEFT JOIN enrollments e ON c.id = e.course_id -- Left join to find unmatched courses

WHERE e.id IS NULL; -- Filter for courses with no enrollments


-- Query the view

SELECT * FROM courses_without_enrollments;
-- Create a view to find courses with no enrollments

CREATE VIEW courses_without_enrollments AS

SELECT

c.id AS course_id, -- Unique course ID

c.name AS course_name -- Course's name

FROM courses c

LEFT JOIN enrollments e ON c.id = e.course_id -- Left join to find unmatched courses

WHERE e.id IS NULL; -- Filter for courses with no enrollments


-- Query the view

SELECT * FROM courses_without_enrollments;



-- Create a view for popular courses with more than 2 enrollments

CREATE VIEW student_enrollment_counts AS

SELECT

s.id AS student_id, -- Unique student ID

s.name AS student_name, -- Student's name

COUNT(e.id) AS total_enrollments -- Total number of enrollments

FROM students s

LEFT JOIN enrollments e ON s.id = e.student_id -- Left join to include students with no enrollments

GROUP BY s.id, s.name; -- Group by student to calculate their enrollments


-- Query the view

SELECT * FROM student_enrollment_counts;



-- Create a view to show students and their enrolled courses


CREATE VIEW popular_courses AS

SELECT

c.id AS course_id, -- Unique course ID

c.name AS course_name, -- Course's name

COUNT(e.id) AS total_enrollments -- Total number of enrollments

FROM courses c

JOIN enrollments e ON c.id = e.course_id -- Join with enrollments

GROUP BY c.id, c.name -- Group by course to count enrollments

HAVING COUNT(e.id) > 2; -- Filter for courses with more than 2 enrollments


-- Query the view

SELECT * FROM popular_courses;