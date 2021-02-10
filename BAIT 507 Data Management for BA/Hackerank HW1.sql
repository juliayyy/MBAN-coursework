
-- Q1. Select All
-- https://www.hackerrank.com/challenges/select-all-sql/problem
select * from city;

-- Q2. Select By ID
-- https://www.hackerrank.com/challenges/select-by-id/problem
select * from city where ID = 1661;

-- Q3. Revising the Select Query I
-- https://www.hackerrank.com/challenges/revising-the-select-query/
select * from city where population > 100000 and countrycode = 'USA';

-- Q4. Revising the Select Query II
-- https://www.hackerrank.com/challenges/revising-the-select-query-2/problem
select name from city where population > 120000 and countrycode = 'USA';

-- Q5. Japanese Cities' Attributes
-- https://www.hackerrank.com/challenges/japanese-cities-attributes/problem
select * from city where countrycode = 'JPN';

-- Q6. Japanese Cities' Names
-- https://www.hackerrank.com/challenges/japanese-cities-name/problem
select name from city where countrycode = 'JPN';

-- Q7. Weather Observation Station 1
-- https://www.hackerrank.com/challenges/weather-observation-station-1/problem
select city,state from station;

-- Q8. Weather Observation Station 3
-- https://www.hackerrank.com/challenges/weather-observation-station-3/problem
-- Hint: In Oracle, you need the MOD() function to tell if a number is even number.
select distinct city from station where mod(ID,2) = 0;

-- Q9. Weather Observation Station 6
-- https://www.hackerrank.com/challenges/weather-observation-station-6/problem
-- Hint: Google for the SUBSTR() function, you can use it to get the first letter of city name.
select distinct city from station where substr(city,1,1) in ('A','E','I','O','U');
select distinct city from station where regexp_like(city, '^[AEIOUaeiou]');

-- Q10. Weather Observation Station 7
-- https://www.hackerrank.com/challenges/weather-observation-station-7/problem
-- Hint: similar as above. How to get the last letter? You can use SUBSTR together with LENGTH. Google for the documentation of these two functions. If you still cannot figure out, Google for "Oracle How to get last letter of string" or similar.
select distinct city from station where regexp_like(city, '[AEIOUaeiou]$');

-- Q11. Weather Observation Station 8
-- https://www.hackerrank.com/challenges/weather-observation-station-8/problem
-- Hint: combine above two questions.
select distinct city from station where regexp_like(city, '^[AEIOUaeiou].*[AEIOUaeiou]$');

-- Q12. Weather Observation Station 9
-- https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station where not regexp_like(city, '^[AEIOUaeiou]');

-- Q13. Weather Observation Station 10
-- https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct city from station where regexp_like(city, '[^AEIOUaeiou]$');

-- Q14. Weather Observation Station 11
-- https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station where not regexp_like(city, '^[AEIOUaeiou].*[AEIOUaeiou]$');

-- Q15. Weather Observation Station 12
-- https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct city from station where regexp_like(city,'^[^AEIOUaeiou].*[^AEIOUaeiou]$');

-- Q16. Higher Than 75 Marks
-- https://www.hackerrank.com/challenges/more-than-75-marks/problem
-- Hint: Use SUBSTR() in ORDER BY
select name from students where marks > 75
order by substr(name,-3,3),ID;

-- Q17. Employee Names
-- https://www.hackerrank.com/challenges/name-of-employees/problem
select name from employee order by name;


-- Q18. Employee Salaries
-- https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from employee where months < 10 and salary > 2000 order by employee_id;



-- Advanced SELECT
-- Q19. Type of Triangle

https://www.hackerrank.com/challenges/what-type-of-triangle/problem
Hint: Use "CASE WHEN ... THEN ... WHEN ... THEN ... END"
select case
    when (A + B <= C) or (B + C <= A )or (A + C <= B) then 'Not A Triangle'
    when A = B and B = C then 'Equilateral'
    when (A = B and B<>C) or (A = C and B<>C) or (B=C and A<>B) then 'Isosceles'
    else 'Scalene' end triangle_type
from TRIANGLES;

-- Q20. The PADS
-- https://www.hackerrank.com/challenges/the-pads/problem
-- Hint: consider using multiple SQL statements to solve this.
select name||'('||substr(occupation,1,1)||')'from occupations order by name;
select 'There are a total of ' || count (1) ||' '|| lower(occupation) ||'s.'
from occupations
group by occupation
order by count(occupation),occupation;

