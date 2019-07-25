-- Exercise 1, a:   The names of all salespeople that have an order with Samsonic.
SELECT sales.name
FROM salesperson as sales
JOIN (SELECT orders.salesperson_id FROM customer as cust JOIN orders ON cust.id=orders.cust_id WHERE cust.name='Samsonic') AS sam
ON sales.id = sam.salesperson_id;

-- Exercise 1, b. The names of all salespeople that do not have any order with Samsonic.
SELECT sales.name
FROM salesperson as sales
JOIN (SELECT orders.salesperson_id FROM orders JOIN customer as cust ON orders.cust_id=cust.id WHERE cust.name <> 'Samsonic') AS sam
ON sales.id = sam. salesperson_id;

-- Exercise 1, c. The names of salespeople that have 2 or more orders.
SELECT sales.name 
FROM salesperson as sales
JOIN (SELECT orders.salesperson_id FROM orders GROUP BY orders.salesperson_id HAVING COUNT(*) >= 2) AS orderr
ON sales.id = orderr.salesperson_id;

-- Exercise 1, d. Write a SQL statement to insert rows into a table called highAchiever(Name, Age), where a salesperson must have a salary of 100,000 or greater to be included in the table
CREATE TABLE highAchiever AS
SELECT name, age
FROM salesperson WHERE salary >= 100,000;
INSERT highAchiever (name, age)
SELECT name, age FROM salesperson WHERE salary >= 100,000;


-- Exercise 2 a. Write a SQL query that returns the name, phone number and most recent date for any user that has logged in over the last 30 days (you can tell a user has logged in if the action field in UserHistory is set to "logged_on").
SELECT user.name, user.phone_num, max(hist.date) as date
FROM user as user JOIN Userhistory as hist ON user.user_id=hist.userid
WHERE hist.date >= date_sub(curdate(), interval 30 day) AND hist.action="logged_on"
GROUP BY user.user_id;

-- Exercise 2, b. Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory table (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL MINUS statement. Note: the UserHistory table can have multiple entries for each user_id.
--SOLUTION 1: SQL minus
SELECT DISTINCT user.user_id
FROM user
WHERE user.user_id NOT IN(SELECT user_id from userhistory);
-- Solution 2: Clever, remember to use DISTINCT 
SELECT DISTINCT user.user_id
FROM user 
LEFT JOIN userhistory as hist ON user.user_id = hist.user_id
WHERE hist.user_id IS NULL;

--Exercise 3: We want to retrieve the names of all salespeople that have more than 1 order from the tables above. You can assume that each salesperson only has one ID.
SELECT name, sales.id
FROM salesperson as sales
JOIN orders on sales.id=orders.salesperson_id
GROUP BY name, sales.id
HAVING COUNT(orders.salesperson_id) > 1;

--- Exercise 3 b.find the largest order amount for each salesperson and the associated order number, along with the customer to whom that order belongs to.
SELECT orders.salesperson_id, orders.number, MAX(orders.amount)
FROM orders
GROUP BY  orders.salesperson_id
-- Above is Wrong
SELECT orders.salesperson_id, orders.number, orders.amount FROM orders 
JOIN (SELECT orders.salesperson_id, max(amount) as amount_max FROM orders GROUP BY orders.salesperson_id) as topamount
ON orders.amount=topamount.amount_max
USING salesperson_id WHERE orders.amount=topamount.amount_max


-- https://www.w3resource.com/sql-exercises/sql-retrieve-from-table.php

-- SQL Exercise: Retrieve from table
-- Review exercise 18(LIKE '%') , 24(put records at the bottom), 30 (MIN match)
--Exercise 1
SELECT * FROM salesman;
--Exercise 2
SELECT 'This is SQL Exercise, Practice and Solution';
--Exercise 3
SELECT 5, 10, 15;
--Exercise 4
SELECT 10+15;
--Exercise 5
SELECT (10+15)/5
--Exercise 6
SELECT name, commission FROM salesman;
--Exercise 7
SELECT ord_date, salesman_id, ord_no, purch_amt
FROM orders;
--Exercise 8
SELECT DISTINCT salesman_id, ord_no FROM orders;
--Exercise 9
SELECT name, city FROM salesman WHERE city='Paris';
--Exercise 10
SELECT * FROM customer WHERE grade=200;
--Exercise 11
SELECT ord_no, ord_date, purch_amt FROM orders WHERE salesman_id=5001;
--Exercise 12
SELECT * FROM nobel_win WHERE year=1970;
--Exercise 13
SELECT winner FROM nobel_win WHERE category='Literature' AND year=1971;
--Exercise 14;
SELECT year, subject FROM nobel_win WHERE winner='Dennis Gabor';
--Exercise 15
SELECT winner FROM nobel_win WHERE subject='Physics' AND year >= 1950;
--Exercise 16
SELECT year, subject, winner, country FROM nobel_win WHERE subject='Chemistry' AND 1965<= year <= 1975;
-- Exercise 17
SELECT * FROM nobel_win WHERE year > 1972 AND category='Prime Ministerial' AND winner in('Menachem Begin', 'Yitzhak Rabin');
--Exercise 18
SELECT * FROM nobel_win WHERE name LIKE 'Louis%';
--Exercise 19
SELECT winner FROM nobel_win WHERE (year=1970 AND subject='Physics') OR (year=1971 AND subject='Economics');
SELECT winner FROM nobel_win WHERE year=1970 AND subject='Physics' UNION SELECT * FROM nobel_win WHERE year=1971 AND subject='Economics';
--Exercise 20 
SELECT winner FROM nobel_win WHERE year=1970 AND subject NOT IN('Physiology', 'Economics');
--Exercise 21
SELECT winner FROM nobel_win WHERE (year<1971 AND subject='Physiology') OR (year>=1974 AND subject='Peace');
/* Or use UNION for Exercise 21 */
--Exercise 22
SELECT * FROM nobel_win WHERE winner='Johannes Georg Bednorz';
--Exercise 23
SELECT * FROM nobel_win WHERE subject NOT LIKE 'P%' ORDER BY name;
--Exercise 24, put specific rows at the bottom
--the details of 1970 winners by the ordered to subject and winner name; but the list contain the subject Economics and Chemistry at last.
SELECT * FROM nobel_win WHERE year=1970 ORDER BY
CASE WHEN subject in('Economics', 'Chemistry') THEN 1 ELSE 0 END ASC, subject, winner;
--Exercise 25
SELECT pro_name FROM item_mast WHERE 200<= pro_price <= 600;  -- or use BETWEEN AND 
-- Exercise 26
SELECT AVG(pro_price) FROM item_mast WHERE pro_com=16;
--Exercise 27
SELECT pro_name, pro_price FROM item_mast;
--Exercise 28
SELECT pro_name, pro_price FROM  item_mast WHERE pro_price >= 250 ORDER BY pro_price DESC, pro_name ASC;
--Exercise 29
SELECT AVG(pro_price), pro_com FROM item_mast GROUP BY pro_com;
--Exercise 30 --max and min value match
SELECT FIRST(pro_price), pro_name FROM item_mast;
SELECT pro_price, pro_name FROM item_mast JOIN (SELECT MIN(pro_price) as cheapest FROM item_mast) as price_low
 ON item_mast.pro_price=price_low.cheapest;
 SELECT pro_price, pro_item FROM item_mast WHERE pro_price= (SELECT MIN(pro_price) FROM item_mast); -- RIGHT
--Exercise 31
SELECT DISTINCT emp_lname FROM emp_details;
--Exercise 32
SLEECT * FROM emp_details WHERE emp_lname='Snares';
--Exercise 33
SELECT * FROM emp_details WHERE emp_dept=57;


-- SQL Boolean and Relational Operators
-- Review Exercise 9, 10
--Exercise 1
SELECT cust_name FROM customer WHERE grade > 100;
--Exercise 2
SELECT cust_name FROM customer WHERE grade > 100 AND city='New York';
--Exercise 3
SELECT * FROM customer WHERE grade > 100 OR city='New York';
--Exercise 4 
SELECT * FROM customer WHERE city='New York' OR NOT grade > 100;
-- Exercise 5
SELECT * FROM customer WHERE NOT city='New York' OR NOT grade > 100;
SELECT * FROM customer WHERE NOT (city='New York' OR grade > 100);
--Exercise 6
SELECT * FROM orders
WHERE (NOT ord_date='2012-09-10' AND salesman_id <= 505) OR purch_amt <= 1000;
--Exercise 7
SELECT salesman_id, name, city, commission FROM salesman WHERE commission BETWEEN 0.1 AND 0.12;
--Exercise 8
SELECT * FROM orders WHERE purch_amt < 200 OR NOT (ord_date >= '2012-02-10' AND customer_id < 3009);
--Exercise 9
SELECT * FROM orders WHERE ord_date <> '2012-08-17' OR NOT customer_id > 3005 AND NOT purch_amt < 1000;
--Exercise 10
SELECT ord_no, purch_amt, 100*purch_amt/6000 AS Achived_pct, 100(6000-purch_amt)/6000 AS unachieved_pct
FROM orders WHERE (100*purch_amt)/6000 > 50;
--Exercise 11
SELECT * FROM rmp_details WHERE emp_lname IN('Dosni', 'Mardy');
--Exercise 12
SELECT * FROM emp_details WHERE emp_dept in (47, 63);

-- SQL Wildcard and Special Operators
-- Review Exercise 7, 11, 12, 16
--Exercise 1
SELECT * FROM salesman WHERE city IN('Paris', 'Rome');
--Exercise 2
SELECT * FROM salesman WHERE city ='Paris' OR city='Rome';
--Exercise 3
SELECT salesman_id, name, city, commission FROM salesman WHERE NOT city in('Paris', 'Rome');
--Exercise 4
SELECT * FROM customer WHERE customer_id in(3007, 3008, 3009);
--Exercise 5
SELECT * FROM salesman WHERE commission BETWEEN 012 AND 0.14;
--Exercise 6
SELECT * FROM orders WHERE purch_amt BETWEEN 500 AND 4000 AND purch_amt NOT IN(948.5, 1983.43);
--Exercise 7: find those salesmen with all other information and name started with any letter within 'A' and 'K'.
SELECT * FROM salesman WHERE name LIKE IN('%A', '%K');
SELECT * FROM salesman WHERE name BETWEEN 'A' AND 'L'; -- RIGHT
--Exercise 8
SELECT * FROM salesman WHERE NOT name BETWEEN 'A' AND 'L';
SELECT * FROM salesman WHERE name NOT BETWEEN 'A' AND 'L';
--Exercise 9 
SELECT * FROM customer WHERE cust_name LIKE 'B%';
--Exercise 10
SELECT * FROM customer WHERE name LIKE '%n';
--Exercise 11 find those salesmen with all information whose name containing the 1st character is 'N' and the 4th character is 'l' and rests may be any character
SELECT * FROM salesman WHERE name LIKE 'N__l%' 
--Exercise 12 find those rows from the table testtable which contain the escape character underscore ( _ ) in its column 'col1
SELECT * FROM testtable WHERE col1 LIKE '%/_%' ESCAPE '/';
SELECT * FROM testtable WHERE col1 LIKE '%_%';
--Exercise 13
SELECT * FROM testtable WHERE NOT col1 LIKE '%_%';
SELECT * FROM testtable WHERE NOT col1 LIKE '%/_%' escape '/';
--Exercise 14
SELECT * FROM testtable WHERE col1 LIKE '%/%';
SELECT * FROM testtable WHERE col1 LIKE '%//%' ESCAPE '/';
SELECT * FROM testtable WHERE col1 CONTAINS '/';
--Exercise 15
SELECT  * FROM testtable WHERE col1 NOT LIKE '%/%';
SELECT * FROM testtable WHERE col1 NOT CONTAINS '/';
--Exercise 16 those rows from the table testtable which contain the string ( _/ ) in its column 'col1'
SELECT * FROM testtable WHERE col1 LIKE '%_/%';
SELECT * FROM testtable WHERE col1 CONTAINS '_/';
SELECT * FROM testtable WHERE col1 LIKE '%/_//%' ESCAPE '/'; -- RIGHT
--Exercise 17
SELECT * FROM testtable WHERE col1 NOT LIKE '%_/%';
SELECT * FROM testtable WHERE col1 NOT CONTAINS '_/';
SELECT * FROM testtable WHERE col1 NOT LIKE '%/_//%' ESCAPE '/';
--Exercise 18
SELECT * FROM testtable WHERE col1 LIKE '%/%%' ESCAPE '/';
SELECT * FROM testtable WHERE col1 CONTAINS '%';
--Exercise 19
SELECT * FROM testtable WHERE col1 NOT CONTAINS '%';
SELECT * FROM testtable WHERE col1 NOT LIKE '%/%%' ESCAPE '/';
--Exercise 20
SELECT * FROM customer WHERE grade IS NULL;
--Exercise 21 
SELECT * FROM customer WHERE grade IS NOT NULL;
--Exercise 22
SELECT * FROM emp_details WHERE emp_lname LIKE 'D%';


-- SQL Aggregate Functions
-- Review Exercise 5, 8, 10, 11, 16, 19
--Exercise 1
SELECT SUM(purch_amt) FROM orders;
--Exercise 2
SELECT AVG(purch_amt) FROM orders;
--Exercise 3
SELECT COUNT(DISTINCT salesman_id) FROM orders;
--Exercise 4
SELECT COUNT(DISTINCT cust_name) FROM customer WHERE cust_name IS NOT NULL;
SELECT COUNT(*) FROM customer;
--Exercise 5 find the number of customers who gets at least a grade for his/her performance.
SELECT COUNT(DISTINCT customer_id) FROM customer WHERE grade >0;
SELECT COUNT(DISTINCT customer_id) FROM customer WHERE grade IS NOT NULL;
SELECT COUNT(ALL grade) FROM customer; -- right
--Exercise 6
SELECT MAX(purch_amt) FROM orders;
--Exercise 7
SELECT MIN(purch_amt) FROM orders;
--Exercise 8 Important!! GROUP BY must have variable listed in SELECT
--Write a SQL statement which selects the highest grade for each of the cities of the customers.
SELECT city, MAX(grade) FROM customer GROUP BY city;
--Exercise 9
SELECT customer_id, MAX(purch_amt) FROM orders GROUP BY customer_id;
--Exercise 10 highest purchase amount ordered by the each customer on a particular date with their ID, order date and highest purchase amount.
SELECT ord_date, customer_id, MAX(purch_amt) as max_amt FROM orders GROUP BY customer_id, ord_date ; 
--Exercise 11  find the highest purchase amount on a date '2012-08-17' for each salesman with their ID.
SELECT salesman_id, MAX(purch_amt) FROM orders WHERE ord_date='2012-08-17' GROUP BY salesman_id;
--Exercise 12
SELECT customer_id, ord_date, MAX(purch_amt) FROM orders GROUP BY customer_id, ord_date HAVING MAX(purch_amt) > 2000;
--Exercise 13
SELECT customer_id, ord_date, MAX(purch_amt) FROM orders GROUP BY customer_id, ord_date HAVING MAX(purch_amt) BETWEEN 2000 AND 6000;
--Exercise 14
SELECT customer_id, ord_date, MAX(purch_amt) FROM orders GROUP BY customer_id, ord_date HAVING MAX(purch_amt) IN(2000, 3000, 5760, 6000);
--Exercise 15
SELECT customer_id, MAX(purch_amt) FROM orders WHERE customer_id BETWEEN 3002 AND 3007 GROUP BY customer_id;
--Exercise 16 display customer details (ID and purchase amount) whose IDs are within the range 3002 and 3007 and highest purchase amount is more than 1000
SELECT customer_id, purch_amt FROM orders WHERE customer_id BETWEEN 3002 AND 3007 AND MAX(purch_amt) > 1000 GROUP BY customer_id;
SELECT cutsomer_id, MAX(purch_amt) FROM orders WHERE customer_id BETWEEN 3002 AND 3007 GROUP BY customer_id HAVING MAX(purch_amt) > 1000;
--Exercise 17
SELECT salesman_id, MAX(purch_amt) FROM orders GROUP BY salesman_id HAVING salesman_id BETWEEN 5003 AND 5008;
--Exercise 18
SELECT COUNT(*) FROM orders WHERE ord_date='2012-08-17';
--Exercise 19 count the number of salesmen for whom a city is specified. Note that there may be spaces or no spaces in the city column if no city is specified.
SELECT city, COUNT(DISTINCT salesman_id) FROM salesman WHERE city IS NOT NULL OR city <> '' GROUP BY city;
SELECT COUNT(*) FROM salesman WHERE city IS NOT NULL;
--Exercise 20
SELECT ord_date, salesman_id, COUNT(*) FROM orders GROUP BY ord_date, salesman_id;
--Exercise 21
SELECT AVG(pro_price) FROM item_mast;
--Exercise 22;
SELECT COUNT(*) FROM item_mast WHERE pro_price >= 350;
--Exercise 23
SELECT pro_com, pro_id, AVG(pro_price) FROM item_mast GROUP BY pro_com, pro_id;
--Exercise 24
SELECT SUM(dpt_allotment) FROM emp_department;
--Exercise 25
SELECT emp_dept, COUNT(emp_idno) FROM emp_details GROUP BY emp_dept;


-- SQL Formatting Query Output
-- Review Exercise, 1, 9, 10
--Exercise 1 display the commission with the percent sign ( % ) with salesman ID, name and city columns for all the salesmen. 
SELECT salesman_id, name, city, CONCAT(commission*100, '%') FROM salesman;
SELECT salesman_id, name, city, '%', commission*100 FROM salesman;
--Exercise 2
SELECT 'For', ord_date, 'there are', COUNT(DISTINCT ord_no), 'orders' FROM orders GROUP BY ord_date;
SELECT CONCAT('For', ord_date, 'there are', COUNT(*), 'orders') AS sentence FROM orders GROUP BY ord_date;
--Exercise 3
SELECT * FROM orders ORDER BY ord_no ASC;
--Exercise 4
SELECT * FROM orders ORDER BY ord_date DESC;
--Exercise 5
SELECT * FROM orders ORDER BY ord_date ASC, purch_amt DESC;
--Exercise 6
SELECT cust_name, city, grade FROM customer ORDER BY customer_id;
--Exercise 7
SELECT salesman_id, ord_date, MAX(purch_amt) FROM orders GROUP BY salesman_id, ord_date ORDER BY salesman_id, ord_date;
--Exercise 8
SELECT cust_name, city, grade FROM customer ORDER BY grade DESC;
--Exercise 9, make a report with customer ID in such a manner that, the largest number of orders booked by the customer will come first along with their highest purchase amount.
SELECT customer_id, COUNT(*), MAX(purch_amt) FROM orders GROUP BY customer_id ORDER BY 2 DESC;
--Exercise 10 a report with order date in such a manner that, the latest order date will come last along with the total purchase amount and total commission (15% for all salesmen) for that date
SELECT ord_date, SUM(purch_amt), 0.15*SUM(purch_amt) FROM orders GROUP BY ord_date ORDER BY ord_date;


--SQL Query on Multiple Tables
-- Review Exercise 3, 5, 7
--Exercise 1
SELECT cust.customer_id, sales.salesman_id, cust.city FROM customer cust, salesman sales WHERE cust.city=sales.city;
SELECT cust.cust_name, sales.name, sales.city FROM customer cust, salesman sales WHERE cust.city=sales.city;
--Exercise 2
SELECT cust.cust_name, cust.salesman_id, sales.name FROM customer cust, salesman sales WHERE cust.salesman_id=sales.salesman_id;
SELECT cust.cust_name, cust.salesman_id, sales.name FROM customer AS cust LEFT JOIN salesman AS sales ON cust.salesman_id=sales.salesman_id;
--Exercise 3 display all those orders by the customers not located in the same cities where their salesmen live
SELECT * FROM orders WHERE customer_id NOT IN 
(SELECT customer_id FROM customer cust, salesman sales WHERE cust.city=sales.city);
--Exercise 3 Another Method
SELECT orders.ord_no, orders.customer_id, orders.salesman_id, cust.cust_name FROM orders, customers cust, salesman sales
WHERE cust.city <> sales.city AND orders.customer_id=cust.customer_id AND orders.salesman_id=sales.salesman_id;
--Exercise 4
SELECT orders.ord_no, cust.cust_name FROM orders, customer cust WHERE order.customer_id=cust.customer_id;
--Exercise 5 shorts out the customer and their grade who made an order. Each of the customers must have a grade and served by at least a salesman, who belongs to a city
SELECT cust.customer_id, cust.cust_name, cust.grade FROM customer cust, orders WHERE cust.customer_id=orders.customer_id 
AND cust.customer_id IN(
SELECT cust.customer_id FROM customer cust, salesman sales WHERE cust.salesman_id = sales.salesman_id AND sales.city IS NOT NULL)
AND cust.grade IS NOT NULL;
--Another way
SELECT  cust.customer_id, cust.grade FROM customer cust, orders, salesman sales
WHERE cust.grade IS NOT NULL AND sales.city IS NOT NULL
AND orders.salesman_id = sales.salesman_id AND cust.customer_id=orders.customer_id;
--Exercise 6
SELECT cust.cust_name, cust.city, sales.name, sales.commission FROM customer cust, salesman sales
WHERE cust.salesman_id=sales.salesman_id AND sales.commission BETWEEN 0.12 AND 0.14;
--Exercise 7
SELECT orders.ord_no, custsale.cust_name, custsale.commission, custsale.commission*orders.purch_amt FROM orders, 
(SELECT cust.cust_name, cust.customer_id, sales.commission FROM customer cust, salesman sales WHERE cust.salesman_id=sales.salesman_id AND cust.grade >= 200) AS custsale
WHERE orders.customer_id = custsale.customer_id;
-- Another Way
SELECT orders.ord_no, cust.cust_name, sales.commission, sales.commission*orders.purch_amt FROM orders, customer cust, salesman sales
WHERE orders.salesman_id = sales.salesman_id AND orders.customer_id=cust.customer_id AND cust.grade >= 200;


--SQL SORTING and FILTERING on HR Database
--Review Exercise 9, 17, 22, 30, 32
--Exercise 1
SELECT first_name, last_name, salary FROM employees WHERE salary < 6000;
--Exercise 2
SELECT first_name, last_name, department_id, salary FROM employees WHERE salary > 8000;
--Exercise 3
SELECT first_name, last_name, department_id FROM employees WHERE last_name='McEwen';
--Exercise 4
SELECT * FROM employees WHERE department_id IS NULL;
--Exercise 5
SELECT * FROM departments WHERE department_name='Marketing';
--Exercise 6
SELECT first_name, last_name, hire_date, salary, department_id FROM employees WHERE first_name NOT LIKE '%M%' ORDER BY department_id;
--Exercise 7
SELECT * FROM employees WHERE salary BETWEEN 8000 AND 12000 AND commission_pct IS NOT NULL OR department_id NOT IN(40, 120, 70) AND hire_date<'1987-06-05';
--Exercise 8
SELECT first_name, last_name, salary FROM employees WHERE commission_pct IS NULL;
--Exercise 9 display the full name (first and last), the phone number and email separated by hyphen, and salary, for those employees whose salary is within the range of 9000 and 17000. The column headings assign with Full_Name, Contact_Details and Remuneration respectively.
SELECT first_name || ' ' || last_name AS full_name, phone_number ||'-'||email AS contact_details, salary AS renumeration FROM employees WHERE salary BETWEEN 9000 AND 17000;
--Exercise 10
SELECT frist_name, last_name, salary FROM employees WHERE first_name LIKE '%m';
--Exercise 11
SELECT first_name ||' '|| last_name AS full_name, salary FROM employees WHERE salary NOT BETWEEN 7000 AND 15000 ORDER BY first_name ||' '|| last_name ASC;
--Exercise 12
SELECT first_name||' '||last_name as full_name, job_id, hire_date FROM employees WHERE hire_date BETWEEN '2007-11-05' AND '2007-07-05';
--Exercise 13
SELECT first_name||' '||last_name AS full_name, department_id FROM employees WHERE department_id in(70, 90);
--Exercise 14
SELECT first_name||' '||last_name AS full_name, salary, manager_id FROM employees WHERE manager_id IS NOT NULL;
--Exercise 15
SELECT * FROM employees WHERE hire_date < '2002-06-21';
--Exercise 16
SELECT first_name, last_name, email, salary, manager_id FROM employees WHERE manager_id IN(120, 103, 145);
--Exercise 17: display all the information for all employees who have the letters D, S, or N in their first name and also arrange the result in descending order by salary
SELECT * FROM employees WHERE first_name LIKE '%[DSN]%' ORDER BY salary DESC;
--Solution
SELECT * FROM employees WHERE first_name LIKE '%D%' OR first_name LIKE '%S%' OR first_name LIKE '%N%' ORDER BY salary DESC;
--Exercise 18
SELECT first_name||' '||last_name AS full_name, hire_date, commission_pct, email||'-'||phone_number AS contact_details, salary FROM employees WHERE salary >11000 OR phone_number LIKE '______3%' ORDER BY first_name DESC;
--Exercise 19
SELECT first_name, last_name, department_id FROM employees WHERE first_name '__s%';
--Exercise 20
SELECT employee_id, first_name, job_id, department_id FROM employees WHERE department_id NOT IN(50, 30, 80);
--Exercise 21
SELECT employee_id, first_name, job_id, department_id FROM employees WHERE department_id IN(30, 40, 90);
--Exercise 22 display the ID for those employees who did two or more jobs in the past: GROUP BY is infront of HAVING
SELECT employee_id, COUNT(DISTINCT job_id) FROM job_history GROUP BY employee_id HAVING COUNT(DISTINCT job_id) >= 2;
--Exercise 23
SELECT job_id, COUNT(employee_id), SUM(salary), MAX(salary)-MIN(salary) AS salary_difference FROM employees GROUP BY job_id;
--Exercise 24
SELECT job_id, COUNT(DISTINCT employee_id) FROM job_history WHERE end_date-start_date > 300 GROUP BY job_id HAVING COUNT(DISTINCT employee_id) >= 2 ;
--Exercise 25
SELECT country_id, COUNT(DISTINCT city) FROM locations GROUP BY country_id;
--Exercise 26
SELECT manager_id, COUNT(DISTINCT employee_id) FROM employees GROUP BY manager_id;
--Exercise 27
SELECT job_title FROM jobs ORDER BY job_title DESC;
--Exercise 28
SELECT first_name, last_name, hire_date FROM employees WHERE job_id IN('SA_MAN', 'SA_REP');
--Exercise 29
SELECT deparment_id, AVG(salary) FROM employees WHERE commission_pct IS NOT NULL GROUP BY department_id;
--Exercise 30 display those departments where any manager is managing 4 or more employees
SELECT manager_id, department_id, COUNT(DISTINCT employee_id) FROM employees GROUP BY manager_id HAVING COUNT(DISTINCT employee_id) >= 4;
SELECT DISTINCT department_id FROM employees GROUP BY department_id, manager_id HAVING COUNT(employee_id) >= 4; --RIGHT
--Exercise 31
SELECT department_id, COUNT(DISTINCT employee_id) FROM employees WHERE commission_pct IS NOT NULL GROUP BY department_id HAVING COUNT(DISTINCT employee_id) >10;
--Exercise 32 display the employee ID and the date on which he ended his previous job
SELECT employee_id, MAX(end_date) FROM job_history GROUP BY employee_id;
--Exercise 33
SELECT * FROM employees WHERE commission_pct IS NULL AND salary BETWEEN 7000 AND 12000 AND department_id=50;
--Exercise 34
SELECT job_id, AVG(salary) FROM employees GROUP BY job_id HAVING AVG(salary)>8000;
--Exercise 35
SELECT job_title, max_salary-min_salary AS salary_diff FROM jobs WHERE max_salary BETWEEN 12000 AND 18000;
--Exercise 36 
SELECT * FROM employees WHERE first_name LIKE 'D%' OR last_name LIKE '%D';
--Exercise 37
SELECT * FROM jobs WHERE min_salary>9000;
--Exercise 38
SELECT * FROM employees WHERE hire_date > '1987-09-07';


--SQL JOINS
--Review Exercise 1, 7, 13, 25
--Exercise 1 prepare a list with salesman name, customer name and their cities for the salesmen and customer who belongs to the same city
SELECT sales.name, cust.cust_name, sales.city FROM salesman sales, customer cust WHERE sales.salesman_id=cust.salesman_id AND sales.city=cust.city;
-- No need for salesman and customer match
SELECT sales.name, cust.cust_name, sales.city FROM salesman sales, customer cust WHERE sales.city=cust.city;
--Exercise 2
SELECT orders.ord_no, orders.purch_amt, cust.cust_name, cust.city FROM orders, customer cust WHERE orders.customer_id=cust.customer_id AND orders.purch_amt BETWEEN 500 AND 2000;
--Exercise 3
SELECT cust.cust_name, sales.name FROM customer cust, salesman sales WHERE cust.salesman_id=sales.salesman_id;
--Exercise 4
SELECT cust.cust_name FROM customer cust, salesman sales WHERE cust.salesman_id=sales.salesman_id AND sales.commission > 0.12;
--Exercise 5
SELECT cust.cust_name FROM customer cust, salesman sales WHERE cust.salesman_id=sales.salesman_id AND cust.city <> sales.city AND sales.commission > 0.12;
--Exercise 6
SELECT orders.ord_no, orders.ord_date. orders.purch_amt,cust.cust_name, sales.name, sales.commission FROM orders, customer cust, salesman sales
WHERE orders.customer_id=cust.customer_id AND orders.salesman_id=sales.salesman_id;
--Exercise 7  make a join on the tables salesman, customer and orders in such a form that the same column of each table will appear once and only the relational rows will come.
SELECT * FROM orders NATURAL JOIN customer NATURAL JOIN salesman;
--Exercise 8
SELECT cust.cust_name, sales.name FROM customer AS cust LEFT JOIN salesman AS sales ON cust.salesman_id=sales.salesman_id ORDER BY cust.cust_name;
--Exercise 9  LEFT OUTER JOIN is the same as LEFT JOIN 
SELECT cust.cust_name FROM customer AS cust LEFT JOIN salesman AS sales ON cust.salesman_id=sales.salesman_id WHERE cust.grade<300 ORDER BY cust.cust_name;
--Exercise 10
SELECT cust.cust_name, cust.cty, orders.ord_no, orders.purch_amt, orders.ord_date FROM customer AS cust LEFT JOIN orders ON cust.customer_id=orders.customer_id ORDER BY orders.ord_date, orders.purch_amt;
--Exercise 11
SELECT a.cust_name, a.city. b.ord_no, b.purch_amt, b.ord_date, c.name, c.commission FROM customer AS a LEFT JOIN orders AS b ON a.customer_id=b.customer_id LEFT JOIN salesman AS c ON a.salesman_id=c.salesman_id;
--Exercise 12
SELECT a.name, b.cust_name FROM salesman AS a LEFT JOIN customer AS b ON a.salesman_id=b.salesman_id ORDER BY a.salesman_id;
--Exercise 13 make a list for the salesmen who works either for one or more customer or not yet join under any of the customers who placed either one or more orders or no order to their supplier
SELECT a.name, b.cust_name, c.ord_no FROM salesman AS a LEFT JOIN customer AS b ON a.salesman_id=b.salesman_id LEFT JOIN orders AS c ON b.customer_id=c.customer_id;
SELECT a.name, b.cust_name, c.ord_no FROM customer AS b RIGHT JOIN salesman AS a ON a.salesman_id=b.salesman_id RIGHT JOIN orders AS c ON b.customer_id=c.customer_id;
--Exercise 14
SELECT a.name, b.cust_name, c.ord_no FROM customer AS b RIGHT JOIN salesman AS a ON a.salesman_id=b.salesman_id 
LEFT JOIN orders AS c ON b.customer_id=c.customer_id AND c.purch_amt >= 2000 WHERE b.grade IS NOT NULL;
--Exercise 15
SELECT a.cust_name, a,city, b.ord_no, b.ord_date, b.purch_amt FROM orders AS b LEFT JOIN customer AS a ON a.customer_id=b.customer_id;
--Exercise 16
SELECT a.cust_name, a,city, b.ord_no, b.ord_date, b.purch_amt FROM orders AS b LEFT JOIN customer AS a ON a.customer_id=b.customer_id AND a.grade IS NOT NULL;
--Exercise 17
SELECT * FROM salesman CROSS JOIN customer;
--Exercise 18
SELECT * FROM customer a CROSS JOIN salesmane WHERE a.city IS NOT NULL;
--Exercise 19
SELECT * FROM customer a CROSS JOIN salesman AS b WHERE a.grade IS NOT NULL AND b.city IS NOT NULL;
--Exercise 20
SELECT * FROM customer a CROSS JOIN salesman AS b WHERE a.grade IS NOT NULL AND b.city IS NOT NULL AND b.city <> a.city;
--Exercise 21
SELECT a.*, b.com_name FROM item_mast AS a LEFT JOIN company_mast AS b ON a.pro_com=b.com_id;
--Exercise 22
SELECT a.pro_name, a.pro_price, b.com_name FROM item_mast AS a JOIN company_mast AS b ON a.pro_com=b.com_id;
--Exercise 23
SELECT a.com_name, AVG(b.pro_price) FROM company_mast AS a JOIN item_mast AS b ON a.com_id=b.pro_com GROUP BY a.com_name;
--Exercise 24
SELECT a.com_name, AVG(b.pro_price) FROM company_mast AS a JOIN item_mast AS b ON a.com_id=b.pro_com GROUP BY a.com_name HAVING AVG(b.pro_price) >= 350;
--Exercise 25 display the name of each company along with the ID and price for their most expensive product.
SELECT a.*, MAX(b.pro_price) FROM company_mast AS a JOIN item_mast AS b on a.com_id=b.pro_com GROUP BY a.com_id; -- Wrong
SELECT a.com_name, a.com_id, b.high_price FROM company_mast a JOIN 
(SELECT pro_com, MAX(pro_price) AS high_price FROM item_mast GROUP BY pro_com) AS b ON a.com_id=b.pro_com;  -- Right
SELECT a.pro_name, a.pro_price, b.com_name FROM item_mast AS a JOIN company_mast AS b ON a.pro_com=b.com_id AND a.pro_price = (SELECT MAX(a.pro_price) FROM item_mast a WHERE a.pro_com=b.com_id);
-- Another Thoughts
SELECT  pro_com, pro_name, pro_price FROM item_mast JOIN
(SELECT pro_com, MAX(pro_price) AS high_price FROM item_mast GROUP BY pro_com) AS b ON item_mast.pro_price=b.high_price AND item_mast.pro_com=b.pro_com;
--Exercise 26
SELECT a.*, b.dpt_name, b.dpt_allotment FROM emp_details a, emp_department b WHERE a.emp_dept=b.dpt_code;
--Exercise 27
SELECT a.emp_fname, a.emp_lname, b.dpt_name, b.dpt_allotment FROM emp_details a, emp_department b WHERE a.emp_dept=b.dpt_code;
--Exercise 28
SELECT a.emp_fname, a.emp_lname, b.dpt_name, b.dpt_allotment FROM emp_details a JOIN emp_department b ON a.emp_dept=b.dpt_code WHERE b.dpt_allotment > 50000;
--Exercise 29
SELECT dpt_name, COUNT(emp_idno) FROM emp_department INNER JOIN emp_details ON emp_department.dpt_code=emp_details.emp_dept GROUP BY emp_department.dpt_name HAVING COUNT(emp_details.emp_idno)>2;



--SQL JOINS on HR Database
--Review Exercise 3, 7, 15, 21, 25
--Exercise 1 
SELECT a.first_name, a.last_name, a.department_id, b.department_name FROM employees a JOIN departments b ON a.department_id=b.department_id;
--Exercise 2
SELECT a.first_name, a.last_name, b.department_name, c.city, c.state_province FROM employees AS a JOIN departments AS b ON a.department_id=b.department_id JOIN locations AS c ON b.location_id=c.location_id;
--Exercise 3 display the first name, last name, salary, and job grade for all employees
SELECT a.first_name, a.last_name, a.salary, b.grade_level FROM employees AS a JOIN job_grades AS b ON a.salary BETWEEN b.lowest_sal AND b.highest_sal;
--Exercise 4
SELECT a.first_name, a.last_name, a.department_id, b.department_name FROM employees a JOIN departments b ON a.department_id=b.department_id WHERE a.department_id IN(80, 40);
--Exercise 5
SELECT a.first_name, a.last_name, b.department_name, c.city, c.state_province FROM departments AS b JOIN employees AS a ON a.deparment_id=b.deparment_id JOIN locations AS c ON b.location_id=c.location_id WHERE a.first_name LIKE '%Z%';
--Exercise 6
SELECT  a.department_id, a.department_name FROM departments AS a LEFT JOIN employees AS b ON a.department_id=b.department_id;
--Exercise 7 display the first and last name and salary for those employees who earn less than the employee earn whose number is 182
SELECT first_name, last_name, salary FROM employees WHERE salary < (SELECT salary FROM employees WHERE employee_id=182);
SELECT a.first_name, a.last_name, a.salary FROM employees a JOIN employees b ON a.salary < b.salary AND b.employee_id=182; --Solution
--Exercise 8
SELECT a.first_name AS employee_name, b.first_name AS manager_name FROM employees AS a LEFT JOIN employees AS b ON a.manager_id=b.employee_id;
--Exercise 9
SELECT a.department_name,  b.city, b.state_province FROM departments AS a JOIN locations AS b ON a.location_id=b.location_id;
--Exercise 10
SELECT a.first_name, a.last_name, b.department_id, b.department_name FROM employees AS a LEFT JOIN departments AS b ON a.department_id=b.department_id;
--Exercise 11
SELECT a.first_name AS employee_name, b.first_name AS manager_name FROM emplyees a LEFT JOIN employees b ON a.manager_id=b.employee_id;
--Exercise 12
SELECT a.first_name, a.last_name, a.department_id FROM employees a JOIN employees b ON a.department_id=b.department_id AND b.last_name='Taylor';
--Exercise 13
SELECT a.first_name, a.last_name, b.start_date, b.end_date, c.job_title, d.department_name  FROM employees a JOIN job_history b ON a.employee_id=b.employee_id JOIN jobs c ON a.job_id=c.job_id JOIN departments d ON a.department_id=d.department_id
WHERE b.start_date >='1993-01-01' AND b.end_date<='1997-08-31';
--Exercise 14
SELECT a.first_name, a.last_name, b.job_title, b.max_salary-a.salary AS diff FROM employees a JOIN jobs b ON a.job_id=b.job_id;
--Exercise 15  COUNT() will count the Non NULL value only, display the name of the department, average salary and number of employees working in that department who got commission
SELECT a.department_name, AVG(b.salary), COUNT(b.commission_pct) FROM departments a JOIN employees b ON a.department_id=b.department_id GROUP BY a.department_name;
--Exercise 16
SELECT a.first_name||' '||a.last_name AS full_name, b.job_title, b.max_salary-a.salary FROM employees a JOIN jobs b ON a.job_id=b.job_id WHERE a.department_id=80;
--Exercise 17
SELECT a.city, b.country_name, c,department_name FROM locations a JOIN countries b ON a.country_id=b.country_id JOIN departments c ON a.location_id=c.location_id;
--Exercise 18
SELECT a.department_name, b.last_name, a.first_name FROM departments a JOIN employees b ON a.manager_id=b.manager_id;
--Exercise 19
SELECT a.job_title, AVG(b.salary) FROM jobs a JOIN employees b ON a.job_id=b.job_id GROUP BY a.job_title;
--Exercise 20
SELECT a.employee_id, a.job_id, b.start_date, b.end_date FROM employees a JOIN job_history b ON a.employee_id=b.employee_id WHERE a.salary>12000;
--Exercise 21 isplay the country name, city, and number of those departments where at leaste 2 employees are working
SELECT a.country_name, b.city, COUNT(c.department_id) FROM countries a JOIN locations b ON a.country_id=b.country_id JOIN departments c ON b.location_id=c.location_id 
WHERE c.department_id IN(SELECT department_id FROM employees GROUP BY department_id HAVING COUNT(employee_id) >= 2) GROUP BY a.country_name, b.city;
--Exercise 22
SELECT a.department_name, b.first_name, b.last_name, c.city FROM departments a JOIN employees b ON a.manager_id=b.employee_id JOIN locations USING (location_id);
--Exercise 23
SELECT a.employee_id, a.end_date-a.start_date, b.job_title FROM job_history a JOIN jobs b ON a.job_id=b.job_id WHERE a.department_id=80;
--Exercise 24
SELECT a.first_name, a.last_name, a.salary FROM employees a JOIN departments b ON a.department_id=b.department_id JOIN locations c ON b.location_id=c.location_id;
--Exercise 25  display full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage
SELECT a.first_name, a.last_name, b.job_title, c.start_date, c.end_date FROM employees a JOIN jobs b ON a.job_id=b.job_id 
JOIN (SELECT employee_id, MAX(start_date) AS start_date, MAX(end_date) as end_date FROM job_history GROUP BY employee_id) AS c ON a.employee_id=c.employee_id WHERE a.commission_pct IS NULL;
--Exercise 26
SELECT a.department_name, a.department_id, COUNT(b.employee_id) FROM departments a JOIN employees b ON a.department_id=b.department_id GROUP BY a.department_name;
SELECT a.department_name, b.* FROM departments a JOIN (SELECT department_id, COUNT(employee_id) FROM employees GROUP BY department_id) AS b ON a.department_id=b.department_id; -- Solution
--Exercise 27
SELECT a.first_name, a.last_name, a.employee_id, b.country_name FROM employees a JOIN departments c ON a.department_id=c.department_id JOIN locations d ON c.location_id=d.location_id JOIN countries b ON d.country_id=b.country_id;


--SQL Subqueries
--Review Exercise 3, 12, 14, 15, 16
--Exercise 1 
SELECT * FROM orders WHERE salesman_id IN(SELECT salesman_id FROM salesman WHERE name='Paul Adam');
--Exercise 2
SELECT * FROM orders WHERE salesman_id IN(SELECT salesman_id FROM salesman WHERE city='London');
--Exercise 3-- Question here a query to find all the orders issued against the salesman who may works for customer whose id is 3007.
SELECT * FROM orders WHERE customer_id=3007;
SELECT * FROM orders WHERE salesman_id IN(SELECT DISTINCT salesman_id FROM orders WHERE customer_id=3007);  --Solution
--Exercise 4
SELECT * FROM orders WHERE purch_amt >(SELECT AVG(purch_amt) FROM orders WHERE ord_date='2012-10-10') AND ord_date='2012-10-10';
--Exercise 5
SELECT * FROM orders WHERE salesman_id IN(SELECT salesman_id FROM salesman WHERE city='New York');
--Exercise 6
SELECT commission FROM salesman WHERE salesman_id IN(SELECT salesman_id FROM customer WHERE city='Paris');
--Exercise 7
SELECT * FROM customer WHERE customer_id=(SELECT salesman_id-2001 FROM salesman WHERE name='Mc Lyon');
--Exercise 8
SELECT COUNT(customer_id) FROM customer WHERE grade> (SELECT AVG(grade) FROM customer WHERE city='New York');
--Solution
SELECT grade, COUNT(customer_id) FROM customer GROUP BY grade HAVING grade > (SELECT AVG(grade) FROM customer WHERE city='New York');
--Exercise 9
SELECT * FROM customers WHERE customer_id IN(SELECT customer_id FROM orders WHERE ord_date='2012-10-05');
--Exercise 10
SELECT a.* FROM customer a JOIN orders b WHERE a.customer_id=b.customer_id AND b.ord_date='2012-08-17';
SELECT * FROM customer WHERE customer_id IN(SELECT customer_id FROM orders WHERE ord_date='2012-08-17');
--Exercise 11
SELECT  a.salesman_id, name FROM salesman a JOIN customer b ON a.salesman_id=b.salesman_id GROUP BY a.salesman_id HAVING COUNT(customer_id) >1;
SELECT salesman_id, name FROM salesman WHERE salesman_id IN(SELECT salesman_id FROM customer GROUP BY salesman_id HAVING COUNT(*) >1);
--Exercise 12 query to find all orders with order amounts which are above-average amounts for their customers. 
SELECT ord_no, purch_amt FROM orders WHERE ord_no IN(SELECT DISTINCT ord_no FROM orders GROUP BY ord_no HAVING purch_amt>AVG(purch_amt)); -- Wrong
--SOLUTION
SELECT * FROM orders a WHERE purch_amt>(SELECT AVG(purch_amt) FROM orders b WHERE a.customer_id=b.customer_id);
--Exercise 13
SELECT * FROM orders a WHERE purch_amt >=(SELECT AVG(purch_amt) FROM orders b WHERE a.customer_id=b.customer_id);
--Exercise 14  find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 1000.00 above the maximum order amount for that date. 
SELECT ord_date, SUM(purch_amt) FROM orders WHERE ord_date IN(SELECT ord_date FROM orders GROUP BY ord_date HAVING SUM(purch_amt)>(1000+MAX(purch_amt))) GROUP BY ord_date;
--Solution  
SELECT ord_date, SUM(purch_amt) FROM orders a GROUP BY ord_date HAVING SUM(purch_amt)>(SELECT 1000+MAX(purch_amt) FROM orders b WHERE a.ord_date=b.ord_date);
--Exercise 15  extract the data from the customer table if and only if one or more of the customers in the customer table are located in London
SELECT * FROM customer  WHERE (SELECT COUNT(DISTINCT customer_id) FROM customers WHERE city='London')>=1
SELECT * FROM customer WHERE EXISTS (SELECT * FROM customer WHERE city='London');  -- WHERE EXISTS evaluate TRUE/FALSE values
--Exercise 16 a query to find the salesmen who have multiple customers. 
SELECT * FROM salesman WHERE salesman_id IN(SELECT salesman_id FROM customers GROUP BY salesman_id HAVING COUNT(*)>1);
SELECT * FROM salesman a WHERE (SELECT COUNT(*) FROM customer b WHERE a.salesman_id=b.salesman_id)>1;
--Solution  
SELECT * FROM salesman WHERE salesman_id IN(SELECT DISTINCT salesman_if FROM customer a WHERE EXISTS(SELECT * FROM customer b WHERE a.salesman_id=b.salesman_id AND a.cust_name <> b.cust_name));
--Exercise 17
SELECT * FROM salesman WHERE salesman_id IN(SELECT salesman_id FROM customer GROUP BY salesman_id HAVING COUNT(*)=1);
--Solution  
SELECT * FROM salesman WHERE salesman_id IN(SELECT DISTINCT salesman_if FROM customer a WHERE NOT EXISTS(SELECT * FROM customer b WHERE a.salesman_id=b.salesman_id AND a.cust_name <> b.cust_name));
--Exercise 18
SELECT a.* FROM salesman a JOIN orders b ON a.salesman_id=b.salesman_id WHERE b.customer_id IN SELECT(DISTINCT customer_id FROM orders a WHERE (SELECT COUNT(ord_no) FROM orders b WHERE a.customer_id=b.customer_id)> 1;
--Exercise 19
SELECT a.* FROM salesman a JOIN customer b WHERE a.city=b.city;
SELECT * FROM salesman WHERE city IN(SELECT city FROM customer);
--Exercise 20
SELECT * FROM salesman WHERE salesman_id IN(SELECT salesman_id FROM customer WHERE customer_id IS NOT NULL);
--Exercise 21
SELECT a.* FROM salesman a JOIN customer b ON a.salesman_id=b.salesman_id WHERE a.name<b.cust_name;
SELECT * FROM salesman a WHERE EXISTS(SELECT * FROM customer WHERE a.name < b.cust_name);  -- Solution
--Exercise 22
SELECT * FROM customer WHERE grade >(SELECT MAX(grade) FROM customer WHERE city < 'New York');
SELECT * FROM customer WHERE grade > ANY (SELECT grade FROM cutsomer WHERE city<'New York');
--Exercise 23
SELECT * FROM orders WHERE puch_amt > (SELECT MIN(purch_amt) FROM customer WHERE ord_date='2012-09-10');
--Exercise 24
SELECT * FROM orders WHERE purch_amt < ANY (SELECT purch_amt FROM orders WHERE customer_id IN(SELECT customer_id FROM customer WHERE city='London');
--Exercise 25
--The same as Exercise 24
SELECT * FROM orders WHERE purch_amt < (SELECT MAX(purch_amt) FROM orders a, cutsomer b WHERE a.customer_id=b.customer_id AND b.city='London');
--Exercise 26
SELECT * FROM customer WHERE grade > (SELECT MAX(grade) FROM customer WHERE city='New York');
SELECT * FROM customer WHERE grade > ALL (SELECT grade FROM customer WHERE city='New York');
--Exercise 27
--The same as Exercise 26
--Exercise 28, ANY and ALL difference
SELECT * FROM customer WHERE garde <> ALL (SELECT grade FROM customer WHERE city='London');
SELECT * FROM customer WHERE grade <> ANY (SELECT grade FROM cutsomer WHERE city='London');
SELECT * FROM customer WHERE grade NOT IN(SELECT grade FROM customer WHERE city='London');
--Exercise 29
SELECT * FROM customer WHERE grade NOT IN(SELECT grade FROM customer WHERE city='Paris');
--Exercise 30
SELECT * FROM customer WHERE grade NOT IN(SELECT grade FROM customer WHERE city='Dallas');
--Exercise 31
SELECT a.com_name, AVG(b.pro_price) FROM company_mast a JOIN item_mast b ON a.com_id=b.pro_com GROUP BY a.com_name;

SELECT a.com_name, b.price FROM company_mast a JOIN (SELECT pro_com, AVG(pro_price) AS price FROM item_mast GROUP BY pro_com) b ON a.com_id=b.pro_com;
SELECT a.com_name, AVG(b.pro_price) FROM company_mast a, item_mast b ON a.com_id=b.pro_com GROUP BY b.pro_com, a.com_name;
--Exercise 32
SELECT a.com_name, AVG(b.pro_price) FROM company_mast a, item_mast b ON a.com_id=b.pro_com GROUP BY a.com_name HAVING AVG(b.pro_price) >= 350;
--Exercise 33
SELECT a.com_name, b.pro_price, b.pro_com FROM company_mast a JOIN (SELECT pro_com, MAX(pro_price) as pro_price FROM item_mast GROUP BY pro_com) b ON a.com_id=b.pro_com;
SELECT a.com_name, b.pro_price, b.pro_name FROM company_mast a, item_mast b ON b.pro_com=a.com_id WHERE b.pro_price IN(SELECT MAX(pro_price) FROM item_mast c ON c.pro_com=a.com_id);
--Exercise 34
SELECT * FROM emp_details WHERE emp_lname IN('Gabriel', 'Dosio');
--Exercise 35
SELECT a.*, b.* FROM emp_details a, emp_department b WHERE b.dep_code=a.emp_dept AND b.dpt_code IN(89, 63);
--Exercise 36
SELECT emp_fname, emp_lname FROM emp_details WHERE emp_dept IN(SELECT dpt_code FROM emp_department WHERE dpt_allotment>50000);
--Exercise 37
SELECT * FROM emp_department WHERE dpt_allotment > (SELECT AVG(dpt_allotment) FROM emp_department);
--Exercise 38
SELECT dpt_name FROM emp_department a WHERE dpt_code IN(SELECT emp_dept FROM emp_details GROUP BY emp_dept HAVING COUNT(*)>2);
--Exercise 39
SELECT emp_lname, emp_fname FROM emp_details WHERE emp_dept IN(SELECT dpt_code FROM emp_department WHERE dpt_alloment=(SELECT MIN(dpt_alloment) FROM emp_department WHERE dpt_alloment > (SELECT MIN(dpt_alloment) FROM emp_department)));



SELECT ROW_NUMBER() OVER 




CREATE TABLE weather2 AS SELECT id+1 as id, recorddate, temperature as prev_temperature FROM weather;
CREATE TABLE weather3 AS SELECT a.id, a.recorddate, a.temperature, b.prev_temperature FROM weather AS a JOIN weather2 AS b on a.id=b.id;
SELECT id FROM weather WHERE id IN(SELECT ID FROM weather3 WHERE temperature>prev_temperature);



SELECT final.id from ((SELECT a.id, a.recorddate, a.temperature, b.prev_temperature FROM weather AS a JOIN (SELECT id+1 as id, recorddate, temperature as prev_temperature FROM weather)
                AS b on a.id=b.id and a.temperature>b.prev_temperature) as final) ;
























