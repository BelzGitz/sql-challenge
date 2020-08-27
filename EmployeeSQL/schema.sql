CREATE TABLE titles (
    title_id varchar   NOT NULL,
    title varchar   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
		title_id
	)
);

CREATE TABLE employees (
    emp_no int   NOT NULL,
    emp_title_id varchar   NOT NULL,
    birth_date date   NOT NULL,
    first_name varchar   NOT NULL,
    last_name varchar   NOT NULL,
    sex varchar   NOT NULL,
    hire_date date   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE departments (
    dept_no varchar   NOT NULL,
    dept_name varchar   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_manager (
    dept_no varchar   NOT NULL,
    emp_no int   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (
        dept_no,emp_no
     )
);

CREATE TABLE dept_emp (
    emp_no int   NOT NULL,
    dept_no varchar   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (
        emp_no,dept_no
     )
);

CREATE TABLE salaries (
    emp_no int   NOT NULL,
    salary int   NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (
        emp_no
     )
);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

--List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no,last_name,first_name, sex, salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no=salaries.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986.
SELECT emp_no,
	first_name,
	last_name,
	to_char(hire_date,'1986')
FROM employees;

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT dm.dept_no, dp.dept_name, dm.emp_no, em.last_name, em.first_name
FROM  dept_manager as dm
INNER JOIN employees as em on
dm.emp_no=em.emp_no
JOIN departments as dp
ON dp.dept_no=dm.dept_no;

--List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT em.emp_no,em.last_name,em.first_name,dp.dept_name
FROM employees as em
INNER JOIN dept_emp as de ON
em.emp_no=de.emp_no
JOIN departments as dp
on dp.dept_no=de.dept_no;

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name,sex
FROM employees
WHERE first_name = 'Hercules'and last_name like 'B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT em.emp_no,em.last_name,em.first_name,dp.dept_name
FROM employees as em
INNER JOIN dept_emp as de ON
de.emp_no=em.emp_no
INNER JOIN departments as dp
ON dp.dept_no=de.dept_no
WHERE dp.dept_name='Sales';

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT em.emp_no, em.last_name,em.first_name, dp.dept_name
FROM employees as em
INNER JOIN dept_emp as de ON
de.emp_no=em.emp_no
INNER JOIN departments as dp ON
dp.dept_no=de.dept_no
WHERE dp.dept_name='Sales' or dp.dept_name='Development';

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, count (last_name)
FROM employees
GROUP BY last_name
ORDER BY count (last_name) desc;
