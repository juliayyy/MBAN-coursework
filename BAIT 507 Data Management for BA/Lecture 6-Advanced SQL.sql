-- Aggregate Functions
-- Group By and Having
-- CTE and Sub Query
-- Set Options

-- Aggregate Functions
-- “An aggregate function performs a calculation on a set of values, and returns a single value.
COUNT(*) -- aggregate functions ignore null values
SELECT count(*) cnt FROM albums; -- 25
SELECT count(1) cnt FROM albums; -- 25
SELECT count(name) cnt FROM albums; -- 25
SELECT count(DISTINCT name) FROM albums; -- 25
SELECT avg(price) AS avg_price FROM ALBUMS; -- 9.72
SELECT median(price) AS median_price FROM ALBUMS; -- 9
SELECT stddev(price) FROM ALBUMS; -- 2.9
SELECT sum(amount) AS revenue FROM Orders;
SELECT MAX(price) AS max_price FROM albums;
SELECT MIN(price) FROM albums;
SELECT avg(price*price) AS avg_price_squared FROM ALBUMS;
SELECT avg(price)
FROM Albums
WHERE year BETWEEN 2000 AND 2009;
SELECT
avg(price) avg_price,
max(price) max_price,
min(price) min_price,
median(price) median_price
FROM Albums
WHERE year BETWEEN 2000 AND 2009;

-- GROUP BY and HAVING
SELECT count(*) FROM Albums WHERE year = 2010;
SELECT count(*) FROM Albums WHERE year = 2015;
SELECT year, count(*) FROM Albums
WHERE year IN (2010, 2015)
GROUP BY year;

SELECT year, genre, count(*) cnt FROM Albums
WHERE year BETWEEN 2010 AND 2015
GROUP BY year, genre
ORDER BY year, genre;

-- When aggregate function or GROUP BY is used with SELECT, each selected columns must be one of the following:
--  Constant value or expression (e.g., SELECT 1+2 FROM ... GROUP BY ... )
-- A “group by” group
-- An expression of group by group(s) (e.g., SELECT year * 100 + month FROM ... GROUP BY year, month)
-- An aggregate function or expression

SELECT city, sum(amount) revenue
FROM SalesOrders
GROUP BY city
HAVING sum(amount) > 10000;

-- In Oracle, you can switch order of “GROUP BY” and “HAVING”.

-- CTE & Sub-Query
-- CTE
with pop_albums as ( select * from albums where genre = 'Pop')
select aid, name, year
from pop_albums;

-- Query with Subquery
select aid, name, year from (select * from albums where genre = 'Pop') pop_albums;

select * from albums where year = (select max(year) from albums);
select name, price, (select max(price) from albums) max_price,
round(price / (select max(price) from albums),2) as price_to_max_price_ratio
from albums;

select sum(awards) total_awards
from musicians m
join countries c
on m.country=c.country where c.region='North America';

select sum(awards) total_awards from musicians m
where country in
(select country
from countries
where region = 'North America');

-- EXISTS and NOT EXISTS
-- If there exists albums made after 2020 (current year),
-- we assume there is a data entry error and list none of the albums. Otherwise, list all albums.
-- Solution 1: select a scalar and compare to threshold
select * from albums
where (select max(year) from albums)<=2020;
-- Solution 2: use Exists
select * from albums where NOT EXISTS
(select * from albums where year > 2020);

-- Set operators
select * from musicians
  where name like 'L%'
union all
select * from musicians
  where name like 'A%';


select name from albums where year = 2000
union all
select name from albums where year = 2001
union all
select name from musicians where country = 'Canada';


with t as (
select 'Blue' color, '1,2,3' edges from dual
union all select 'Red', '2,2,1' from dual
union all select 'Yellow', '9,9,9' from dual
)
select * from t;