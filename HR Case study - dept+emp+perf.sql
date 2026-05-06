
#1. Department-wise employee ratings (Year-wise)
SELECT d.department_name,e.emp_name,p.year,p.rating
FROM performance p
JOIN employees e  ON p.emp_id = e.emp_id
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, p.year, p.rating DESC;

#2. Department-wise employee ratings (Only 2022)
SELECT d.department_name,e.emp_name,p.rating
FROM performance p
JOIN employees e ON p.emp_id = e.emp_id
JOIN departments d ON p.emp_id = e.emp_id
JOIN departments d  ON e.department_id = d.department_id
WHERE p.year = 2022
ORDER BY d.department_name, p.rating DESC;

#3. Department-wise average rating (Summary view)
SELECT d.department_name, ROUND(AVG(p.rating),2) AS avg_rating
FROM performance p
JOIN employees e ON p.emp_id = e.emp_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

#4. Department-wise rating distribution (Count of ratings)
SELECT d.department_name,p.rating,COUNT(*) AS total_employees
FROM performance p
JOIN employees e ON p.emp_id = e.emp_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name, p.rating
ORDER BY d.department_name, p.rating DESC;

#5. Top-rated employee in each department (2022)
SELECT d.department_name,e.emp_name,p.rating
FROM performance p
JOIN employees e ON p.emp_id = e.emp_id
JOIN departments d ON e.department_id = d.department_id
WHERE p.year = 2022 
AND (e.department_id, p.rating) 
IN (SELECT e.department_id, MAX(p.rating)
    FROM performance p
    JOIN employees e ON p.emp_id = e.emp_id
    WHERE p.year = 2022
    GROUP BY e.department_id) ;
   # or 
SELECT d.department_name,e.emp_name,p.rating
FROM performance p
JOIN employees e ON p.emp_id = e.emp_id
JOIN departments d ON e.department_id = d.department_id
WHERE p.year=2022
group by d.department_name,e.emp_name,p.rating ;

#6. Average perfrmance rating by department(2022)
select d.department_name,avg(P.rating) as Avg_perf_rating
from performance p
join employees e on P.emp_id=e.emp_id
join departments d on e.department_id=d.department_id
where P.year=2022
group by d.department_name ;

#7. Top performers in 2022
select p.year,e.emp_id,e.emp_name
from Performance p
join employees e on p.emp_id=e.emp_id
where p.year=2022
group by p.year,e.emp_id,e.emp_name;

#8. Employees with performance improvent(2022-2023) 
Select e.emp_id,e.emp_name,
    p2022.rating AS rating_2022,
    p2023.rating AS rating_2023,
    (p2023.rating - p2022.rating) AS improvement
FROM performance p2022
JOIN performance p2023 ON p2022.emp_id = p2023.emp_id
JOIN employees e ON e.emp_id = p2022.emp_id
WHERE p2022.year = 2022
AND p2023.year = 2023
AND p2023.rating > p2022.rating;

#9. Manager with team size
   SELECT 
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    COUNT(e.emp_id) AS team_size
FROM employees e
JOIN employees m 
    ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name
ORDER BY team_size DESC;

#10. High performer with low salary
 SELECT 
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    avg(e.salary ) AS Avg_team_salary                         
FROM employees e
JOIN employees m 
    ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name
ORDER BY Avg_team_salary DESC;

#11. High performers & with  low salary
select e.emp_id,e.emp_name,
	   max(p.rating) as high_performer,min(e.salary) as low_salary
from employees e
join performance p on e.emp_id=p.emp_id
group by e.emp_id,e.emp_name ;

#12. Highest paid employee in each department
select d.department_id,d.department_name,
       max(e.salary) as highest_paid_employees
from departments d
join employees e on d.department_id=e.department_id
group by d.department_id,d.department_name ;

#13.  Highest paid employees in each department with employee name.
SELECT d.department_name, e.emp_name, e.salary
FROM employees e
JOIN departments d 
    ON e.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id);
#     or
SELECT d.department_name, e.emp_name, e.salary
FROM employees e
JOIN departments d 
    ON e.department_id = d.department_id
group by d.department_name,e.emp_name,e.salary;
    
#14. Average salary per department
select d.department_id,d.department_name,
	   avg(e.salary) as average_salary
from departments d
join employees e on d.department_id=e.department_id
group by d.department_id,d.department_name;

#15. Average salary per department with employee name
select d.department_id,d.department_name,e.emp_id,emp_name,e.salary
from departments d
join employees e on d.department_id=e.department_id
WHERE e.salary = (
    SELECT avg(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id);
    
# Average salary per department
select d.department_id,d.department_name,avg(e.salary) as average_salary
from departments d
join employees e on d.department_id=e.department_id 
group by d.department_id,department_name;
       
#16. Employees earning above company average 
select emp_name,salary
from employees
where salary > (select avg(salary) from employees);

#17. List of active employees 
select emp_id,emp_name,status
from employees
where status='Active' ;

#18. Total employees (Active vs Resigned)
SELECT status,
    COUNT(*) AS total_employees
FROM employees
GROUP BY status;
#  or
SELECT
    COUNT(*) AS total_employees,
    SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) AS active_employees,
    SUM(CASE WHEN status = 'Resigned' THEN 1 ELSE 0 END) AS resigned_employees
FROM employees;

#19. Department wise headcount
select d.department_name,count(e.emp_id) as Total_employees
from departments d
join employees e on d.department_id=e.department_id
group by d.department_name;

#20. Gender diversity by department
SELECT d.department_name,e.gender,
    COUNT(e.emp_id) AS total_employees
FROM employees e
JOIN departments d  ON e.department_id = d.department_id
GROUP BY d.department_name, e.gender
ORDER BY d.department_name;

#21.High paid employees in each department
SELECT d.department_name,
    max(e.salary) AS max_salary
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name ;

#22. Attrition count by department
SELECT d.department_name,
    COUNT(e.emp_id) AS resigned_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.status = 'Resigned'
GROUP BY d.department_name
ORDER BY resigned_count DESC;
# or
SELECT d.department_name,
    COUNT(e.emp_id) AS total_employees,
    SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) AS resigned_count,
    ROUND(SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(e.emp_id),2) AS attrition_rate_percentage
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

#23. Attrition count(including departments with zero)
SELECT d.department_name,
    SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) AS resigned_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
group by d.department_name
ORDER BY resigned_count DESC;

#24. Attrition rate%
select Round(Count(case when status = 'Resigned' then 1 end )*100.0
                    /count(*),2) As Attrition_percentage
from employees;

#25. Employees hired after 2020 earning above Rs 60000/-
SELECT *
FROM employees
WHERE hire_date > '2020-12-31'
  AND salary > 60000;
  
  SELECT *
FROM employees
WHERE YEAR(hire_date) > 2020
  AND salary > 60000;
  
  # 26. Count of emoloyees -hired after 2020 earning above Rs 60,000/-
  SELECT COUNT(*) AS high_salary_new_hires
FROM employees
WHERE hire_date >= '2021-01-01'
  AND salary > 60000;
  
  # 27.Department wise breakdown. Extended version of question 31 .
  SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
WHERE hire_date >= '2021-01-01'
  AND salary > 60000
GROUP BY department
ORDER BY employee_count DESC;

# 28. Department wise average salary . Extended version of question 31.
SELECT department,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
WHERE hire_date >= '2021-01-01'
  AND salary > 60000
GROUP BY department;
    
#29.Department-wise-percentage . Extended version of question 31
SELECT department,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 / 
        (SELECT COUNT(*) 
         FROM employees 
         WHERE hire_date >= '2021-01-01'
           AND salary > 60000),
    2) AS percentage_share
FROM employees
WHERE hire_date >= '2021-01-01'
  AND salary > 60000
GROUP BY department;
    
#30. Top 3 highest paid after 2020
SELECT emp_id, emp_name, salary, hire_date
FROM employees
WHERE hire_date >= '2021-01-01'
ORDER BY salary DESC
LIMIT 3;