-- Q1: Revising Aggregations - The Sum Function
-- https://www.hackerrank.com/challenges/revising-aggregations-sum/problem
select sum(population) from city where district in ('California');

-- Q2: Revising Aggregations - Averages
-- https://www.hackerrank.com/challenges/revising-aggregations-the-average-function/problem
select avg(population) from city where district = 'California';

-- Q3: Average Population
-- https://www.hackerrank.com/challenges/average-population/problem
select round(avg(population),0) from city

-- Q4: Japan Population
-- https://www.hackerrank.com/challenges/japan-population/problem
select sum(population) from city where countrycode = 'JPN';

-- Q5: Population Density Difference
-- https://www.hackerrank.com/challenges/population-density-difference/problem
select max(population) - min(population) from city;

-- Q6: The Blunder
-- https://www.hackerrank.com/challenges/the-blunder/problem
SELECT CEIL(AVG(Salary)-AVG(REPLACE(Salary,'0',''))) FROM EMPLOYEES;

-- Hint: Treat/Cast salary as string
--   use `REPLACE()` to replace `'0'` with `''` (empty string)
--   Treat/Cast the string result as number.
--   Example: `SELECT REPLACE(1020,'0','') FROM dual;`
--   Example result: `'12'`

-- Q7: Weather Observation Station 2
-- https://www.hackerrank.com/challenges/weather-observation-station-2/problem
select round(sum(lat_n),2), round(sum(long_w),2) from station;

-- Q8: Weather Observation Station 13
-- Hint: Use `TRUNC()` function to truncate numbers.
-- https://www.hackerrank.com/challenges/weather-observation-station-13/problem
select trunc(sum(lat_n),4) from station where lat_n < 137.2345 and lat_n > 38.7880;

-- Q9: Weather Observation Station 14
-- https://www.hackerrank.com/challenges/weather-observation-station-14/problem
select trunc(max(lat_n),4) from station where lat_n < 137.2345;

--Q10: Weather Observation Station 15
--https://www.hackerrank.com/challenges/weather-observation-station-15/problem
-- Use `ROUND()` function to ROUND numbers.
select round(long_w,4) from station where lat_n = (select max(lat_n) from station where lat_n < 137.2345);

-- Q11: Weather Observation Station 16
-- https://www.hackerrank.com/challenges/weather-observation-station-16/problem
select round(min(lat_n),4) from station where lat_n > 38.7780;

-- Q12: Weather Observation Station 17
-- https://www.hackerrank.com/challenges/weather-observation-station-17/problem
select round(long_w,4) from station where lat_n = (select min(lat_n) from station where lat_n > 38.7780);

-- Q13: Weather Observation Station 18
-- https://www.hackerrank.com/challenges/weather-observation-station-18/problem
-- Hint: `ABS()` gives absolute value
select round(abs(max(lat_n)-min(lat_n))+ abs(max(long_w)-min(long_w)),4) from station;

-- Q14: Weather Observation Station 19
-- https://www.hackerrank.com/challenges/weather-observation-station-19/problem
-- Hint: `SQRT()` calculates square root
select round(sqrt((max(lat_n)-min(lat_n))*(max(lat_n)-min(lat_n))+ (max(long_w)-min(long_w))*(max(long_w)-min(long_w))),4) from station;


-- Basic Join
-- Q15: Average Population of Each Continent
-- https://www.hackerrank.com/challenges/average-population-of-each-continent/problem
select country.continent, floor(avg(city.population)) from city join country on city.countrycode = country.code GROUP BY country.continent;


-- Q16: Top Competitors
-- https://www.hackerrank.com/challenges/full-score/problem
select h.hacker_id, h.name
from Submissions as s
join Hackers as h on s.hacker_id = h.hacker_id
join Challenges as c on s.challenge_id = c.challenge_id
join Difficulty as d on c.Difficulty_level = d.Difficulty_level
where s.score = d.score
group by h.hacker_id, h.name
having count(*) > 1
order by count(*) desc, h.hacker_id;


with t as (select challenge_id, hacker_id,c.difficulty_level, d.score as full_s
from challenges c
join difficulty d
on c.difficulty_level = d.difficulty_level),
t2 as (select s.hacker_id, name, s.challenge_id, score, full_s
from submissions s
join hackers h
on s.hacker_id = h.hacker_id
join t
on s.challenge_id = t.challenge_id),
t3 as (select hacker_id, name, count(*) cnt
from t2
where score = full_s
group by hacker_id, name)
select hacker_id, name
from t3
where cnt > 1
order by cnt desc, hacker_id;

-- Q17: Challenges
-- https://www.hackerrank.com/challenges/challenges/problem
-- The main difference between WHERE and HAVING clause comes when used together with GROUP BY clause,
-- In that case WHERE is used to filter rows before grouping and HAVING is used to exclude records after grouping.
-- This is the most important difference and if you remember this, it will help you write better SQL queries.
-- Read more: https://www.java67.com/2019/06/difference-between-where-and-having-in-sql.html#ixzz6ks3dUCgL
with t as (select c.hacker_id as id, h.name, count (*) as cnt
from challenges c
join hackers h on c.hacker_id = h.hacker_id
group by c.hacker_id,h.name
order by cnt desc, c.hacker_id)
select id, name, cnt
from t
where cnt = (select max(cnt) from t)
union
select id, name, cnt
from t
where cnt in (select cnt from t group by cnt having count(*) = 1)
order by cnt desc, id;

-- Q18: Contest Leaderboard
-- https://www.hackerrank.com/challenges/contest-leaderboard/problem
with t as (select s.hacker_id as hid, s.challenge_id as cid, h.name as name, max(score)as ms
from submissions s
join hackers h
on s.hacker_id = h.hacker_id
group by s.hacker_id, s.challenge_id, name)
select hid, name, sum(ms)
from t
group by hid, name
having sum(ms) <> 0
order by sum(ms) desc, hid;

-- Advanced Join

-- Q19: Placements
-- https://www.hackerrank.com/challenges/placements/problem
with t1 as (select s.id as mid, s.name as mname, f.friend_id as fid, p.salary as msalary
from students s
join friends f on s.id = f.id
join packages p on s.id = p.id)
select t1.mname
from t1
join packages s
on t1.fid = s.id
where t1.msalary < s.salary
order by s.salary;

select s.name
from students s
join friends f
on s.ID = f.ID
join packages p
on s.ID = p.ID
join packages p2
on f.friend_id = p2.id
where p.salary < p2.salary
order by p2.salary;

-- Q20: Symmetric Pairs
-- https://www.hackerrank.com/challenges/symmetric-pairs/problem
-- Hint: For rows `WHERE x=y`, `(x,y)` is symmetric ONLY if it appears `2+` times in the table.
-- Hint: You need to join the table with itself.
with t1 as (select x, y
from functions
where x < y),
t2 as (select x, y
from functions
where x > y),
t3 as (select x, y
from functions
group by x,y
having x = y and count(x) <> 1)
select t1.x, t1.y
from t1
join t2
on t1.x = t2.y and t1.y = t2.x
union (select * from t3);

with t1 as (select X, Y from functions where X < Y),
t2 as (select X, Y from functions where X > Y),
t3 as (select X, Y from functions where X = Y),
t4 as (select X, Y, count(*)cnt from t3 group by X,Y)
select t1.X, t1.Y
from t1
join t2
on t1.X = t2.Y and t1.Y = t2.X
union
select X, Y
from t4
where cnt > 1
order by X;

