-- LeetCode Homework

-- 175. Combine Two Tables
-- https://leetcode.com/problems/combine-two-tables/
select p.FirstName, p.LastName, a.City, a.State
from Person p
left join Address a
on p.PersonId = a.PersonId;

-- 176. Second Highest Salary
-- https://leetcode.com/problems/second-highest-salary/
select max(salary) SecondHighestSalary
from Employee
where salary < (select max(salary) from Employee);

-- 178. Rank Scores
-- https://leetcode.com/problems/rank-scores/
-- Notes:
-- Many simple solutions in the discussion forum used DENSE_RANK() window function. In a real world job interview, the interviewer will probably ask you to solve this without using the window function. The difficulty is moderate and I encourage you to solve this question using only other things that we have learned from the class.
-- Hint: Deduplicate and then join the table with itself, and count how many numbers are smaller than a given number.
with scores_dedup as (
    select distinct score from scores
),
ranks as (
    select l.score, count(*) rank
    from scores_dedup l, scores_dedup r
    where l.score<=r.score
    group by l.score
)
select s.score, r.rank
from Scores s
join ranks r
on s.score = r.score
order by r.rank;

-- 180. Consecutive Numbers
-- https://leetcode.com/problems/consecutive-numbers/
select distinct l.Num ConsecutiveNums
from Logs l
join Logs l1 on (l.id -1 = l1.id and l.Num=l1.Num)
join Logs l2 on (l.id -2 = l2.id and l.Num=l2.Num);

with t as (select num, lead(num) over (order by id) lead_name, lag(num) over (order by id) lag_name
from logs)
select distinct num as ConsecutiveNums
from t
where num = lead_name and lag_name = lead_name;

-- 181. Employees Earning More Than Their Managers
-- https://leetcode.com/problems/employees-earning-more-than-their-managers/
select l.Name as Employee
from employee l
join employee m
on l.managerid = m.id
where l.salary > m.salary;

-- 182. Duplicate Emails
-- https://leetcode.com/problems/duplicate-emails/
select email
from person
group by email
having count(email) <> 1;

-- 183. Customers Who Never Order
https://leetcode.com/problems/customers-who-never-order/
select c.name as customers
from customers c
where c.id not in (select distinct customerId from orders );

-- 184. Department Highest Salary
-- https://leetcode.com/problems/department-highest-salary/
with t as (select d.name as Department, e.name as Employee, e.salary, rank() over (partition by  DepartmentId order by salary desc) as rank
from employee e
join department d
on e.departmentid = d.id)
select Department, Employee, salary
from t
where rank = 1;


-- 185. Department Top Three Salaries
-- https://leetcode.com/problems/department-top-three-salaries/
-- Hint: This seems similar to Q178.
with t as (select d.name as department, e.name as employee, salary, dense_rank() over (partition by d.id order by salary desc) as rank
from employee e
join Department d
on e.departmentid = d.id)
select department, employee, salary
from t
where rank <= 3;



-- 197. Rising Temperature
-- https://leetcode.com/problems/rising-temperature/
select a.id
from Weather a
join Weather b
on a.recordDate - 1 = b.recordDate
where a.temperature > b.temperature;


## 262. Trips and Users

https://leetcode.com/problems/trips-and-users/

with t as (select Id, Client_Id, Driver_Id, Status, Request_at, u.Banned as cbanned, u2.Banned as dbanned
from Trips t
join Users u
on t.Client_Id = u.Users_Id
join Users u2
on t.Driver_Id = u2.Users_Id
where u.Banned = 'No' and u2.Banned = 'No')
select t1.Request_at as Day, round((1 - cno/tno),2) as "Cancellation Rate"
from
(select Request_at, count(1) as tno
from t
group by Request_at) t1
join
(select Request_at, status, count(status) as cno
from t
group by Request_at, status
having status = 'completed') t2
on t1.Request_at = t2.Request_at;




-- 595. Big Countries
-- https://leetcode.com/problems/big-countries/
select name, population,area
from world
where area > 3000000 or population > 25000000;

-- 596. Classes More Than 5 Students
-- https://leetcode.com/problems/classes-more-than-5-students/
with t as (select *
from courses
group by student,class
having count(*) = 1)
select class
from
(select class, count(*) as cnt
from t
group by class)
where cnt >=5;

-- 601. Human Traffic of Stadium
-- https://leetcode.com/problems/human-traffic-of-stadium/
with t as (select id, visit_date, people, lead (people) over (order by id) as next1
, lag (people) over (order by id) as pre1 from Stadium)
select t.id, to_char(t.visit_date,'YYYY-MM-DD') as visit_date, t.people
from t
left join Stadium s
on t.id = s.id - 2
left join Stadium s2
on t.id = s2.id + 2
where (t.people >= 100 and next1 >= 100 and s.people >= 100)
or (t.people >= 100 and next1 >= 100 and pre1 >= 100)
or (t.people >= 100 and pre1 >= 100 and s2.people >= 100)
order by t.id;





-- 620. Not Boring Movies
-- https://leetcode.com/problems/not-boring-movies/
select id, movie, description, rating
from cinema
where mod(id,2) = 1 and description <> 'boring'
order by rating desc;



-- 626. Exchange Seats
-- https://leetcode.com/problems/exchange-seats/
with t as (select id, student, lead(student) over (order by id) lead_name, lag(student) over (order by id) lag_name from seat)
select id, lead_name as student
from t
where mod(id,2) = 1 and lead_name is not null
union
select id, lag_name as student
from t
where mod(id,2) = 0 and lag_name is not null
union
select id, student
from t
where mod(id,2) = 1 and lead_name is null;


-- 627. Swap Salary
-- https://leetcode.com/problems/swap-salary/
UPDATE salary set sex = case sex when 'f' then 'm' else 'f'end ;


-- 1179. Reformat Department Table
-- https://leetcode.com/problems/reformat-department-table/
-- Hint: You may have learned pivot table in Excel which seems applicable to solve this question, and thus you may be tempted to learn how to do pivot table in Oracle. While Oracle does support pivot table, I encourage you to find a solution using only what we have learned in class.
SELECT
    id,
    MIN(CASE month WHEN 'Jan' THEN revenue ELSE NULL END) Jan_Revenue,
    MIN(CASE month WHEN 'Feb' THEN revenue ELSE NULL END) Feb_Revenue,
    MIN(CASE month WHEN 'Mar' THEN revenue ELSE NULL END) Mar_Revenue,
    MIN(CASE month WHEN 'Apr' THEN revenue ELSE NULL END) Apr_Revenue,
    MIN(CASE month WHEN 'May' THEN revenue ELSE NULL END) May_Revenue,
    MIN(CASE month WHEN 'Jun' THEN revenue ELSE NULL END) Jun_Revenue,
    MIN(CASE month WHEN 'Jul' THEN revenue ELSE NULL END) Jul_Revenue,
    MIN(CASE month WHEN 'Aug' THEN revenue ELSE NULL END) Aug_Revenue,
    MIN(CASE month WHEN 'Sep' THEN revenue ELSE NULL END) Sep_Revenue,
    MIN(CASE month WHEN 'Oct' THEN revenue ELSE NULL END) Oct_Revenue,
    MIN(CASE month WHEN 'Nov' THEN revenue ELSE NULL END) Nov_Revenue,
    MIN(CASE month WHEN 'Dec' THEN revenue ELSE NULL END) Dec_Revenue
FROM Department
GROUP BY id;

SELECT *
from department
pivot
(avg(revenue)
FOR  month in ('Jan' as Jan_Revenue,'Feb' as Feb_Revenue ,'Mar' as  Mar_Revenue,'Apr'as Apr_Revenue,
'May'as May_Revenue,'Jun'as Jun_Revenue,'Jul'as Jul_Revenue,'Aug'as Aug_Revenue,'Sep' as Sep_revenue,
'Oct' as Oct_Revenue,'Nov' as Nov_Revenue,'Dec' as Dec_Revenue));