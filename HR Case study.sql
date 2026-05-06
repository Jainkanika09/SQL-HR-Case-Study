# Create HR Database
CREATE DATABASE hr_case_study;
USE hr_case_study;

# Create Tables

# Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

# Employees
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    gender VARCHAR(10),
    department_id INT,
    salary INT,
    hire_date DATE,
    manager_id INT,
    status VARCHAR(20),      -- Active / Resigned
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

# Performance
CREATE TABLE performance (
    perf_id INT PRIMARY KEY,
    emp_id INT,
    year INT,
    rating INT,          -- 1 to 5
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id)
);

# Attendance
CREATE TABLE attendance (
    att_id INT PRIMARY KEY,
    emp_id INT,
    month VARCHAR(10),
    presents INT,
    absents INT,
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id)
);

# Promotions
CREATE TABLE promotions (
    promo_id INT PRIMARY KEY,
    emp_id INT,
    promotion_date DATE,
    new_title VARCHAR(50),
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id)
);

#  Insert Sample Data

# Departments
INSERT INTO departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Operations');

# Employees
INSERT INTO employees VALUES
(101,'Aarav', 'Male', 3, 90000, '2019-02-12', NULL,'Active'),
(102,'Riya', 'Female', 1, 55000, '2020-06-18', 101,'Active'),
(103,'Karan','Male', 2, 75000, '2018-09-10', 101,'Resigned'),
(104,'Simran','Female', 3, 120000,'2017-04-14', NULL,'Active'),
(105,'Rahul','Male', 4, 60000,'2021-01-12',104,'Active'),
(106,'Neha','Female', 1, 50000,'2022-03-01',102,'Active'),
(107,'Arjun','Male', 5, 45000,'2023-01-15',104,'Active'),
(108,'Priya','Female', 2, 80000,'2019-11-10',103,'Resigned');

# Performance
INSERT INTO performance VALUES
(1,101,2022,5),
(2,102,2022,4),
(3,103,2022,3),
(4,104,2022,5),
(5,105,2022,4),
(6,106,2022,3),
(7,107,2022,4),
(8,108,2022,5),
(9,101,2023,5),
(10,102,2023,3),
(11,105,2023,4),
(12,106,2023,4);

# Attendance
INSERT INTO attendance VALUES
(1,101,'Jan',25,1),
(2,102,'Jan',22,4),
(3,103,'Jan',20,6),
(4,104,'Jan',26,0),
(5,105,'Jan',21,5),
(6,106,'Jan',24,2),
(7,107,'Jan',23,3),
(8,108,'Jan',19,7);

# Promotions
INSERT INTO promotions VALUES
(1,101,'2022-08-05','Senior Manager'),
(2,104,'2021-04-20','IT Head'),
(3,105,'2023-02-15','Marketing Lead');

# Viewing table
select*from departments;
select*from employees;
select*from performance;
select*from attendance;
select*from promotions;

# Departments + Employees data
#1. Show female staff list .
select emp_name , gender
from employees
where gender ='female';

#2. Show male staff list .
select emp_name , gender
from employees
where gender ='male';

#3. Show data - department , name ,status & salary .
select e.emp_name,e.salary,e.status,d.department_name
from employees e
join departments d on e.department_id=d.department_id ;

#4. Show department wise employee count .
select d.department_name,count(e.emp_name) as employee_count
from departments d
join employees e on d.department_id=e.department_id
group by d.department_name ;

#5. Show department where more than 1 employee is working .
select d.department_name,count(e.emp_name) as employee_count
from departments d
join employees e on d.department_id = e.department_id
group by d.department_name
having count(e.emp_name)>1;

#6. Show employee joined bettwen year 2020 and 2023.
select emp_id,emp_name,hire_date
from employees
where hire_date between '2020-01-01' and '2023-12-31' ;

#7. Show list of active staff.
select d.department_name,e.emp_name,e.status
from departments d
join employees e on d.department_id=e.department_id
where e.status='active' ;

#8. Show list of resigned staff .
select d.department_name,e.emp_name,e.status
from departments d
join employees e on d.department_id=e.department_id
where e.status='resigned' ;

#9. Count active staff .
select count(*) as active_empoloyee_count
from employees
where status ='active';

#10. Count active staff .
select count(*) as resigned_empoloyee_count
from employees
where status ='resigned';

#10. Count active employees grouping by department.
select d.department_name,count(*) as active_count
from employees e
join departments d on e.department_id=d.department_id
where e.status ='active'
group by d.department_name ;

#11. Count resigned employees grouping by department.
select d.department_name,count(*) as resigned_count
from employees e
join departments d on e.department_id=d.department_id
where e.status ='resigned'
group by d.department_name ;

#12. Count  female staff .
select count(*) as female_empoloyee_count
from employees
where gender ='female';

#13. Count female employees grouping by department.
select d.department_name,count(*) as female_staff_count
from employees e
join departments d on e.department_id=d.department_id
where e.gender ='female'
group by d.department_name ;

#14. Count male staff .
select count(*) as male_empoloyee_count
from employees
where gender ='male';

#15. Count male employees grouping by department.
select d.department_name,count(*) as male_staff_count
from employees e
join departments d on e.department_id=d.department_id
where e.gender ='male'
group by d.department_name ;

#16. Arrange employee according to hire date in ascending order.
select emp_name,hire_date
from employees
order by hire_date asc ;
#        or
select emp_name,hire_date
from employees
order by hire_date  ;

#17. Arrange employee according to hire date in descending order.
select emp_name,hire_date
from employees
order by hire_date desc ;

#18. Find maxamimum salired employee with there department 
select e.emp_name,e.salary,d.department_name
from employees e
join departments d on e.department_id=d.department_id
order by e.salary desc
limit 1 ;

#19. Department wise highest salary.
select d.department_name ,max(e.salary) as highest_salary
from departments d
join employees e on d.department_id=e.department_id 
group by d.department_name;

#20. Find minimum salired employee with there department 
select e.emp_name,e.salary,d.department_name
from employees e
join departments d on e.department_id=d.department_id
order by e.salary asc
limit 1 ;

#21. Department wise lowest salary.
select d.department_name ,min(e.salary) as lowest_salary
from departments d
join employees e on d.department_id=e.department_id 
group by d.department_name
limit 1;

#22. Find second highest salary .
SELECT emp_name,MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

#23. Find second highest salary with employee name.
# Using LIMIT
SELECT emp_name, salary
FROM employees
WHERE salary = (
    SELECT DISTINCT salary
    FROM employees
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1);
#        or
#  Using Subquery
SELECT emp_name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (SELECT MAX(salary) FROM employees)
);

#24. Get total salary excluding HR department.
select d.department_name,e.salary
from departments d
join employees e on d.department_id=e.department_id
where d.department_name not in('HR');

#25. Show filtered employees in HR ,Finance & Marketing department.
select d.department_name,e.emp_name
from departments d
join employees e on d.department_id=e.department_id
where d.department_name in( 'HR','Finance','marketing');

#26. Employee who is newest hired.
select emp_name,hire_date
from employees
order by hire_date desc
limit 1 ;

#27. Employee who is oldest hired 
select emp_name,hire_date
from employees
order by hire_date
limit 1 ;
#       or
select emp_name,hire_date
from employees
order by hire_date asc
limit 1 ;

#28. List of employees earning between Rs 90000 and Rs 120000.
select emp_name,salary
from employees
where salary between 90000 and 120000 ;

#29. Show list of employess with their manager .
select e.emp_name as employee_name,
       m.emp_name as manager_name
from employees e
join employees m on e.manager_id=m.emp_id ;
#             or
select e.emp_name as employee_name,
coalesce(m.emp_name,'No manager') as manager_name
from employees e
left join employees m on e.manager_id = m.emp_id ;

#30. Show employees with no manger .
SELECT emp_name
FROM employees
WHERE manager_id IS NULL;

#31. Manager wise employee count.
select m.emp_name as manager_name,
count(e.emp_id) as total_employees
from employees e
left join employees m on e.manager_id=m.emp_id
group by m.emp_name ;

#32. Show department wise average and total salary.
select d.department_name,sum(e.salary) as Total_salary,
                         avg(e.salary) as Average_salary
 from departments d
 join employees e on d.department_id=e.department_id
 group by d.department_name ;
 
 #33. get the total salary per department showing
 #a. Employees with salary greater than Rs 80000/-
 #b. Department wise total salary above Rs 100000/-
 select d.department_name,sum(e.salary)as Total_salary
 from departments d
 join  employees e on d.department_id=e.department_id
 where e.salary > 80000
 group by d.department_name
 having sum(e.salary) > 100000;
 
 #34. Show department wise average salary & maximum salary for department.
 # where at least one employee earn above Rs 60,000/- .
 select d.department_name,avg(e.salary) as average_salary,
						  max(e.salary) as maximum_salary
 from departments d
 join employees e on d.department_id=e.department_id
 group by department_name
 having max(e.salary) > 60000 ;
 
 #35. List of employees earning less than departments average.
 select e.emp_name,d.department_name,e.salary
 from employees e
 join departments d on e.department_id=d.department_id
 where e.salary < (select avg(e1.salary) from employees e1
                   where e1.department_id=e.department_id);
 
 #36. Find department where average salary is higher than overall salary .
select department_name,sum(salary) as overall_salary
from departments d
 join employees e on d.department_id=e.department_id
 where e.salary < (select avg(e1.salary) from employees e1
                   where e1.department_id=e.department_id)
group by d.department_name;

 #37. Employees earning above company average.
 select emp_name,salary
 from employees
 where salary > (select avg(salary) from  employees);
 
 #38. List details - department,status,salary of employees .
 select d.department_name, e.emp_name,e.status,e.gender,e.salary
 from departments d
 join employees e on d.department_id=e.department_id;

#39. Find employees working in department where average salary exceeds Rs 90,000/ .Along with department name.
SELECT e.emp_name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id    
WHERE e.department_id IN (
    SELECT department_id FROM employees
    GROUP BY department_id
    HAVING AVG(salary) > 90000);

#40. Employees with less than the company median salary.
WITH salary_rank AS (
SELECT emp_id, emp_name, salary,
ROW_NUMBER() OVER (ORDER BY salary) AS rn,
COUNT(*) OVER() AS total from employees)
SELECT emp_name, salary
FROM salary_rank
WHERE rn < (total+1) / 2;
