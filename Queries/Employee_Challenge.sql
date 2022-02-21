------------------------------------------------------------
--Deliverable 1: The Number of Retiring Employees by Title--
------------------------------------------------------------

-- Create new table for retiring employees and their titles
SELECT et.emp_no, 
	et.first_name, 
	et.last_name, 
	tt.title, 
	tt.from_date, 
	tt.to_date
INTO retirement_titles
FROM employees as et
INNER JOIN titles as tt
ON (et.emp_no = tt.emp_no)
INNER JOIN dept_info as d
on (et.emp_no = d.emp_no)
WHERE (et.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY et.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01' )
ORDER BY emp_no, title DESC;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(ut.emp_no),
ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY title 
ORDER BY COUNT(title) DESC;

---------------------------------------------------------------------
--Deliverable 2: The Employees Eligible for the Mentorship Program --
---------------------------------------------------------------------
--Create a table that holds the employees who are eligible to participate in a mentorship program.
SELECT DISTINCT ON(em.emp_no) em.emp_no, 
    em.first_name, 
    em.last_name, 
    em.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_eligibilty
FROM employees as em
INNER JOIN dept_emp as de
ON (em.emp_no = de.emp_no)
INNER JOIN titles as t
ON (em.emp_no = t.emp_no)
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no, t.from_date DESC;


------------------------------------------------------------------
--Deliverable 3: Written Report: The Employee Database Analysis --
------------------------------------------------------------------
--How many roles will need to be filled as the "silver tsunami" begins to make an impact?
-- Use Dictinct with Orderby to remove duplicate rows for Department
SELECT DISTINCT ON (emp_no) emp_no,
	dept_no,
	from_date,
	to_date
INTO unique_departments
FROM dept_emp
WHERE (to_date = '9999-01-01' )
ORDER BY emp_no, dept_no DESC;

-- Creating a table for roles needed to fill with Title and Department
SELECT ut.dept_name, ut.title, COUNT(ut.title) 
INTO roles_to_fill
FROM (SELECT title, dept_name from unique_departments) as ut
GROUP BY ut.dept_name, ut.title
ORDER BY ut.dept_name DESC;

SELECT ut.emp_no, 
	ut.first_name, 
	ut.last_name, 
	ut.title, 
	d.dept_name
INTO roles_to_fill
FROM unique_titles as ut
INNER JOIN unique_departments as ud
ON (ut.emp_no = ud.emp_no)
INNER JOIN departments as d
ON (ud.dept_no = d.dept_no)
ORDER BY ut.emp_no

-- Retrieve the number of employees by their most recent job title and department who are about to retire.
SELECT rf.dept_name, rf.title, COUNT(rf.title) 
INTO count_roles
FROM (SELECT title, dept_name from roles_to_fill) as rf
GROUP BY rf.dept_name, rf.title
ORDER BY count DESC;

--Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
--Create a table that holds the count of employees who are eligible to participate in a mentorship program.
SELECT COUNT(me.emp_no),
me.title
INTO mentorship_titles
FROM mentorship_eligibilty as me
GROUP BY title 
ORDER BY COUNT(title) DESC;



