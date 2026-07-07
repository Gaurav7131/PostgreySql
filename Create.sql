--create
CREATE TABLE worker (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    salary NUMERIC(10, 2),
    department TEXT NOT NULL
);
--insert
INSERT INTO
    worker (name, role, salary)
VALUES (
        0001,
        'Alex Johnson',
        'Developer',
        75000.00
    ),
    (
        0002,
        'Sarah Smith',
        'Designer',
        68000.00
    ),
    (
        0003,
        'Michael Chang',
        'Manager',
        90000.00
    ),
    (
        0004,
        'Team cook',
        'Salesman',
        30000.00
    );
--alter table(column_name)
ALTER TABLE worker ADD COLUMN address TEXT;

ALTER TABLE worker ADD COLUMN joining_date TIMESTAMP;

--Rename
ALTER TABLE worker RENAME address to experience;

--update default value
ALTER TABLE worker ALTER COLUMN experience SET DEFAULT ('_blank');
--add  not null contraints
ALTER TABLE worker ALTER COLUMN experience DROP NOT NULL;

--drop
DROP TABLE IF EXISTS author;

SELECT * FROM worker;

CREATE TABLE backup (name TEXT, id serial);
--cascade:remove dependant object and drops table
DROP TABLE IF EXISTS backup CASCADE;

CREATE TABLE backup2 (name TEXT, id serial);
--restrict prevent from dropping table if any obect exist(fix explicitly)
DROP TABLE IF EXISTS backup2 RESTRICT;

SELECT * FROM backup2;

--truncate-dlete entire db_data except schema,indexes,constraints,+performance
CREATE TABLE backup3 (
    name TEXT PRIMARY KEY,
    designation TEXT
);

TRUNCATE Table backup3;
--truncating no to 5.6 without rouding up.
SELECT TRUNC(5.678, 1);

SELECT * FROM backup3;
--i dont existing table's data but want existing table schema
CREATE TABLE new_worker AS SELECT * FROM worker where 1 = 0;

SELECT * from new_worker;
--order by(asc/desc)
SELECT * FROM worker ORDER BY salary ASC LIMIT 3;

alter table worker add column department TEXT;
--group by
select department, AVG(salary) as avg_salary
from worker
GROUP BY
    department;

select salary, max(salary) as max_salary
from worker
group by
    salary;

select department, min(salary) as min_salary
from worker
group by
    department;

--distinct-removes duplicate
select DISTINCT name from worker;

--column alias-edit column_name
select name as worker_name from worker;

--AND-combine two ops & both cond must be true and return result that with specified condn
select * from worker where salary >= 1000 AND name = 'Alex Johnson';

--IN-String matching
select * from worker where name IN ('Team cook');

--OR-at least one must be true
select * from worker where salary >= 10000 OR salary <= 100000;

--Like operator:string matcher return only given str as it is strictly
select * from worker where name like 'Ale%';

--between-RANGE
select *
from worker
where
    name like 'Te%'
    AND salary between 10000 AND 30000;

--not equal
SELECT * from worker WHERE name like 'Mich%' and salary >= 1000;

select DISTINCT name from worker where name like 'Mich%';

select name from worker where name LIKE '_ich%';
--ilike-return uppercase,lowercase,mixed
select name from worker where name ilike 'mic%';

--not equals
select * from worker where name like 'Te%' AND salary <> 10000;

SELECT * from worker where ROLE IS NOT NULL;