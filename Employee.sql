create table employee1 (
    name VARCHAR(10) not NULL,
    sirname VARCHAR(10) not null,
    emp_id integer not NULL,
    experience date,
    salary money
);

create table employee2 (
    name VARCHAR(10) not NULL,
    sirname VARCHAR(10) not null,
    emp_id serial not NULL,
    experience date,
    salary money
);

INSERT INTO
    employee1 (
        name,
        sirname,
        emp_id,
        experience,
        salary
    )
VALUES (
        'Alex',
        'Johnson',
        001,
        '2026-07-01',
        75000.00
    ),
    (
        'Sarah',
        'Smith',
        002,
        '2021-07-02',
        68000.00
    ),
    (
        'Michael',
        'Chang',
        003,
        '2026-06-03',
        90000.00
    ),
    (
        'Team',
        'Cook',
        004,
        '2026-07-08',
        30000.00
    );

INSERT INTO
    employee2 (
        name,
        sirname,
        emp_id,
        experience,
        salary
    )
VALUES (
        'Johnson',
        'Alex',
        001,
        '2026-07-01',
        75000.00
    ),
    (
        'Smith',
        'Sarah',
        002,
        '2021-07-02',
        68000.00
    ),
    (
        'Chang',
        'Michael',
        003,
        '2026-06-03',
        90000.00
    ),
    (
        'Cook',
        'Team',
        004,
        '2026-07-08',
        30000.00
    );

select * from employee2;

--set operation 1)union-combine(sorting)-slower and remove dublicate
select name
from employee1
UNION
select name
from employee2
order by name;
--unionall-combine keep duplicate(not sorting/duplication)-faster
select sirname
from employee1
union ALL
select sirname
from employee2;

select emp_id, experience
from employee1
UNION all
select emp_id, experience
from employee2;

--casting: unfortunately 2 column has diff data type in diff queries in union
select CAST(emp_id as integer)
from employee1
UNION
select emp_id
from employee2
ORDER BY emp_id;

--intersect-most common rows between two tables
SELECT name, sirname
FROM employee1
INTERSECT
SELECT name, sirname
from employee2;

select experience
from employee1
INTERSECT
select experience
from employee2
ORDER BY experience;

select emp_id
from employee1
INTERSECT
select emp_id
from employee2
order by emp_id;

select name, sirname
from employee1
except
SELECT name, sirname
from employee2;

SELECT emp_id from employee1 except SELECT emp_id from employee2;