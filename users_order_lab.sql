-- 1. Create a new database named user_orders_lab
CREATE DATABASE user_orders_lab;

-- 2. Create users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Create orders table with a foreign key linking to users
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);
--2. Insert Initial Data
Now, we will populate the tables. We are inserting 4 users and 6 orders. Notice that Alice (user_id 1) and Charlie (user_id 3) both have multiple orders to satisfy your requirement.

-- Insert 4 users
INSERT INTO
    users (user_name, email)
VALUES (
        'Elon Musk',
        'elon@example.com'
    ),
    ('Tim Cook', 'tim@example.com'),
    (
        'Charlie Brown',
        'charlie@example.com'
    ),
    (
        'Diana Prince',
        'diana@example.com'
    );

-- Insert 6 orders
INSERT INTO
    orders (user_id, product_name, amount)
VALUES (1, 'Laptop', 1200.50), -- elon's order
    (1, 'Wireless Mouse', 25.00), -- elon's order
    (
        2,
        'Mechanical Keyboard',
        75.99
    ), -- Tim's order
    (3, '4K Monitor', 300.00), -- Charlie's order
    (3, 'HDMI Cable', 15.00), -- Charlie's order
    (
        1,
        'Noise-Cancelling Headphones',
        150.00
    );
-- elon's order

--3. Display and Inspect the Data
-- Verify users data
SELECT * FROM users;

-- Verify orders data
SELECT * FROM orders;

--4. Join Data Across Tables
-- Display each order along with the corresponding user_name
SELECT o.order_id, o.product_name, o.amount, u.user_name
FROM orders o
    JOIN users u ON o.user_id = u.user_id;

--5. Aggregation Analysis
-- Calculate total spending per user and order descending
SELECT u.user_name, SUM(o.amount) AS total_amount
FROM users u
    JOIN orders o ON u.user_id = o.user_id
GROUP BY
    u.user_name
ORDER BY total_amount DESC;

--6. Advanced Querying
-- 1. Find users with more than one order
SELECT u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
    JOIN orders o ON u.user_id = o.user_id
GROUP BY
    u.user_name
HAVING
    COUNT(o.order_id) > 1;

-- 2. Identify the most expensive order in PostgreSQL
SELECT order_id, product_name, amount
FROM orders
ORDER BY amount DESC
LIMIT 1;