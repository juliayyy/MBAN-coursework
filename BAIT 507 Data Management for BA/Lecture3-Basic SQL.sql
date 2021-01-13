-- Agenda
-- SELECT and ORDER BY
-- Working with Numbers
-- Working with Conditions
-- Working with Strings
-- How to prepare for Tech Interviews

-- Select columns
SELECT * from albums;
SELECT name, price from albums;

-- Select Distinct
SELECT DISTINCT

-- Sort Results
SELECT name, year, price
FROM albums
ORDER BY year ASC, price DESC;

SELECT name, year, price
FROM albums
ORDER BY year, price DESC;

SELECT name, year, price
FROM albums
ORDER BY 2 ASC, 3 DESC;

-- Exercise
SELECT country from musicians where ROWNUM = 1 order by awards desc;

-- Working with Numbers
-- + - * /
SELECT * FROM DUAL;
SELECT 1+2 FROM DUAL;
SELECT 1+2 AS RESULT FROM DUAL;
SELECT 1+2 RESULT FROM DUAL;
-- Arithmetic Operator Precedence
-- From high to low
-- *, /
-- +,-
ABS(-10)
ABS(10)
MOD(10,3)
MOD(ABS(x), 2)

-- MOD(dividend, divider) possible values of results: result is an integer in {0, 1, ..., divider – 1}
MOD(0, divider) = 0
MOD(x, 1) = 0
MOD(x, 2) = 0, 1
MOD(x, 10) = 0, 1, ..., 9

-- MOD(x, 2) Application: Odd Number or Even Number
MOD(Even Number, 2) = 0
MOD(Odd Number, 2) = 1
-- MOD(x, 10) Application: Get the last digit(s) of a number
MOD(x, 10) = last digit of x
MOD(x, 100) = last two digits of x

-- MOD(x, n) Application: Divide data into n groups
SELECT MOD(Student_ID, 3) AS stu_group FROM Students

-- Working with Conditions
-- =, >, >=, <, <= , <>
-- Where: Use for filtering in SELECT, DELETE, and UPDATE
SELECT name
From Musicicians
Where Country = 'Canada';

--EX:
-- Find “Pop” genre albums whose price is larger than 10.
SELECT *
FROM albums
WHERE genre = 'Pop' and price > 10;
-- Find musicians from North American countries.
SELECT name
FROM musicians
WHERE country in ('US','Canada');
-- Find albums that are made in or after year 2010.
SELECT name
FROM albums
WHERE year >= 2010;

-- CASE WHEN THEN ELSE END
SELECT
    CASE
        WHEN tips > 100 THEN 'extraordinary'
        WHEN tips > 50 THEN 'high'
        WHEN tips > 10 THEN 'medium'
        ELSE 'low'
    END AS tip_category,
    tip, bill
FROM restaurant_payments;

-- EX: Instead of assign payments to categories based on tip amount alone,
-- assign it according to the tip percentage (i.e., tip / bill)
-- >100%: extra-ordinary • 50% - 100%: high
-- 20% - 50%: medium
-- 0 - 20%: small
SELECT
    CASE
        WHEN tips / bill > 100% THEN 'extraordinary'
        WHEN tips / bill > 50% THEN 'high'
        WHEN tips / bill > 20% THEN 'medium'
        ELSE 'small'
    END AS tip percentage,
    tip / bill
FROM restaurant_payments;

-- Comparison Operators 2
-- Between and
-- In (list)
-- Like
-- IS NULL

-- Example:
-- Find albums made between years 2000 and 2010.
SELECT * FROM Albums WHERE year BETWEEN 2000 AND 2010;
-- Find musicians whose country is in this list:
SELECT * FROM Musicians WHERE COUNTRY IN (‘USA’, ‘Canada’)

-- Boolean Expression Operators:
-- And, Or, Not
-- Logical Operator Precedence: Not > AND > OR

-- Delete
CREATE TABLE ALBUMS_COPY AS
SELECT * FROM ALBUMS;

DELETE FROM ALBUMS_COPY
WHERE
YEAR < 2000;

-- Update
UPDATE albums SET price = 0
UPDATE albums SET price = 10*price
UPDATE albums SET price = 0, url=NULL
UPDATE albums SET price = 0 WHERE year<2000

-- Ex：
--Create another copy of the albums table.
create table ALBUMS_COPY1 as
SELECT * FROM ALBUMS;
--Find “Pop” albums made before 2000.
--Delete them from the table.
delete from ALBUMS_COPY1
Where
YEAR < 2000 and genre = 'Pop';

-- Working with Strings
-- String Concatenation: || operator
select
'James'||' '||'Bond' COMBINED_STRING
from
DUAL;
-- Special case: concat with empty string
select 'James' || '' || 'Bond' AS concat_with_empty
from dual;
-- UPPER and LOWER
-- UPPER(‘Hello’) = ‘HELLO’
-- LOWER(‘Hello’) = ‘hello’

--LENGTH(string)
LENGTH(‘Hello’) = 5

-- Special case
-- * This might produce different result in other DBs -- * In Oracle, empty string is NULL.
select length('') length_of_empty_string from dual;

-- SUBSTR(string, position, length)

-- Extract first character
SUBSTR(‘hello’, 1, 1) = ‘h’
-- Extract first two characters
SUBSTR(‘hello’, 1, 2) = ‘he’
-- Extract last character
SUBSTR(‘hello’, -1, 1) = ‘o’
-- Extract last two characters
SUBSTR(‘hello’, -2, 2) = ‘lo’

-- Exercise : Use substring to extract the highlighted characters
-- University
-- Business Analytics
SELECT SUBSTR('University',3,6) from DUAL;
SELECT SUBSTR('Business Analytics', 10, 9) from dual;

-- String Matching using LIKE
WHERE Name LIKE 'L%'
WHERE Name LIKE '%d'
WHERE Name LIKE '%li%'
WHERE Name LIKE 'L_'
WHERE Name LIKE 'L_ _'
WHERE Name LIKE '_ou_'
WHERE Name LIKE '_a%'

-- NOT LIKE, NOT IN
Name NOT LIKE ‘L%’
Country NOT IN (‘US’, ‘Canada’)

