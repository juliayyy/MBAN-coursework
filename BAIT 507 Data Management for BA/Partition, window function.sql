-- Window can be empty, i.e., over() without “partition by” • Similar to aggregate query without “group by”
-- Window can be partitioned by multiple columns
-- Similar to “group by” with multiple columns
-- You can only call Window functions in SELECT
-- You cannot call them in WHERE, ORDER BY, etc.
-- How to overcome this limitation?
-- Aggregate functions covered in this class can also be used as Window functions
-- E.g., SUM, MAX, MIN, COUNT, ...

-- Rolling window function
select name, year, price,
round(avg(price) over(partition by year),2)
as avg_price_year,
round(avg(price) over(partition by year order by name),2)
as rolling_avg_price_year
from albums
where year >= 2015
order by year, name;

-- Ranking Window Functions
select name, year, price,
    row_number() over(
        partition by year
order by price ) as r
from albums
where year >= 2015
order by year, price;
-- Try replace row_number() by rank() and dense_rank(). -- What is the difference?


-- Value Window Functions
select name, year,
lead(name) over (partition by year order by name) lead_name, lag(name) over (partition by year order by name) lag_name
from albums
where year IN (2015, 2019);