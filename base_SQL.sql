/* Learning Objectives: 1.Define and describe both relational and transactional database models
2. Define entities, attributes, and relationships 
3. Describe and explain the differences between a one-one, one-many, and many-many relationships 
4. Describe primary keys in a database5. Explain how ER diagrams are used to document and illustrate relationships*/

/* ER Diagram */
/* ER Diagram Notation: Chen Notation, Crow's Foot Notation, UML Class Diagram Notation */


/* Retrieving Data with a SELECT Statement  */
/* Write a basic SELECT statement.
Tell a database which table your data will come FROM.
SELECT either all or particular columns from a table in a query.
Limit the amount of data which is returned  in a query
*/

SELECT variables
FROM datasets;
/* Retrieving multiple columns 
Add multiple column names, be sure to use a comma */
SELECT var1, var2, var3
FROM dataset;
/* Request all columns by using the asterisk (*) wildcard character instead of column names */
SELECT *
FROM dataset;

/* If databse is large, you might only want to see a sample of the data */
SELECT columns, you, wish, see
FROM specifictable
LIMIT obs_num

/* Limiting Results Using Different Sybtaxed */
/* SQLite */
SELECT prod_name FROM products LIMIT 5;
/* Oracle */
SELECT prod_name FROM products WHERE ROWNUM <= 5;
/* DB2 */
SELECT prod_name FROM products FETCH FIRST 5 ROWS ONLY;

/* Creating Tables */
/* Objectives:
1. Discuss situations where it's beneficial to create new tables.
2. Create new tables within an existing database.
3. Write data to a new table.
4. Defining whether columns can accept NULL values or not */

CREATE TABLE shoes
  (
  id     char(10)    PRIMARY KEY,
  brand  char(10)    NOT NULL,
  type   char(250)   NOT NULL,
  Color  char(250)   NOT NULL,
  Price  decimal(8, 2)  NOT NULL,
  Desc  Varchar(750) NULL
  );
/* Nulls and Primary Keys
1, Eevry column is either NULL(allow null values) or NOT NULL.
2, Am error will be returned if one tries to submit a column with no values
3, Do not confise null values with empty strings, empty string can have something there, spaces, etc. Null value is missing everything.
4, Primary keys can not be null
*/

/* Adding Data to the table  */
/* Way 1: Not recommend */
INSERT INTO Shoes
VALUES ('14535974'
        ,'Gucci'
		,'Slippers'
		,'Pink'
		,'695.00'
		,NULL
		        );

/*  Way 2: Recommend: Variable Name and Values should match  */
/* You do not need to insert all values in all variables */
INSERT INTO Shoes
  ( id,
    Brand,
	Type, 
	Color,
	Price,
	Desc
  )
 VALUES ('14535974'
        ,'Gucci'
		,'Slippers'
		,'Pink'
		,'695.00'
		,NULL
		        );

/* Creating Temporary Tables */
/* Objectives: 1.Creating temporary tables
2. Describe limitations of temporary tables.
3. Discuss strategies for researching syntax for particular database management systems. */
/* Temporary tables will be deleted when current session is terminated.
Faster than creating a real table.
Useful for complex queries using subsets and joins */
CREATE TEMPORARY TABLE Sandals AS
(SELECT *
FROM shoes
WHERE type = 'sandals'
)

/* Add Comments */
/* Single Line  for Comment */
SELECT shoe_id,
-- brand,     /* This whole line is removed as comment */
shoe_name
from shoes
/* Section of the code as comment */
SELECT shoe_id
/* ,brand_id
,shoe_name  */  /* Do not run any code between those two slashes */
from shoes



-- Week 2
-- Filtering, Sorting and Calculating Data with SQL
-- New Clauses and Operators in SQL: WHERE BETWEEN IN OR NOT LIKE (ORDER BY) (GROUP BY)
-- Wildcards: allow more precise search capabilities. Discuss adv and disadv of wildcards, practices with wildcards
-- Math Operators: Using computational math operators, using aggregate math functions: AVERAGE COUNT MAX MIN

/* Basics of Filtering with SQL */
/* Objectives: 1. Descrive the basics of filtering your data 2. Use the WHERE clause with common operators
3. Use the BETWEEN clause 4. Explain the concept of a NULL value  */

SELECT column_name1, column_name2
FROM table_name
WHERE columnname1 operator value;
/* Operator: = equal; <> Not equal(or !=); > greater than; < less than; >= greater than or equal;
<= less than or equal; BETWEEN between an inclusive range; IS NULL is a null value */

-- example: Filtering on a Single Condition 
SELECT Productname, unitprice, supplierid
FROM products
WHERE productname = 'Tofu';  /* single quote */

-- example: Filtering on a Single Value
SELECT productname, unitprice, supplierid
FROM  products
WHERE unitprice >= 75;

-- exmaple: Checking for Non-Matches
SELECT productname, unitprice, supplierid
FROM products
WHERE productname <> 'Alice Mutton';

-- exmaple: Filtering with a Range of Values
SELECT productname, unitprice, supplierid, unitsinstock
FROM products
WHERE unitsinstock BETWEEN 15 AND 80;
>=
-- example: Filtering Null Value
-- No value returned because there are no null values in the product name in this exmaple, no output
SELECT productname, unitprice, supplierid, unitsinstock
FROM products
WHERE productname IS NULL;

-- Advanced Filtering: IN, OR, and NOT
/* Learning Objectives: 1. Use the IN and OR operators to filter your data and get results you want
2. Differentiate between use of the IN and BETWEEN operators
3. Discuss importance of order of operators
4. Explain how and when to use the NOT operator  */

-- IN Operator: Specifies a range of conditions, Comma delimited list of values, Enclosed in ()
-- example
SELECT productid, unitprice, supplierid
FROM products
WHERE supplierid IN (9, 10, 11);

/* OR Operator:
DMBS will not evaluate the second coditions (OR) in a WHERE clause if the first condition is met
Use for any rows matching the specific conditions */
SELECT productname, productid, unitprice, supplierid
FROM products
WHERE productname = 'Tofu' or 'Konbu';
-- In this example, we only has the 'Tofu' obs, because DBMS will not evaluate the second condtion in where

/* IN vs. OR:
IN works the same as OR
Benifits of IN: Long list of options; IN executes faster than OR;
Don't have to think about the order with IN; Can contain another SELECT */

-- OR with AND
-- example
SELECT productid, unitprice, supplierid
FROM products
WHERE supplierid = 9 OR supplierid = 11
AND unitprice > 15;  -- Return is 4 obs, including supplierID=9 and unitprice=9
-- Comparison
SELECT productid, unitprice, supplierid
FROM products
WHERE (supplierid = 9 OR supplierid = 11)
AND unitprice > 15;  -- Return is 3 obs, exclude supplierID=9 and unitprice=9 because both conditions in parenthesis are evaluated with the last condtion

/* Order of Operations
Can contain AND and OR operators
SQL processes AND before OR, so always remember to use (),
Don't reply on the default order of operations. You are better being specific and getting in the habit of using the () */

-- NOT operator
-- example: employees in London and Seattle
SELECT *
FROM employees
WHERE NOT city='London' AND NOT City='Seattle';

/* Using Wildcards in SQL 
Learning Objectives: 1. Explain the concept of wildcards, adv and disadv, Usfulness
2. Describe how to use the LIKE operator with wildcards
3. Write appropriate syntax when using wildcards  */

/* special character/strings used to match parts of a value
Search pattern made from literal text, wildcard character, or a combination
Uses LIKE as an operator (though technically a predicate)
Wildcards can only be used with strings and cannot be used for non-test datatypes.
Only helpful for DS as they explore string variables */

/* Using % Wildcards, % means grab this location words and case sensitive
'%Pizza': Grabs anything ending with word pizza
'Pizza%': Grabs anything after the word pizza
'%pizza%': Grabs anything before and after the word pizza  */

Wildcards:
'S%E' Action: Grabs anything that starts with 'S' and ends with 'E', eg: Sadie
't%@gmail.com' Action: Grabs gmail addresses that start with 't' (hoping to find Tom@gmail.com)

/* % wildcard will not match NULLs
NULL represents no value in a column */

/* Underscore(_) Wildcard
Matches a single character, which is not supported by DB2 */
WHERE Var LIKE '_pizza'
OUTPUT: spizza, mpizza
/* Supported by DB2 */
WHERE var LIKE '%pizza'
Output: spizza, mpizza

-- Bracket [] Wildcard
-- Used to specify a set of characters in a specific loaction, does not work with all DBMS, does not work with SQLite
/* Downside of Wildcards */
/* 1. Takes longer to run. 2. Better to use another operator (if possible): =, <, =>, and etc.
3. Statements with wildcards will take longer to run if used at the end of search patterns
4. Placement of wildcards is important     */

/* Sorting with ORDER BY */
/* ORDER BY Objectives: 1. Discuss the importantce of sorting data for analysis purposes
2. Explain some of the rules related to using the ORDER BY clause
3. Use the ORDER BY clause to sort data either in ascending or descending order   */
-- ORDER BY clause allows user to sort data by particular columns
SELECT something
FROM database
ORDER BY characteristic

/* Rules for ORDER BY:
1. Takes the name of one or more columns
2. Add a comma after each additional column name
3. Can sort by a column not retrieved
4. Must always be the last clause in a select statement  */
-- Example, Sorting by Column Position
ORDER BY 2, 3   /* 2 means 2nd column */
-- Sorting Direction
-- DESC: descending order
-- ASC: ascending order
-- Only applies to the column names it directly precedes
 ORDER BY DESC var1, var2  /* DESC only works on var1 instead of var2 */
 
/* Math Operations */
/* Objectives:  1. Perform basic math calculations using your data.
2. Discuss the order of operations
3. Describe analysis possibilities of using math operators and SQL together */

/* Math Operators: Addition: +;  Subtraction: -; Multiplication: *; Division: /. */
/* Multiplication Example: Total units on order multiplied by the unit price to calculate the total order cost */
SELECT productid, unitsonorder, unitprice, unitsonorder * unitprice AS total_order_cost
FROM products

-- Order of Operations: Parenthesis -- Exponents -- (Multiplication, Division) -- (Addition, Subtraction)
SELECT productid, quantity, unitprice, discount, (unitprice  - discount)/quantity AS total_cost
FROM orderdetails;

/* Aggregate Function */
/* Aggregate Functions Learning Objectives:
1. Describe various aggregate functions.
2. Explain how each of the aggregate functions can help you to analyze data.
3. Use various aggregate functions: AVERAGE (AVG()), COUNT, MAX, MIN and SUM to summarize and analyze data 
4. Describe the Distinct function */
/* Aggregate Functions usages: 1. Used to summarize data,
2. Finding the highest and lowest values
3. Finding the total number of rows
4. Finding the average value  */

/* Average Function Example: Rows containing NULL values are ignored by the AVERAGE function. */
SELECT AVG(unitprice) AS avg_price
FROM products
/* COUNT Function example
COUNT(*) - Counts all the rows in a table containing values or NULL values.
COUNT(column) -  Counts all the rows in a specific column ignoring NULL values  */

SELECT COUNT(*) AS total_customers
FROM Customers;
SELECT COUNT(customerid) AS total_customers
FROM Customers;
SELECT *, COUNT() FROM 

/* MAX and MIN Functions: NULL values are ignored by the MIN and MAX functions */
SELECT MAX(unitprice) AS max_prod_price
FROM products;
SELECT MAX(unitprice) AS max_prod_price, MIN(unitprice) AS min_prod_price
FROM products;

/* SUM Aggregate Function */
SELECT SUM(unitprice) AS total_prod_price
FROM products;

SELECT SUM(unitprice * unitsinstock) AS total_price
FROM products
WHERE supplierid = 23;
/* Using DISTINCT on Aggregate Functions */
/* If DISTINCT is not specified, ALL is assumed(ALL is default)
Cannot use DISTINCT on COUNT(*)
No value to use with MIN and MAX functions */
SELECT COUNT(DISTINCT customerid) 
FROM Customers;

/* Grouping Data with SQL */
/* Learning Objectives: 1. Perform some additional aggregations using the GROUP BY and HAVING clauses.
2. Discuss how NULLs are or aren't affected by the GROUP BY and HAVING clauses
3. Use the GROUP BY and ORDER BY clauses together to better sort your data */

/* Grouping Example: Counts customers after group on region rather than counting the whole table */
SELECT region, COUNT(customerid) AS total_customers
FROM customers
GROUP BY region;
/* GROUP BY rules:
1: GROUP BY clauses can contain multiple columns, use a comma to separate
2. Every column in your SELECT statement must be present in a GROUP BY clause, except for aggregated calculations
3. NULLs will be grouped together if your GROUP BY column contains NULLs */

-- HAVING Clause - Filtering for Groups
/* WHERE does not work for groups because it filters on rows
so we use HAVING clause to filter for groups */

/* Grouping Example, select customers who have orders greater than or equal to 2 */
SELECT customerid, COUNT(*) AS orders
FROM orders
GROUP BY customerid
HAVING COUNT(*) >= 2;

-- WHERE vs HAVING
-- WHERE filters before data is grouped
-- HAVING filters after data is grouped
-- Rows eliminated by the WHERE clause will not be included in the group

-- ORDER BY with GROUP BY
-- ORDER BY sorts data
-- GROUP BY does not sort data
SELECT supplierID, COUNT(*) AS num_prod
FROM products
WHERE unitprice >= 4
GROUP BY supplierID
HAVING COUNT(*) >= 2;

/* Putting It All Together */

/* Week 3 */
-- Subqueries and Joins in SQL

/* Subqueries */
-- How they work, adv and disadv, best practices for using subqueries
/* Joins */
-- Revisit key fields
-- Linking data together with joins-- Characteristics of different types of joins

/* Making Code Cleaner and Efficient: Using alias and pre-qualifiers */


/* Using Subqueries */
-- Learning Objectives
/* 1.Define Subqueries
2. Discuss advantages and disadvantages of using subqueries
3. Explain how subqueries help us merge data from two or more tables
4. Write more efficient subqueries  */

/* Subqueries:
1. Queries embedded into other queries
2. Relational databases store data in multiple tables
3. Subqueries merge data from multiple sources together
4. Helps with adding other filtering criteria that is not in your current table but from another table   */

/* Example: wants to know the region of customers whose freight is >100 */
/* Stupid way: */
-- Step 1
SELECT DISTINCT CustomerID
FROM orders
WHERE freight>100
-- Step 2
SELECT CustomerID, companyname, region
FROM customers
WHERE customerid in ('RICSU', 'ERNSH', 'FRANK', 'WARTH', 'MORGK', 'QUICK', 'RATTC', 'HUNGO', 'GODOS')
-- The list output in step 1

/* Combined for a Subquery */
SELECT CustomerID, Companyname, region
FROM Customers
WHERE customerID in(SELECT Customerid FROM orders WHERE freight>100);

/* Working with Subquery Statements */
-- Always perform the innermost SELECT portion first
/* DBMS is performing two operations
1. Getting the order numbers for the product selected
2. Adding that to the WHERE clause and processing the overall SELECT statement */

/* Subqueriey Best Practices and Considerations */
/* Learning Objectives:
1. Discuss how to write subqueries within subqueries
2. Discuss performance limitations with overuse of subqueries
3. Explain how to use subqueries as calculations
4. Describe best practices using subqueries    */

-- There is no limit to the number of subqueries you can have
-- Performance slows when you nest too deeply
-- Subquery selects can only retrieve a single column

/* Example, Subquery in Subquery, always look at the deepest subquery first
1. Order numbers for toothbrushes
2. Customer ID's for those orders
3. Customer information for those orders  */
SELECT Customer_name, Customer_contact
FROM Customers
WHERE cust_id IN
  SELECT customer_id
  FROM orders
  WHERE order_number IN(SELECT order_number  
                        FROM orderItems
						WHERE prod_name = 'Toothbrush');
/* Indenting use PoorSQL Website */

/* Subqueries for Calculations */
SELECT customer_name, customer_state, 
       (SELECT COUNT(*) AS orders 
        FROM orders
        WHERE orders.customer_id = customer.customer_id
		/* Need Group by Statement? */) AS orders
FROM customer
ORDER BY customer_name

/* Joining Table */
/* Learning Objectives:
1. Discuss the benefits of a relational database systems
2. Describe what a JOIN is and how to use the JOIN function to combine information from multiple tables
3. Describe how a key field is used to link data together   */
/* Benefits of Breaking Data into Tables: Efficient storage, Easier manipulation, Greater scalability, 
   Logically models a process, Tables are related through common values (keys)   */
 
/* Joins */
/* 1. Associate correct records from each table on the fly
2. Allows data retrieval from multiple tables in one query
3. Joins are not physical - they persist for the duration of the query execution  */

/* Catesian (Cross) Joins */
/* Learning Objectives:
1. Define Cartesian (or Cross) joins
2. Describe some specific cases where Cartesian joins are useful
3. Write the appropriate SQL syntax to establish a Cartesian join   */
-- CROSS JOINs: Many to Many joins, each row from the first table joins with all the rows of another table 
-- We will get x*y results from Cartesian join (the num of joins in the 1st table multiplied by the number of rows in the 2nd table
-- Example
SELECT product_name, unit_price, company_name
FROM suppliers CROSS JOIN products;
-- Notes: CROSS JOIN not freuently used, computationally taxing and will return results with the incorrect information

/* Inner Joins */
/* Learning Objectives: 
1. Define and describe an inner join
2. Explain when and how to use an inner join
3. Pre-qualify column names to make your SQL code that much clearner and efficient  */
/* Keys are important for INNER JOIN:
INNER JOIN keyword selects records that habe matching values in both tables
Example :  */
SELECT suppliers.Companyname, productname, unitprice
FROM suppliers 
INNER JOIN products ON suppliers.supplierid = products.supplierid
/* Inner Join Syntax
1. Join type is specified (INNER JOIN)
2. Join condition is in the FROM clause and uses the ON clause
3. Joining more tables together affects overall database performances
4. You can join multiple tables, no limit
5. List all tables and then define conditions   */
-- Inner Join with multiple Tables
SELECT o.orderid, c.companyname, e.lastname
FROM ((orders o INNER JOIN customers c ON o.custimerid = c.customerid)
INNER JOIN employees e ON o.employeeid = e.employeeid);
/* Notes of Best Practices with Joins 
1. Make sure you are pre-qualifying names
2. Do not make unnecessary joins
3. Think about the type of join you are making
4. How are you connecting records? */

/* Aliases and Self Joins  */
/* Learning Objectives:
1. Create aliases for use in our queries
2. Discuss common nameing conventions when using aliases
3. Discuss and establish self-joins within a SQL databse  */
/* Alias definition
1. SQL aliases give a table or a column a temporary name
2. Make column names more readable
3. An alias only exists for the duration of the query  */
SELECT column_name 
FROM table_name AS alias_name
/* Query Example Using Alias, comparing if there is difference with the INNER JOIN */
SELECT vendor_name, product_name, product_price
FROM vendors, products
WHERE vendors.vendor_id  = products.vendor_id;
-- Using Alias
SELECT vendor_name, product_name, product_price
FROM vendors AS v, products AS p
WHERE v.vendor_id  = p.vendor_id

/* Self Joins
Match customers from the same city, take the table and treat it like two separate tables, join the original table to itself  */
SELECT column_name(s)
FROM table1 T1, table2 T2
WHERE condition;
-- Example, problem in this example
SELECT A.customername AS customername1, B.customername AS customername2, A.city
FROM customer A, customer B
WHERE /* A.customerid=B.customerid */
AND A.city = B.City
ORDER BY A.city;

/* Advanced Joins: Left, Right, and Full Outer Joins */
-- SQL Lite v.s. Other SQL DBMS--SQL Lite only does left joins
-- Other database management systems use all joins
/* Learning Objectives
1. Explain how left, right and full outer joins works
2. Identify situations to use each type of join
3. Use each type of join to combine data from multiple tables   */

-- Left Join
-- Returns all records from the left table(main table), and the matched records from the right table(second table)
-- The result is NULL from the right side if there is no match
/* Example of Left Join: Select all customers, and any orders they might have:  */
SELECT c.customername, o.orderid
FROM customer c
LEFT JOIN orders o ON c.customerid=o.customerid
ORDER BY c.customername;

-- Right Join
-- Returns all records from the right table(main table), and the matched records from the left table(second table)
-- The result is NULL from the left side where there is no match.
-- The table you list first in the statement is acted upon by the type of join you use
/* Example of Right Join: Return all employees(employee main table), and any orders they might have placed  */
SELECT orders.orderid, employees.lastname, employees.firstname
FROM orders
RIGHT JOIN employees ON orders.employeeid = employees.employeeid
ORDER BY orders.orderid;

/* Comparing difference of LEFT JOIN and RIGHT JOIN */
/* 1. Difference between right and left is the order the tables are relating.
2. Left joins can be turned into right joins by reversing the order of the table  */

-- Full Outer Join
-- Return all records when there is a match in either left or right table records (Give me everything)
/* Full Outer Join Example: FULL JOIN / Selects all customers and all orders: */
SELECT customers.customername, orders.orderid
FROM customers
FULL OUTER JOIN orders on customers.customerid = orders.customerid
ORDER BY customers.customername;

/* Unions  */
/* Learning Objectives:
1. Describe what a UNION is and how it works.
2. Discuss the rules for using UNIONs
3. Write correct syntax for a UNION statement
4. Describe common situations in which UNIONs are useful  */
-- What is a UNION
-- The UNION operator is used to combine the result-set of two or more SELECT statements
-- Each SELECT statement within UNION must have the same number of columns. UNION is like stack datasets, JOIN is like merge
-- Columns must have similar data types
-- The columns in each SELECT statement must be in the same order.
/* Union Example */
-- Query 1: Basic Union Setup 
SELECT column_name(s) 
FROM table1
UNION 
SELECT column_name(s) FROM table2;

-- Query 2: Which German cities have suppliers
SELECT city, country FROM customers
/* WHERE country='Germany'  */
UNION
SELECT city, country FROM suppliers
/* WHERE country='Germany'  */
ORDER BY city;

-- Best practices Using JOINs/* It is easy to get results -- You must make sure they are the right results.
-- 1. Check the number of records
-- 2. Does it seem logical given the kind of join you are performing?
-- 3. Check for duplicates
-- 4. Check the number of records each time you make a new join
-- 5. Are you getting the results you expected?
-- 6. Start small: one table at a time.

/* Other useful syntax */
SELECT columns
FROM table1 A
LEFT JOIN table2 B
ON a.key=b.key
WHERE b.key IS NULL     /* Remove the overlap part in table 1 and table 2 and keep table 1 */

SELECT columns
FROM table1 A
FULL OUTER JOIN table2 B
ON a.key=b.key
WHERE a.key IS NULL OR b.key IS NULL     /* Remove the overlap of table 1 and table 2. */

SELECT columns
FROM table1 A
RIGHT JOIN table2 B
ON a.key=b.key
WHERE a.key IS NULL    /* Remove the overlap part in table1 and table2 and keep table 2  */


-- Week 4: Modifying and Analyzing Data with SQL
/* Module Introduction  */
-- Methods for Modifying Data  
-- Concatenating
-- Trimming
-- Changing case
-- Substring functions
-- Date and time strings
-- Case Statements (SQL's version of IF, THEN, ELSE statements)
-- Data Governance and Profiling (Tips and tricks for using SQL for data science), Putting it all together

/* Working with Text Strings (Blend data together)  */
/* Learning Objectives */
-- Concatenate, or combine text strings
-- Trim text strings
-- Use the substring function and 
-- Change the case of your string
/* Working with String Variables */
/* Retrieve the data in the format you need: Client vs server formatting
Support Joins 
String Functions: Concatenate, Substring, Trim, Upper, Lower   */

/* Concatenations  */
-- Note: SQL server supports '+' instead of ||
SELECT companyname, contactname, companyname||'('||contactname||')'
FROM customers

/* Trimming Strings */
-- Trims the leading or trailing space from a string
-- TRIM 
-- RTRIM  
-- LTRIM
SELECT TRIM("    You the best.      ") AS trimmedString;     /* Output: "You the best."  */

/* Substring */
-- Returns the specific number of characters from a particular position of a given string
SUBSTR(string_name, string_position, number of characters to be returned);

SELECT first_name, SUBSTR(first_name, 2, 3)
FROM employees
WHERE department_id = 60;

/* Upper and Lower --  Standardize your data */
SELECT UPPER(column_name) FROM table_name;
SELECT UCASE(column_name) FROM table_name;  -- It also turn to upper case
SELECT LOWER(column_name) FROM table_name;

/* Working with Date and Time Strings  */
/* Learning Objectives:
1. Describe the complexities of adjusting date and time strings.
2. Discuss the different formats in which dates and times are presented.
3. List and describe the 5 different functions in SQL that can be used to manipulate date and time strings */

/* Working with Date Varibales */
/* 1. As long as your data contains only the date portion, your queries will work as expected. However, if a time portion is involved, it gets more complicates.
2. The most difficult part when working with dates is to be sure that the format of the date you are trying to insert, matches the format of the date column in the database.
3. Dates are stored as datetypes
4. Each DBMS uses it's own variety of datatypes. */
Wednesday, September 17th, 2008
9/17/2008 5:14:56 P.M. EST
26122008 (Julian format)

-- Date Formats
DATE: Format YYYY-MM-DD
DATETIME: Format YYYY-MM-DD HH:MI:SS
TIMESTAMP: Format YYYY-MM-DD HH-MI-SS
-- If you query a DATETIME with:
WHERE purchasedate='2016-12-12'
-- you will get no results because it is a DATETIME with hours and minutes and seconds

/* SQLite Date Time Functions: SQLite supports 5 date and time functions:    */
DATE(timestring, modifier, modifier, ...)
TIME(timestring, modifier, modifier, ...)
DATETIME(timestring, modifier, modifier, ...)
JULIANDAY(timestring, modifier, modifier, ...)
STRFTIME(format, timestring, modifier, modifier, ...)
/* Timestrings can be in following format */
YYYY-MM-DD
YYYY-MM-DD HH:MM
YYYY-MM-DD HH:MM:SS
YYYY-MM-DD HH:MM:SS.SSS
YYYY-MM-DDTHH:MM
YYYY-MM-DDTHH:MM:SS
YYYY-MM-DDTHH:MM:SS.SSS
HH:MM
HH:MM:SS
HH:MM:SS.SSS
/* Modifiers can be in following format  */
NNN days
NNN hours
NNN minutes
NNN.NNNN seconds
NNN months
NNN years
start of month
start of year
start of day
weekday N 
unixepoch
localtime
utc

/* Date and Time String Examples */
/* Learning Objectives:
1. Use the STRFTIME function: stringformattime function
2. Compute current date and use it to compare to a recorded date in your data
3. Use the NOW function
4. Combine several date and time functions together to manipulate data    */
/* Example of STRFTIME function: */
birthdate: 1962-02-18 00:00:00
SELECT birthdate,
STRFTIME('%Y', birthdate) AS year,
STRFTIME('%m', birthdate) AS month,
STRFTIME('%d', birthdate) AS day
FROM employees;

/* Compute Current Date  */
SELECT DATE('now')
/* Compute Year, Month and Day for the Current Date  */
SELECT STRFTIME('%Y %m %d', 'now');
/* Compute the Hour, Minute and Second and Milliseconds from Current DATETIME */
SELECT STRFTIME('%H %M %S %s', 'now');
/* Compute Age Using Birthdate  */
SELECT birthdate,
STRFTIME('%Y', birthdate) AS year,
STRFTIME('%m', birthdate) AS month,
STRFTIME('%d', birthdate) AS day,
DATE(('now')-birthdate) AS Age   -- return integer number of age
FROM employees;

/* Case Statements */
/* Learning Objectives:
1. Define what a CASE statement does.
2. Describe situations where a CASE statement is useful.
3. Explain the parts of CASE statement syntax.
4. Use a CASE statement with correct syntax.
5. Explain how to categorize, or bin, your data. */

/* What is a Case Statement */
/* MImics if-then-else statement found in most programming languages.
Can be used in SELECT, INSERT, UPDATE, and DELETE statements   */
CASE
WHEN C1 THEN E1
WHEN C2 THEN E2
...
ELSE [result else]
END

CASE input_expression
     WHEN when_expression THEN result_expression [...n]
	 [ ELSE else_result_expression ]
END

-- Simple Case Statement
SELECT employeeid, firstname, lastname, city,
       CASE city WHEN 'Calgary' THEN 'Calgary'
	                            ELSE 'Other'
								END calgary
FROM employees 
ORDER BY lastname, firstname;

-- Search Case Statement 
CASE WHEN boolean_expression
THEN result_expression [...n]
[ ELSE else_result_expression ]
END
-- example
SELECT trackid, name, bytes, 
CASE WHEN bytes < 300000 THEN 'small'
     WHEN bytes >= 300001 AND bytes <= 500000 THEN 'medium'
	 WHEN bytes >= 500001 THEN 'large'
	 ELSE 'Other'
	 END bytescategory
FROM tracks;
/* Note: Things after THEN don't have to be a string or number, it can be a field from another column */

/* Views  */
/* Learning Objectives:
1. Discuss how and when to use views with queries.
2. Explain how to use the AS function with views.
3. Explain the benefits and limitations of using views.  */
-- Overview of Views
/* 1. A stored query.
2. Can add or remove columns without changing schema.
3. Use it to encapsulate queries.
4. The view will be removed after database connection has ended. */
CREATE [TEMP] VIEW [IF NOT EXISTS]
view_name(column-name-list)
AS
select-statement;

/* Creating a View example  */
CREATE VIEW my_view 
AS
SELECT r.regiondescription, t.territorydescription, e.lastname, e.firstname, e.hiredate, e.reportsto
FROM region r
INNER JOIN territories t on r.regionid = t.regionid
INNER JOIN employeeterritories et on t.territoryID = et.territoryID
INNER JOIN employees e on et.employeeid = e.employeeid;

SELECT *
FROM my_view
DROP VIEW my_view;   -- Drop the my_view table for this session

-- Get a count of how many territories each employee has
SELECT count(territorydescription), lastname, firstname
FROM my_view
GROUP BY lastname, firstname;
/* View is temporary and is only good for that session */

/* Data Governance and Profiling */
/* Learning Objectives:
1. Define data governance and profiling.
2. Explain importance of data governance and profiling your data appropriately.
3. Discuss methods of profiling your data .       */

-- What is Data Profiling?
/* 1. Looking at descriptive statistics or object data information - examining data for completeness and accuracy.
2. Important to understand your data before you query it.      */
-- Object Data Profile, (data values)
-- 1. Number of rows
-- 2. Table size
-- 3. When the object was last updated
/* Column Data Profile 
1. Column data type: string, interger or date
2. Number of distinct values
3. Number of rows with NULL values
4. Descriptive statistics: maximum, average and standard deviation for column values  */

-- Governance Best Practices
/* 1. Understand your read and write capabilities.
2. Clean up your environments
3. Understand your promotion process. */


-- Using SQL for Data Science
/* Learning Objectives:
1. Discuss importance of understanding your data when starting a new problem.
2. Discuss importance of udnerstanding business needs before beginning data analysis.  */

/* Working Through a Problem from Beginning to End:
Data Understanding --  Business Undestanding -- Profling -- Start with SELECT(start small) -- Test -- Format & Comment -- Review   */

-- Data Understanding: Most important step; Understanding relationships in your data; NULL values; String values; Dates and times
/* Subject Area Understanding:
1. Until you gain business understanding, writing queries may take more time.
2. Understanding where data joins are.
3. Differentiating integers from strings.
4. Investing time to understand your subject will help later during data analysis */

-- Business Understanding: Ask questions about business problem you are solving; Hard to separate data and business understanding.
-- Moving Between Data and Business Understanding

/* Profiling the data: Using SQL for Data Science  */
/* Learning Objectives:
1. Determine and map out data elements needed for a query.
2. Discuss strategies to use to write complex queries.
3. Explain common troubleshooting techniques. */
-- Profiling Data
/* 1. Get into the details of your data.
2. Create a data model and map the fields and tables you need
3. Consider joins and calculations
4. Understand any data quality or format issues.    */

--Test and Troubleshoot
/* 1. Do not wait until the end to test queries.
2. Test after each join or filter.
3. Are you getting the results you expect?
4. Start small and go step-by-step when troubleshooting a query.    */

-- Format and Comment
/* 1. Use correct formatting and indention.
2. Comment strategically.
3. Clean code and comments help when you revisit or hand off code.   */

-- Review: Always review old queries -- Business rules -- Date changes/indicators -- Work the problem for beginning to end
-- Base SQL Exercise

-- Exercise JOIN
SELECT  cust.customerid, cust.firstname, cust.lastname, items.order_date, items.item, items.price
FROM customers as cust JOIN items_ordered as items ON cust.customerid=items.customerid
SELECT  cust.customerid, cust.firstname, cust.lastname, items.order_date, items.item, items.price
FROM customers as cust JOIN items_ordered as items ON cust.customerid=items.customerid ORDER BY cust.state DESC

-- Exercise 1
SELECT salesperson.id, salesperson.name, orders.number
FROM salesperson, orders WHERE salesperson.id = orders.salesperson_id and orders.cust_id = '4';

SELECT sales.name FROM salesperson as sales 
WHERE sales.id IN(SELECT orders.salesperson_id from orders as orders JOIN customers as cust on orders.cust_id=cust.id where cust.name='Samsonic')

-- Exercise 1, a
SELECT id, name
FROM salesperson 
WHERE salesperson_id in(SELECT orders.salesperson_id FROM orders, customer WHERE orders.cust_id = customer.id and customer.name='Samsonic');

--Exercise 1, b
SELECT orders.salesperson_id FROM orders, customer WHERE orders.cust_id = customer.id AND customer.name='Samsonic'
SELECT salesperson.name FROM salesperson, orders WHERE salesperson.id = orders.salesperson_id AND 
cust_id NOT IN(SELECT orders.salesperson_id FROM orders, customer WHERE orders.cust_id = customer.id AND customer.name='Samsonic')

--Exercise 1, c
SELECT salesperson_id FROM oders GROUP BY salesperson_id HAVING COUNT(salesperson_id) >1;


SELECT salesperson.name
FROM salesperson, orders where salesperson.id = orders.salesperson_id 
GROUP BY salesperson.name, salesperson.salesperson_id
HAVING COUNT(salesperson.salesperson_id) > 1; 

-- Exercise 1 , d
INSERT INTO highAchiever (name, age)
(SELECT name, age FROM salesperson WHERE salary > 100000);
INSERT INTO highAchiever (name, age) VALUES ('Jackson', 28);

-- Exercise 2, a
SELECT user.user_id, name, phone_num, MAX(userhistory.date) 
FROM user, userhistory WHERE user.user_id = userhistory.user_id AND
(CURDATE() - DATE <= 30) and userhistory.action = 'logged_on'
GROUP BY user.user_id;

-- Exercise 2, b
SELECT DISTINCT user.userid
FROM user 
LEFT JOIN userhistory on user.user_id = userhistory.user_id
WHERE userhistory.user_id is NULL;

( SELECT ROW_NUMBER() OVER (PARTITION BY var1 ORDER BY SortColumn DESC) AS RowNumber, * 
               FROM YourTable)
SELECT * FROM CTE WHERE RowNumber = 2

SELECT MAX( col )
  FROM table
 WHERE col < ( SELECT MAX( col )
                 FROM table )

-- Exercise 3 Wrong Solution
SELECT orders.salesperson_id, MAX(orders.amount), orders.number, cust.name
FROM orders JOIN customer on orders.cust_id = customer.id
GROUP BY orders.salesperson_id

--Exercise 3 , Right Solution
SELECT salesperson_id, MAX(orders.amount) as Max_amount FROM orders GROUP BY salesperson_id 
SELECT salesperson_id, number as Ordernum, amount FROM orders
JOIN (SELECT salesperson_id, MAX(orders.amount) as Max_amount FROM orders GROUP BY salesperson_id ) AS Toptable
USING (salesperson_id)  WHERE amount = Max_amount;


SELECT salesperson_id, name, orders.number as ordernumber, orders.amount
FROM orders JOIN salesperson ON orders.salesperson_id = salesperson.id
JOIN (SELECT salesperson_id, MAX(amount) as MAXORDER from orders GROUP BY salesperson_id) as Toptable
USING salesperson_id
WHERE orders.amount = maxorder















































