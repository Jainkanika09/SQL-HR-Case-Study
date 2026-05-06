# Department + Employees + 	Performance+Attendance
 #1 . Attendance percentage of each employee
 select e.emp_name,
 round(a.presents*100.0/(a.presents+a.absents),2) as Attendance_percentage
 from attendance a
 join employees e on a.emp_id=e.emp_id ;
 
 #2. Employees promoted
 select e.emp_name,e.emp_id,p.promotion_date,p.new_title
 from employees e
 join promotions p on e.emp_id=p.emp_id
 group by e.emp_name,e.emp_id,p.promotion_date,p.new_title ;
 
 #3. Top performer employees
 select e.emp_name, p.rating
 from employees e
 join performance p on e.emp_id=p.emp_id
 group by e.emp_name,p.rating
 order by p.rating desc ;
 
 #4. High salary + High performance employees
SELECT e.emp_name,e.salary,p.rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id    
WHERE p.rating >= 4
AND e.salary > (SELECT AVG(salary) FROM employees);

#5. Employees with highest attendance
 select e.emp_id,e.emp_name,max(A.presents) as present_days,
					      A.absents
from employees e
JOIN Attendance a ON e.emp_id = A.emp_id 
where A.absents = 0
Group by e.emp_id,e.emp_name ,A.absents ;

#6. Salary distribution by department
select d.department_id,d.department_name,e.salary
from departments d
join employees e on d.department_id=e.department_id
group by d.department_id ,d.department_name,e.salary;

#7.Employees eligible for promotion
select e.emp_id,e.emp_name,avg(p.rating) as Avg_rating
from employees e
join performance p on e.emp_id=p.emp_id
where e.status='Active'
group by e.emp_id , e.emp_name
having avg(p.rating)>=4;

#8. Promotion eligibility ( Performance + attendance)
SELECT e.emp_name,AVG(p.rating) AS avg_rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
LEFT JOIN promotions pr ON e.emp_id = pr.emp_id
WHERE e.status = 'Active'
AND pr.emp_id IS NULL
GROUP BY e.emp_name
HAVING AVG(p.rating) >= 4; 

#9. Exclude promoted employees
SELECT e.emp_name,
    AVG(p.rating) AS avg_rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
LEFT JOIN promotions pr ON e.emp_id = pr.emp_id
WHERE e.status = 'Active'
AND pr.emp_id IS NULL
GROUP BY e.emp_name
HAVING AVG(p.rating) >= 4;
   
  #10. Rank employees by salary within department 
  select d.department_name,e.salary,
  dense_rank ()over (partition by d.department_name
  order by e.salary desc) as rank_in_dept
  from departments d
  join employees e on d.department_id=e.department_id
  group by d.department_name,e.salary;
  
  select d.department_name,e.salary,
  rank ()over (partition by d.department_name
  order by e.salary desc) as rank_in_dept
  from departments d
  join employees e on d.department_id=e.department_id
  group by d.department_name,e.salary;
  
  select d.department_name,e.salary,
  row_number()over (partition by d.department_name
  order by e.salary desc) as rank_in_dept
  from departments d
  join employees e on d.department_id=e.department_id
  group by d.department_name,e.salary;
  
  #11. Salary difference from department average with salary category with windows function.
  SELECT e.emp_name,d.department_name,e.salary,
   AVG(e.salary) OVER(PARTITION BY e.department_id) AS dept_avg_salary,
    e.salary - AVG(e.salary) OVER(PARTITION BY e.department_id) AS difference,
    CASE 
        WHEN e.salary > AVG(e.salary) OVER(PARTITION BY e.department_id) THEN 'Above Avg'
        WHEN e.salary < AVG(e.salary) OVER(PARTITION BY e.department_id) THEN 'Below Avg'
        ELSE 'Equal'
    END AS salary_position
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
   
  #12. Salary difference from department average without window function . 
  SELECT 
    e.emp_name,d.department_name,e.salary,dept.avg_salary,
    e.salary - dept.avg_salary AS difference
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept 
ON e.department_id = dept.department_id;

#13 . Identify high risk employees
select e.emp_id,e.emp_name,d.department_name,p.rating,
       round(a.presents*100.0/(a.presents+a/presents),2)as attendance_pct
from employeese
join departments d on e.department_id=d.department_id
join performamce p on e.emp_id=p.emp_id
join attendance a on e.emp_id=a.emp_id
where p.rating<=3
and (a.presents*100.0/(a.presents+a.absents))<85
and e.status+'Active';

#15. Department prproductivity score
SELECT d.department_name,
    ROUND((AVG(p.rating)*20*0.7) + 
        ((SUM(a.presents)*100.0/(SUM(a.presents)+SUM(a.absents)))*0.3),
    2) AS productivity_score,
    CASE 
        WHEN ((AVG(p.rating)*20*0.7) + ((SUM(a.presents)*100.0/(SUM(a.presents)+SUM(a.absents)))*0.3)) >= 85 THEN 'High Performing Dept'
        WHEN ((AVG(p.rating)*20*0.7) + ((SUM(a.presents)*100.0/(SUM(a.presents)+SUM(a.absents)))*0.3)) >= 70 THEN 'Stable Dept'
        ELSE 'Needs Attention'
    END AS department_category
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN performance p ON e.emp_id = p.emp_id
JOIN attendance a ON e.emp_id = a.emp_id
WHERE e.status = 'Active'
GROUP BY d.department_name;

#15. Department prproductivity score with extra data
SELECT d.department_name,
    -- Avg Performance
    ROUND(AVG(p.rating),2) AS avg_rating,
    -- Avg Attendance
    ROUND(SUM(a.presents)*100.0 /
        (SUM(a.presents)+SUM(a.absents)),2) As avg_attendance_pct,
    -- Productivity Score
    ROUND((AVG(p.rating)*20*0.7) + ((SUM(a.presents)*100.0 /
            (SUM(a.presents)+SUM(a.absents))) * 0.3),2)
        AS department_productivity_score
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN performance p ON e.emp_id = p.emp_id
JOIN attendance a ON e.emp_id = a.emp_id
WHERE e.status = 'Active'
GROUP BY d.department_name
ORDER BY department_productivity_score DESC;

#16.  Employees eligible for promotion
select e.emp_id,e.emp_name,d.department_name,
round(avg(p.rating),2) as avg_raing,
round(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)),2) as avg_attendance_pct
from employees e
join departments d on e.department_id=d.department_id
join performance p on e.emp_id=p.emp_id
join attendance a on e.emp_id=a.emp_id
where e.status="Active"
group by e.emp_id,e.emp_name,d.department_name
having avg(p.rating)>=4 and 
(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)))>=85;

#17. Employees eligible for promotion( Exclude alredy promoted employees)
select e.emp_id,e.emp_name,d.department_name,
round(avg(p.rating),2) as avg_raing,
round(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)),2) as avg_attendance_pct
from employees e
join departments d on e.department_id=d.department_id
join performance p on e.emp_id=p.emp_id
join attendance a on e.emp_id=a.emp_id
join promotions pr on e.emp_id=pr.emp_id
where e.status="Active"
and pr.emp_id is null
group by e.emp_id,e.emp_name,d.department_name
having avg(p.rating)>=4 and 
(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)))>=85;

#18 . Top performers
select p.rating,e.emp_id,e.emp_name
from performance p
join employees e on p.emp_id=e.emp_id
where e.status="Active"
group by p.rating,e.emp_id,e.emp_name
having p.rating >= 4 ;

#19.Promotion list
    SELECT e.emp_id,e.emp_name,
    CASE WHEN pr.emp_id IS NULL THEN 'Not Promoted'
	ELSE 'Promoted'
    END AS promotion_status
FROM employees e
LEFT JOIN promotions pr ON e.emp_id = pr.emp_id;

#20. Total employees
select emp_id,emp_name,status
from employees ;

#21. Active employees
select emp_id,emp_name,status
from employees 
where status="active";
  
  #21. Resigned employees
select emp_id,emp_name,status
from employees 
where status="resigned";

#22. Manager performance
select e.manager_id,e.emp_name,p.rating
from employees e
join performance p on e.emp_id=p.emp_id
group by e.manager_id,e.emp_name,p.rating;

#23. Attendance%
select e.emp_id,e.emp_name,
round(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)),2) as attendance_percentage
from employees e
join attendance a on a.emp_id=e.emp_id
group by e.emp_id,e.emp_name;

#24. Overall turnover
select round(sum(case when status='Resigned' 
then 1 else 0 end)*100/count(*),2) as Tutnover_rate_percentage
from employees;

#25.Turnover count
select count(*) as Total_resigned
from employees
where status='Resigned';

#26. Turnover by department
select d.department_name,
count(case when e.status='Resigned'then 1 end) as Resigned_count
from employees e
join departments d on e.department_id=d.department_id
group by d.department_name;

#27. Turnover by gender
select gender,
count(case when status='Resigned'then 1 end) as Resigned_count
from employees 
group by gender ;

#28. Active vs Resigned (Workforce stability)
select status,count(*) as Total
from employees e
group by status ;

#29. Turnover rate by Department
select d.department_name,count(e.emp_id) as Total_employees,
sum(case when e.status='Resigned' then 1 else 0 end) as resigned,
round(sum(case when e.status='Resigned' then 1 else 0 end)*100.0/count(e.emp_id),2) as turnover_rate
from employees e
join departments d on e.department_id=d.department_id
group by d.department_name ;

#30. Turnover rate by Department
select Gender ,count(emp_id) as Total_employees,
sum(case when status='Resigned' then 1 else 0 end) as resigned,
round(sum(case when status='Resigned' then 1 else 0 end)*100.0/count(emp_id),2) as turnover_rate
from employees 
group by Gender;

#31. Early turnover( Employees who left quickly after joining)
select emp_name,
DATEDIFF(CURDATE(), hire_date) / 365 AS tenure_years
FROM employees
WHERE status = 'Resigned'
AND DATEDIFF(CURDATE(), hire_date) / 365 < 2;
#  or
SELECT emp_name,
ROUND(DATEDIFF(CURDATE(), hire_date) / 365, 2) AS tenure_years
FROM employees
WHERE status = 'Resigned'
AND DATEDIFF(CURDATE(), hire_date) < 730;

#32. Do higher performance (rating >=4) resign  more or less
Select e.emp_name,P.perf_id,P.rating
from employees e
join Performance P on e.emp_id=P.emp_id
where status='Resigned' and P.rating >=4
group by e.emp_name,P.perf_id,P.rating ;

#33. Manager performance bassed on team ratings
select m.emp_id as Manager_id,
       m.emp_name as Manager_name,
round(Avg(p.rating),2) as Team_Avg_Rating
from employees e
join employees m on e.manager_id=m.emp_id
join performance p on e.emp_id=p.emp_id
group by m.emp_id,m.emp_name;

#34. Manager performance by department
select  m.emp_id as Manager_id,
       m.emp_name as Manager_name,
       d.department_name,
round(Avg(p.rating),2) as Team_Avg_Rating
from employees e
join employees m on e.manager_id=m.emp_id
join departments d on m.department_id=d.department_id
join performance p on e.emp_id=p.emp_id
group by m.emp_id,m.emp_name,d.department_name ;

#35. Manager performance by department including team size
select m.emp_id as Manager_id,
       m.emp_name as Manager_name,
       count(Distinct e.emp_id) as team_size,
round(Avg(p.rating),2) as Team_Avg_Rating
from employees e
join employees m on e.manager_id=m.emp_id
join performance p on e.emp_id=p.emp_id
group by m.emp_id,m.emp_name ;

#36. Manager ranking
SELECT *, RANK() OVER(ORDER BY team_avg_rating DESC) AS manager_rank
FROM ( SELECT 
        m.emp_id AS manager_id,
        m.emp_name AS manager_name,
        COUNT(DISTINCT e.emp_id) AS team_size,
        ROUND(AVG(p.rating), 2) AS team_avg_rating
    FROM employees e
    JOIN employees m ON e.manager_id = m.emp_id
    JOIN performance p ON e.emp_id = p.emp_id
    GROUP BY m.emp_id, m.emp_name) t;
    
    #37. Department headcount trend (using CTE)
    with headcount_cte as(select d.department_name,
						year(e.hire_date) as year,
                        count(e.emp_id) as headcount
    from employees e
    join departments d on e.department_id=d.department_id
    group by department_name,year(e.hire_date))
    select *from headcount_cte
    order by department_name,year;
    
    #38. Performance trend(YOY) using self join
    select e.emp_name,
           P1.year as Current_year,
           p1.rating as Current_rating,
           p2.rating as prev_rating,
           p1.rating-p2.rating as YOY_change
	from Performance p1
    join performance p2 on p1.emp_id=p2.emp_id
				       and p1.year=p2.year+1
	join employees e on p1.emp_id=e.emp_id;
    
#39. Performance trend(YOY) using self join
with perf_data as( select emp_id,year,rating 
from performance)
select e.emp_name,p1.year,p1.rating,
       p2.rating as prev_rating,
       p1.rating-p2.rating as YOY_change
from perf_data p1
join perf_data p2 on p1.emp_id=p2.emp_id
                and p1.year=p2.year+1
join employees e on p1.emp_id=e.emp_id ;

#40. Attendance ranking
select*,
rank() over(order by attendance_pct desc) as Attendance_rank
from (select e.emp_id,e.emp_name,
      round(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)),2) as attendance_pct
from employees e
join attendance a on e.emp_id=a.emp_id
group by e.emp_id,e.emp_name)t;
		
#41. Top 3 attendance employees
select*from(select e.emp_name,
            round(sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)),2) as attendance_pct,
            rank() over( order by sum(a.presents)*100.0/(sum(a.presents)+sum(a.absents)) desc) as rnk
from employees e
join attendance a on e.emp_id=a.emp_id
group by e.emp_name)t
where rnk <= 3;              
		
#42. Salary Percentile ranking
select emp_id,emp_name,salary,
       percent_rank() over(order by salary) as salary_percentile
from employees ;
       
#43. Percentile by Department
select emp_id,emp_name,department_id,salary,
       percent_rank() over( partition by department_id order by salary) as dept_percentile
from employees ;

#44. Salary perntile with salary category
select emp_name,salary,
       percent_rank() over(order by salary) as perntile,
case   when percent_rank() over(order by salary)>=0.8 then'Top 20%'
       when percent_rank() over(order by salary)>=0.5 then 'Mid Range'
       else 'Low range'
end as Salary_Category
from employees ;

alter use 'root' @ 'localhost'
identified with  Mysql_native_password
by 'Kanika@123';

    