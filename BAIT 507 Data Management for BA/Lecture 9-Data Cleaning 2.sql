-- Text Processing In Oracle
-- Regex Introduction
-- Regex Matching A Single Character • Regex Quantifiers
-- Regex Groups and Alternatives
-- Regex Functions in Oracle
-- Exercise

-- Text Processing In Oracle
with t as (
    select ' learn SQL ' s from dual
    union select 'Hello DATABASE' from dual
)
SELECT
    lower(s) s_lower, upper(s) s_upper, initcap(s) s_initcap,
    trim(s) s_trim, length(s) s_length, replace(s, ' ', '-') s_replace
from t;

-- NSTR(string , substring [, start_position [, occurrence]]) Search for position of substring

select
    instr(s, '#', 1, 1) first_pound_sign,
instr(s, '#', 1, 2) second_pound_sign from (
    select 'SQL#TEXT#PROCESSING' s from dual
); -- 4,9

-- Use CAST() to convert string and number
select
    cast(123 as varchar2(100)) num2str,
    cast('123' as int)  str2num
from dual;

-- Section 2: Regex Introduction
-- Find album names that contain digits.
select name from albums
where name like '%0%' or name like '%1%' or name like '%2%'
or name like '%3%' or name like '%4%' or name like '%5%'
or name like '%6%' or name like '%7%' or name like '%8%' or name like '%9%' ;

with test_data as (
select 'Best Hits of 2000' s from dual
union all select 'Forever 21' from dual
union all select '20 Dollars and 50 Cents' from dual union all select 'R2D2' from dual
union all select 'C3-PO' from dual
union all select 'You Are My Only 1' from dual
)
select
s, regexp_substr(s, '\d{2,}', 1, 1) substr1,
regexp_substr(s, '\d{2,}'  , 1, 2) substr2,
regexp_substr(s, '\d{2,}' , 1, 3) substr3
from test_data where regexp_like(s, '\d{2,}');

-- Section 3: Regex Matching A Single Character

select name from albums
where regexp_like(name, '[AEIOUaeiou]');
-- Find album names that contains a vowel character (i.e., AEIOU) in lower or upper case.

-- Negation of Character Sets and Ranges
[^aeiou]
-- Find album names that contains a non-vowel character in lower or upper case.
select name from albums
where regexp_like(name, '[^AEIOUaeiou]');
-- Find album names that does not contain any vowel character in lower or upper case.
select name from albums
where not regexp_like(name, '[AEIOUaeiou]');

-- Meta-Characters
Meta- Character
Definition
Explanation
. [^\n] Any character (except \n unless certain special options are enabled)
\d [0-9] Any digit
\D [^0-9] Any non-digit character
\w [A-Za-z0-9_] Any word character
\W [^A-Za-z0-9_] Any non-word character
\s [\t\n\r\f ] Any space character
\S [^\t\n\r\f ] Any non-space character

-- Example: Find album names that contains a digit.
-- Solution 1
select name from albums
where regexp_like(name, '\d');
-- Solution 2
select name from albums
where regexp_like(name, '[0-9]');

-- Anchors
^ Start of string
$ End of string

-- Example
-- Find album names that start or end with a vowel.
select name from albums
where regexp_like(name, '^[aeiouAEIOU]')
or regexp_like(name, '[aeiouAEIOU]$');

-- Find album name that does not start with a vowel and does not end with a vowel.
select name from albums
where regexp_like(name, '^[^aeiouAEIOU]')
and regexp_like(name, '[^aeiouAEIOU]$');

-- Escaping Special Characters
-- What if you want to match plain “.” or other special characters?
-- First Solution: enclose them in square brackets.
select * from t where regexp_like(s, '[][)(}{.,^]');
-- Second Solution: Use escape sequences.
select * from t where regexp_like(s, '\.');

-- Regular Characters, Multiple Characters
select name from albums
where regexp_like(lower(name), 'm[aeiou][aeiou]n');

-- Section 4: Regex Quantifiers
-- Example: Find album names that contain a four letter substring “m__n”, where the first letter is m, the last letter is n,
-- and the middle two letters are any vowels. Make this query case insensitive.

-- Solution 1: Without Quantifiers
select name from albums
where regexp_like(lower(name), 'm[aeiou][aeiou]n');

-- Solution 2: With Quantifiers
select name from albums
where regexp_like(lower(name), 'm[aeiou]{2}n');

-- Example: Find album names that contain a two letter substring “nn”. Make this query case insensitive.

-- Solution 1: Without Quantifiers
select name from albums
where regexp_like(name, 'NN', 'i');
-- Solution 2: With Quantifiers
select name from albums
where regexp_like(name, 'N{2}', 'i');

-- Regex Quantifiers
? 0 or 1 times
* 0 or more times
+ 1 or more times
{m} Exactly m times
{m, n} At least m and at most n times
{m, } At least m times
 https://evol.bio.lmu.de/_teaching/perl/day8/meta_chars.pdf

-- Example: Find album names that contain the word “color” or the British English equivalent “colour”.
-- Make this query case insensitive.
select name from albums
where regexp_like(name, 'colou?r', 'i');

-- Section 5: Regex Groups
-- Example: Find musician whose name starts with “Chris” or “Christopher”.
-- Solution 1: Two Patterns
select name from musicians
where regexp_like(name, '^Chris')
   or regexp_like(name, '^Christopher');
-- Solution 2: Alternatives in a Group
select name from musicians
where regexp_like(name, '^(Chris|Christopher)');
-- Solution 3: Optional Group
select name from musicians
where regexp_like(name, '^Chris(topher)?');

-- Back Reference Example: Find musician names that contain a four letter substring
-- where the first letter is identical to the fourth,
-- and the second letter is identical to the third. Make this query case insensitive.
select name from musicians
where regexp_like(name, '([a-z])([[a-z])\2\1', 'i');

-- Section 5: Regex Functions In Oracle
with test_data as (
select 'Anna Santos' name from dual
union all select 'Joanna Pacitti' from dual union all select 'Justin Bieber' from dual union all select 'Celine Dion' from dual
)
select name,
regexp_substr(name, '([a-z])([a-z])\2\1') substr_default, regexp_substr(name, '([a-z])([a-z])\2\1', 1, 1, 'i') substr1, regexp_substr(name, '([a-z])([a-z])\2\1', 1, 2, 'i') substr2
from test_data
where regexp_like(name, '([a-z])([a-z])\2\1', 'i');

-- Regexp_Replace
with test_data as (
    select 'Anna Santos' name from dual
    union all select 'Joanna Pacitti' from dual
    union all select 'Justin Bieber' from dual
    union all select 'Celine Dion' from dual
)
select name,
regexp_replace(name, '([a-z])([a-z])\2\1', '****') rep_default, regexp_replace(name, '([a-z])([a-z])\2\1', '****', 1, 1, 'i') rep1, regexp_replace(name, '([a-z])([a-z])\2\1', '****', 1, 2, 'i') rep2, regexp_replace(name, '([a-z])([a-z])\2\1', '****', 1, 0, 'i') rep0
from test_data
where regexp_like(name, '([a-z])([a-z])\2\1', 'i');

-- REGEXP_INSTR
with test_data as (
select 'Anna Santos' name from dual
union all select 'Joanna Pacitti' from dual union all select 'Justin Bieber' from dual union all select 'Celine Dion' from dual
)
select name,
    regexp_instr(name, '([a-z])([a-z])\2\1') instr_default,
    regexp_instr(name, '([a-z])([a-z])\2\1',  1, 1, 0, 'i') instr1_0,
    regexp_instr(name, '([a-z])([a-z])\2\1',  1, 1, 1, 'i') instr1_1,
    regexp_instr(name, '([a-z])([a-z])\2\1',  1, 2, 0, 'i') instr2_0,
    regexp_instr(name, '([a-z])([a-z])\2\1',  1, 2, 1, 'i') instr2_1
from test_data
where regexp_like(name, '([a-z])([a-z])\2\1', 'i');

-- ex: triangles
with triangles as(
    select '2,3,4' edges from dual
    union all select '4,4,4' from dual
    union all select '5,5,7' from dual
    union all select '2,2,4' from dual),
t as (select
    cast (substr(edges, 1, 1) as int) a
    cast (substr(edges, 3, 1) as int) b
    cast (substr(edges, 5, 1) as int) c
 from triangles)
 select * from t;


-- ex: triangles
with triangles as(
    select '2,3,4' edges from dual
    union all select '4,4,4' from dual
    union all select '5,5,7' from dual
    union all select '2,10,4' from dual),
-- use instr to find the position of commas
-- use position of commas
select
    cast (regexp_substr(edges, '\d+',1,1) as int) a
    cast (regexp_substr(edges, '\d+',1,2) as int) b
    cast (regexp_substr(edges, '\d+',1,3) as int) c
from triangles


