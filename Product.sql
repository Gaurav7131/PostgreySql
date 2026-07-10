CREATE TABLE items (
    ID serial PRIMARY KEY,
    product VARCHAR(100) NOT NULL,
    price NUMERIC NOT NULL,
    discount NUMERIC
);

INSERT INTO
    items (product, price, discount)
VALUES ('A', 1000, 10),
    ('B', 1500, 20),
    ('C', 800, 5),
    ('D', 500, NULL);

--edit column_name price<>net_price
select product, (price) AS net_price from items;
--coalese(first non-null value)
select COALESCE(1, 2);

select COALESCE(NULL, 2, 1);
--fallback(default 0 if having null)
select product, (price - COALESCE(discount, 0)) as net_price
from items;
--1:0/p:499
select product, (price - COALESCE(discount, 1)) as net_price
from items;

--nullif(compare 2 values return null is true else 1st arg)
CREATE TABLE post (
    id serial primary key,
    title VARCHAR(255) NOT NULL,
    excerpt VARCHAR(150),
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO
    post (title, excerpt, body)
VALUES (
        'test post 1',
        'test post excerpt 1',
        'test post body 1'
    ),
    (
        'test post 2',
        '',
        'test post body 2'
    ),
    (
        'test post 3',
        null,
        'test post body 3'
    );

select title, excerpt, body from post;

--using coalese
SELECT id, title, COALESCE(excerpt, LEFT(body, 40)) FROM posts;

--using nullif
select id, title, COALESCE(
        NULLIF(excerpt, ''), left(body, 40)
    )
from post;

create table employee3 (
    name VARCHAR(10),
    sirname VARCHAR(10),
    emp_id serial,
    experience date,
    salary money,
    email TEXT
);

INSERT INTO
    employee3 (
        name,
        sirname,
        emp_id,
        experience,
        salary,
        email
    )
VALUES (
        'Alex',
        'Johnson',
        001,
        '2026-07-01',
        75000.00,
        'alex@gmail.com'
    ),
    (
        'Sarah',
        'Smith',
        002,
        '2021-07-02',
        68000.00,
        'Sarah@gmail.com'
    );

select CAST(002 as INTEGER);

select cast(002 as SMALLINT);

SELECT cast('2021-07-02' as TIMESTAMP);

alter table employee3 add COLUMN age INTEGER;

insert into employee3 (age) VALUES (39);

select age from employee3;

select cast(39 as smallint);

select cast('Sarah@gmail.com' as text);

--string to date
select cast('2021-07-02' as date), cast('2026-07-01' as date);

select cast('2021-07-01' as TIMESTAMP), cast('2026-07-01' as TIMESTAMP);

--Cast(::) operator
SELECT 39::INTEGER;

select * from employee3;

CREATE or REPLACE FUNCTION 
BEGIN
IF num>0 THEN
RESULT:='True';
ELSEIF num<0 THEN
RESULT:='False';
ELSE
RESULT:='Zero';
END IF;
return RESULT;
END;