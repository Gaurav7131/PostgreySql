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

DO $$
DECLARE
  cnt INTEGER := 1;  
BEGIN
  LOOP  
    -- Exit the loop when cnt reaches 8
    EXIT WHEN cnt = 8;
    RAISE NOTICE 'Counter: %', cnt;  
    cnt := cnt + 1;  
  END LOOP;  
END $$;

DO $$
DECLARE
cnt integer:=0;
BEGIN
LOOP
exit when cnt>10;
cnt:=cnt+1;

--skipped the curent iteration when cnt is odd
continue when mod(cnt,2)=1;
raise notice'Even %',cnt;
end loop;
end;$$;

--
do $$
BEGIN
<<outer_loop>>
for i in 1..3 LOOP
<<inner_loop>>
for j in 1..3 LOOP
--if j=2 skipped
continue inner_loop when j=2;
raise notice 'i:%,j:%',i,j;
end loop;
end loop;
end;$$;

--adding primary key
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT,
    price INTEGER
);

INSERT INTO
    books (book_id, title, price)
VALUES ('101', 'Jobs', '2000'),
    ('102', 'Geeta', '250'),
    ('103', 'Ramayana', '354'),
    ('104', 'Vedas', '268');

SELECT * FROM books;
--ading primary key to existing table
CREATE TABLE vendors (name VARCHAR(255));

INSERT INTO
    vendors (NAME)
VALUES ('Microsoft'),
    ('IBM'),
    ('Apple'),
    ('Samsung');

SELECT * FROM vendors;
--autoincrementing by serial or bigserial data type
alter table vendors add column vendor_id SERIAL primary key;
--casting
--select cast(vendor_id as integer) from vendors;

select vendor_id, name from vendors;

--foreign key(refential integrity)
--parent table:Course("Primary key")
create table courses (
    course_id SERIAL PRIMARY key,
    course_name VARCHAR(50)
);

insert into courses (course_id) VALUES (33);

--Child table(Student:Foreign key)
create table students (
    student_id SERIAL PRIMARY key,
    student_name VARCHAR(20),
    course_id INT,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses (course_id)
);
--on delete cascade
create table students1 (
    student_id SERIAL PRIMARY key,
    student_name VARCHAR(20),
    course_id INT,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses (course_id) on delete CASCADE
);

delete from courses where course_id = 33;

--on dletete set null
create table students2 (
    student_id SERIAL PRIMARY key,
    student_name VARCHAR(20),
    course_id INT,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses (course_id) on delete set NULL
);

delete from courses where course_id = 33;

select course_id, course_name from courses;

--on update cascase
create table students4 (
    student_id SERIAL PRIMARY key,
    student_name VARCHAR(20),
    course_id INT,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses (course_id) on update CASCADE
);

update courses set course_id = 3 where course_id = 1;

select * from courses;

--creatre
create table departments (
    dept_id SERIAL PRIMARY key,
    dept_name VARCHAR(20)
);

insert into departments (dept_name) VALUES ('IT');

insert into departments (dept_name) VALUES ('Sales');

insert into departments (dept_name) VALUES ('EXTC');

insert into departments (dept_id) VALUES (20);

--child table
create table employee7 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(10),
    dept_id INT,
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
);

SELECT * from departments;

select * from employee7;
--on del cacse
create table employee8 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(10),
    dept_id INT,
    constraint fk_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id) on delete CASCADE
);

delete from departments where dept_id = 20;

select dept_id from departments;

--on delete set null
create table employee9 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(10),
    dept_id INT,
    constraint fk_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id) on delete set null
);

delete from departments where dept_id = 20;

select dept_id from departments;

create table employee9 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(10),
    dept_id INT,
    constraint fk_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id) on update CASCADE
);

update departments set dept_id = 34 where dept_id = 39;

select dept_id from departments;

--check contriants
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    price numeric check (price > 0),
    discount numeric check (discount < price)
);

--add contraints to existing table
alter table products add constraint price check (price >= 100);

insert into
    products
VALUES (
        '1',
        'Zebronicsa jukebox',
        1000,
        30
    );

alter table products add constraint discount check (discount < 60);

select * from products;

create table employee12 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(10),
    dept_id INT,
    salary BIGINT check (salary > 100000)
);

alter table employee12 add constraint salary check (salary > 2000);

alter table employee12 add column age INTEGER;

insert into employee12 (age) values (19);

alter table employee12 add constraint age check (age = 19);

--unique
create table books1 (
    book_name TEXT UNIQUE,
    author_name TEXT not NULL,
    price integer,
    published_date date
);

select book_name from books1;

--not null constriant(null value not allowed)
CREATE TABLE invoice (
    product_id serial PRIMARY KEY,
    qty numeric NOT NULL check (qty > 0),
    discount numeric not NULL check (discount > 0)
);

alter table invoice add constraint discount check (discount >= 0);

alter table invoice add constraint qty check (qty >= 0);

insert into invoice (qty, discount) VALUES (2, 20);
--null values not allowed bcoz we cant voilate not null constraint
insert into
    invoice (product_id, qty, discount)
VALUES (001, NULL, 30);
--violation of null becox pg considered itas unknown,missing state
insert into
    invoice (product_id, qty, discount)
VALUES (002, 30, NULL);
--empty vs null trap:allow 0 and " "(empty string with 0 length) as 0 is valid no while null is unknown no,pk automatically incremented through Serial
insert into invoice (qty, discount) VALUES (" ", 0);
--violation of constriant
insert into invoice (qty, discount) VALUES (0, " ");
--look, 0 considered as a valid value & empty str with "0" length is valid value but we have managed datatype of qty & discount
insert into
    invoice (product_id, qty, discount)
VALUES (004, " ", 0);

select * from invoice;

--ex2
CREATE TABLE invoice3 (
    product_id serial PRIMARY KEY,
    qty numeric NOT NULL check (qty > 0),
    discount numeric not NULL check (discount > 0)
);

insert into invoice3 (qty, discount) VALUES (1, 9);

insert into invoice3 (qty, discount) VALUES (0, " ");

select * from invoice2;

drop table if EXISTS invoice3;

--ex3
CREATE TABLE invoice3 (
    product_id serial PRIMARY KEY,
    qty numeric NOT NULL check (qty >= 0),
    discount numeric
);

insert into invoice3 (qty, discount) VALUES (1, NULL);

insert into invoice3 (qty, discount) VALUES (' ', 0);

CREATE TABLE invoice4 (
    product_id serial PRIMARY KEY,
    qty NUMERIC NOT NULL check (qty >= 0),
    discount numeric
);

insert into invoice4 (qty, discount) VALUES (1, null);
--add  string and 0 as a values
insert into invoice4 (qty, discount) VALUES (0, ' 2 ');

select * from invoice4;

--roles & permissions
select rolname from pg_roles;

--valid until timestamp:2026-07-12
CREATE ROLE contractor LOGIN PASSWORD 'Secure@123' VALID UNTIL '2026-07-12';

select rolname from pg_roles;

--connection limit
create table report_app (
    id SERIAL PRIMARY KEY,
    status BOOLEAN
);

--step1:create role
CREATE ROLE report_role Login PASSWORD 'Secure@33';
--step 2:Alter connection-limit to prevent from hogging db resources by users or appln
ALTER ROLE report_role CONNECTION LIMIT 2;

select rolname from pg_roles;

alter role contractor login password 'Secure@123' valid UNTIL '2026-06-12';

select rolname from pg_roles;

--ex2 weather_app_log
--step1:create role
create role weather_app_log login password 'Secure*123' valid until '2026-07-12';

--step 2:alter connection_limit
alter ROLE weather_app_log connection limit 1;

select rolname from pg_roles;

--alter role
create role immediate_joiner login password 'immediate@77';

alter role immediate_joiner valid until '2026-08-02';

--superuser
alter role immediate_joiner superuser;

--grant permissions & priviledge to create db
alter role immediate_joiner CREATEDB;
--connection limit to limit concurrent transactions and prevent appln/user from hogging db resources
alter role immediate_joiner CONNECTION LIMIT 2;
--nosuperuser(not gets an  absolute access to db)
alter role immediate_joiner nosuperuser;

--nocreatedb:cant create database
alter role immediate_joiner nocreatedb;
--update user's password
alter role immediate_joiner PASSWORD 'secure@99';

--login/nologin:allows users to get login acess to db(login-user,nologib-group)
alter role immediate_joiner login;

alter role immediate_joiner nologin;

--utc timezone:this allows when every time user(immediate_joiner) logins always logins in UTC timezone
alter role immediate_joiner set TIMEZONE_HOUR to 'UTC';

--checked using \du immediate_joiner

SELECT rolname from pg_roles;

--Drop role
create role fired_emp login PASSWORD 'fired@123';

create role new_hired login PASSWORD 'new@123';

alter role fired_emp createdb;

--psql -U fired_emp -W fired_emp; or \du fired_emp

--1)trnasfering asset from fired_emp to new-hired employee
REASSIGN OWNED BY fired_emp to new_hired;
--Step2 revoke their specific permisiions(remove lingering priviledges they were granted by fired_emp on other object toreduce dependacy)
drop owned by fired_emp;

drop ROLE fired_emp;

alter role new_hired createdb;

--ex2 drop
create role old_cust login PASSWORD 'cust@123';

create role new_cust login PASSWORD 'cust1@123';
--grant privileged to create db
alter role old_cust createdb;

--orginal dropping
--step 1)trasferring asset from old cust to new cust
REASSIGN OWNED BY old_cust to new_cust;
--step 2:revoking all privileged given by old_cust to other objects to rmove lingering priviledges & reduced dependacies
DROP OWNED by new_cust;

drop role old_cust;

alter role new_cust createdb;

--ex3
create role old login PASSWORD 'old#123';

drop role if exists old;

create role old_firm login PASSWORD 'firm@123';

create role new_firm login PASSWORD 'firmm@123';

alter role old_firm createdb;

--origignal dropping and trasfering and assigning role
REASSIGN OWNED by old_firm to new_firm;

drop owned by old_firm;

drop role old_firm;

--assign role
alter role new_firm createdb;

--ex3
create role free_plan login PASSWORD 'free@121';

create role premium_plan login password 'premium#123';

alter role free_plan createdb;

--reassinig assset
REASSIGN OWNED by free_plan to premium_plan;

drop OWNED by free_plan;
--drop role
drop role free_plan;

--assign new privileged
alter role premium_plan createdb;

--------------------------------------------------------------Grant priviledge----------------------------------
--create role
create role Elon login PASSWORD 'elon@674';
--create table
CREATE TABLE players (
    player_id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL,
    PRIMARY KEY (player_id)
);

--attempt to select data without any priviledged(dont dare)
select * from players;
--grant select privilege on player table to elon
grant select on players to Elon with grant OPTION;

select * from players;

INSERT INTO
    players (
        first_name,
        last_name,
        email,
        phone
    )
VALUES (
        'raju',
        'kumar',
        'raju.kumar@geeksforgeeks.org',
        '408-111-2222'
    );

grant insert, update, delete on players to Elon with grant OPTION;

--scneario when i want to agrant access to 50 different table
grant select on all tables SCHEMA public to Elon;

alter default PRIVILEGES Elon;

--revoke(undo grant)
revoke insert on players FROM Elon;

----
Part 1:Concept
and Examples (संकल्पना आणि उदाहरणे) In English:In PostgreSQL,
the
GRANT statement is a powerful security tool used to assign privileges to a role (user).By default,
when you create a new table,
only the owner (
    or a superuser
) can view
or modify its data.To allow other users to interact
with
    your database objects (
        like tables,
        views,
        or functions
    ),
    you must explicitly
grant them permission.Syntax:SQL
GRANT privilege_list | ALL ON table_name TO role_name;

privilege_list:Specific actions you are allowing,
such as
SELECT (read), INSERT (
        add
    ),
UPDATE (modify),
or DELETE (remove).ALL:Grants all available privileges on that object at once.Example Workflow:You create a new role:
CREATE ROLE anshul LOGIN PASSWORD 'geeks12345';

If 'anshul' logs in and tries to run SELECT * FROM players;

,
PostgreSQL will block him
and throw an error:ERROR:permission denied for table players.To fix this,
you
grant him read access:SQL
GRANT
SELECT ON players TO anshul;

If he also needs to
add
or change data,
you can
grant multiple privileges at once:SQL
GRANT INSERT,
UPDATE,
DELETE ON players TO anshul;

मराठीत (In Marathi):PostgreSQL मध्ये,
GRANT स्टेटमेंटचा वापर डेटाबेस ऑब्जेक्ट्सवर (जसे की टेबल्स, व्ह्यूज) विशिष्ट अधिकार (privileges) एका विशिष्ट वापरकर्त्याला (role) देण्यासाठी केला जातो.डीफॉल्टनुसार,
नवीन टेबल तयार केल्यावर फक्त टेबलच्या मालकाला तो डेटा पाहण्याचा किंवा बदलण्याचा अधिकार असतो.इतरांना परवानगी देण्यासाठी
GRANT कमांड वापरावी लागते.सिंटॅक्स (Syntax):SQL
GRANT privilege_list | ALL ON table_name TO role_name;


privilege_list: तुम्ही देत असलेले अधिकार, जसे की SELECT (वाचण्यासाठी), INSERT (डेटा टाकण्यासाठी), UPDATE, किंवा DELETE.

ALL: त्या ऑब्जेक्टवरील सर्व उपलब्ध अधिकार एकाच वेळी देण्यासाठी वापरतात.

उदाहरणाचा प्रवाह (Example Workflow):
१. समजा तुम्ही 'anshul' नावाचा एक नवीन रोल तयार केला.
२. जर 'anshul' ने players टेबलमधून डेटा वाचण्याचा प्रयत्न केला, तर त्याला "permission denied" असा एरर येईल.
३. हे सोडवण्यासाठी तुम्ही त्याला डेटा वाचण्याची परवानगी देऊ शकता:

SQL
GRANT SELECT ON players TO anshul;


४. जर त्याला डेटा बदलण्याची किंवा नवीन डेटा टाकण्याची परवानगी द्यायची असेल, तर:

SQL
GRANT INSERT, UPDATE, DELETE ON players TO anshul;


Part 2: Interview Questions & Scenarios (मुलाखतीचे प्रश्न आणि परिस्थितीवर आधारित प्रश्न)
1. The "Passing the Baton" Question
English: If I grant a user access to a table, can they grant that same access to someone else?

Answer: No, not by default. To allow a user to pass their privileges on to others, you must use the WITH GRANT OPTION clause at the end of your command (e.g., GRANT SELECT ON players TO anshul WITH GRANT OPTION;

).

Marathi: जर मी एखाद्या वापरकर्त्याला टेबलचा ऍक्सेस दिला, तर तो स्वतःहून दुसऱ्याला तोच ऍक्सेस देऊ शकतो का?

उत्तर: नाही, डीफॉल्टनुसार नाही. वापरकर्त्याला त्याचे अधिकार इतरांना देण्याची परवानगी देण्यासाठी, तुम्हाला कमांडच्या शेवटी WITH GRANT OPTION वापरावे लागेल (उदा. GRANT SELECT ON players TO anshul WITH GRANT OPTION;

).

2. Scenario: The New Data Analyst
English: A new junior data analyst joins your company. They need to generate daily reports from the sales table, but for security reasons, they must be strictly prevented from adding, modifying, or deleting any records. How do you set up their access?

Answer: You would grant them read-only access by providing only the SELECT privilege.

Query: GRANT SELECT ON sales TO junior_analyst;

Marathi (परिस्थिती:नवीन डेटा ॲनालिस्ट):तुमच्या कंपनीत एक नवीन ज्युनियर डेटा ॲनालिस्ट आला आहे.त्याला sales टेबलमधून दररोज रिपोर्ट बनवायचे आहेत,
परंतु सुरक्षेच्या कारणास्तव तो डेटा बदलू किंवा डिलीट करू शकणार नाही याची काळजी घ्यायची आहे.तुम्ही त्याला कसा ऍक्सेस द्याल ? उत्तर:मी त्यांच्यासाठी फक्त डेटा वाचण्याचा (
    SELECT
) अधिकार देईन.Query:
GRANT
SELECT ON sales TO junior_analyst;

3. Scenario:Schema - Wide Access English:Your database has 50 different tables in the public schema.The marketing team (role:mktg_team) needs
SELECT access to all of them.Writing 50 separate
GRANT statements would be tedious.How can you accomplish this efficiently ? Answer:You can
grant privileges to all tables within a schema at once using the ALL TABLES IN SCHEMA syntax.Query:
GRANT
SELECT ON ALL TABLES IN SCHEMA public TO mktg_team;


Marathi (परिस्थिती: संपूर्ण स्कीमाचा ऍक्सेस): मार्केटिंग टीमला public स्कीमामधील सर्व ५० टेबल्स वाचण्याचा ऍक्सेस हवा आहे. ५० वेगवेगळ्या GRANT कमांड्स लिहिणे वेळखाऊ आहे. तुम्ही हे कसे सोडवाल?

उत्तर: मी संपूर्ण स्कीमासाठी एकाच वेळी ऍक्सेस देणारी कमांड वापरेन.

Query: GRANT SELECT ON ALL TABLES IN SCHEMA public TO mktg_team;

Would you like to explore how to take these permissions away using the
REVOKE statement next ?