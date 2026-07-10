create table employee1 (
    name VARCHAR(10) not NULL,
    sirname VARCHAR(10) not null,
    emp_id integer not NULL,
    experience date,
    salary money
);

create table employee2 (
    name VARCHAR(10),
    sirname VARCHAR(10),
    emp_id serial,
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

--Inner query(subquery)
select emp_id, name, sirname, salary
from employee1
where
    salary > (
        SELECT min(salary)
        from employee1
    );

select emp_id, name, experience
from employee2
where
    experience < (
        select max(experience)
        from employee2
    );

select emp_id, name, experience, salary
from employee1
where
    experience IN (
        select experience
        from employee1
    );

SELECT emp_id, name, salary
from employee2
where
    salary BETWEEN (
        select min(salary) --lower inner query
        from employee2
    ) AND (
        SELECT max(salary) --upper inner query
        from employee2
    );

select name, experience
from employee1
where
    experience between (
        select min(experience) --lower boudary
        from employee1
    ) AND (
        select max(experience) --upper boudary
        from employee1
    );

alter table employee1 add column project text;

insert into employee1 (project) values ('java');

select project from employee1;

--exists(1 row ignore rest)
SELECT name, sirname, emp_id
FROM employee1 e
WHERE
    NOT EXISTS (
        SELECT 1
        FROM project p
        WHERE
            p.emp_id = e.emp_id
    );

--any(1 column mln rows but have one column in any)
select *
from employee2
where
    salary < ANY ( --salary is less than emp_id1
        select salary
        from employee2
        where
            emp_id = 1
    );

alter TABLE employee2 ADD column age BIGINT NOT NULL;

insert into
    employee2
VALUES (
        'rj',
        'raghav',
        006,
        '2012-02-06',
        60000.00,
        33
    );

insert into
    employee2
VALUES (
        'Sequel',
        'F0rd',
        008,
        '2012-02-06',
        60000.00,
        37
    );

select age from employee2;
--ALL(And like work every value must be true to specify the cond met)
select emp_id, name, salary, age
from employee2
where
    age <= ALL (
        select max(age)
        from employee2
        where
            emp_id = 6
    );

select emp_id, name, age
from employee2
where
    age >= all (
        select avg(age)
        from employee2
    );

--update(set)
update employee1 SET name = 'Xavior' where name = 'Team';

update employee1
set
    name = 'Team'
where
    name = 'Xavior'
    and sirname = 'Cook';

update employee1
set
    sirname = 'David'
where
    sirname = 'Smith';

select name, sirname from employee1;

update employee2 set age = 34 where age = 33 returning *;

update employee2 set emp_id = 007 where emp_id = 008 RETURNING *;

select emp_id from employee2;

--Upsert(update+insert)
ALTER table employee2 add PRIMARY KEY (emp_id);

insert into
    employee2 (emp_id, name, sirname)
VALUES ('007', 'Elon', 'Musk')
ON CONFLICT (emp_id) DO
UPDATE
set
    name = EXCLUDED.name,
    sirname = EXCLUDED.sirname;

ALTER table employee1 add PRIMARY KEY (emp_id);

insert into
    employee1 (emp_id, name, sirname)
VALUES ('007', 'Radhe', 'Shyam')
ON CONFLICT (emp_id) DO
UPDATE
set
    name = excluded.name,
    sirname = excluded.sirname;

insert into
    employee1 (age, name)
VALUES (29, 'Raj') NO conflict (age) DO NOTHING;
--if-then direct logic using Case
select
    emp_id,
    salary,
    CASE
        WHEN age > 35 THEN 'high'
        when age <= 34 THEN 'Medium'
        ELSE 'Low'
    END as salary_categories
from employee2;

select age from employee2;
--if-then condn logic in pg/pgslq
CREATE OR REPLACE FUNCTION categorize_score(score INT)
RETURNS TEXT AS $$
DECLARE
    category TEXT;
BEGIN
    IF score >= 90 THEN
        category := 'A';
    ELSIF score >= 80 THEN
        category := 'B';
    ELSIF score >= 70 THEN
        category := 'C';
    ELSE
        category := 'D';
    END IF;
    RETURN category;
END;
$$ LANGUAGE plpgsql;

select categorize_score (90);
--example 2
CREATE OR replace FUNCTION match_score(score INT)
RETURNS  text as $$
DECLARE
RESULT text;
BEGIN
IF score>=90 THEN
RESULT:='Win';
ELSIF score>=80 THEN
RESULT:='Probability';
ELSE
RESULT:='Lost';
END IF;
RETURN RESULT;
END;
$$LANGUAGE PLPGSQL;

select match_score(200);

--example 2 
CREATE OR REPLACE FUNCTION vote_eligible(age INT)
RETURNS text AS '
DECLARE
    RESULT text;
BEGIN
    IF age >= 18 THEN
        RESULT := ''Eligible to vote'';
    ELSIF age < 18 THEN
        RESULT := ''Not eligible to vote'';
    ELSE
        RESULT := ''Wait for age'';
    END IF;
    
    RETURN RESULT;
END;
' LANGUAGE plpgsql;

SELECT vote_eligible(25);
--Label(loop)

do $$
declare
  n integer:= 6;

cnt integer := 1;

begin
loop  
 exit when cnt = n ;
 raise notice '%', cnt;  
 cnt := cnt + 1 ;  
end loop;  
end;

$$;