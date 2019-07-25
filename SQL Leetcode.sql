-- SQL Leetcode
1. Delete Duplicate Emails
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+

Answer:
SELECT DISTINCT email, MIN(id) AS id FROM person GROUP  BY email;
SELECT * FROM person WHERE id in(SELECT a.id FROM(SELECT email, MIN(id) AS id FROM person GROUP  BY email) AS a);
DELETE FROM person WHERE id NOT IN(SELECT a.id FROM(SELECT email, MIN(id) AS id FROM person GROUP BY email) as a);

2. Customers Who Never Order 
Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+

Answer:
SELECT a.name FROM Customers a, Orders b WHERE a.id <> b.customerid;    -- Wrong Answer, not Acceptable
SELECT name FROM customers WHERE id NOT IN(SELECT customerid FROM orders);

3. Rising Temperature, DATEDIFF() is only recognized in MySQL, does not recognized in Oracle
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
For example, return the following Ids for the above Weather table:

+----+
| Id |
+----+
|  2 |
|  4 |
+----+

Answer:
SELECT a.id FROM weather a, weather b WHERE DATEDIFF(a.recorddate, b.recorddate)=1 AND a.temperature > b.temperature;
SELECT id, recoddate, temperature, lag(temperature,1) over (order by recorddate) AS last_temperature FROM weather HAVING tenperature>last_temperature;


4. Second Highest Salary

Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

Answer:
SELECT MAX(salary) AS secondhighestSalary FROM employee WHERE salary <(SELECT MAX(salary) FROM employee);

5. Nth Highest Salary -- Use Function in SQL
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
-- For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+

Answer:
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N=N-1;
  RETURN (
      # Write your MySQL query statement below.
      select distinct salary from employee 
      order by salary desc
      limit N, 1
  );
END


6. Rank Scores
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+

Answer:
SELECT round(score,2) as score, DENSE_RANK() OVER (ORDER BY round(score,2) DESC) AS rank FROM scores;

7. Big Countries
There is a table World

+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries name, population and area.

For example, according to the above table, we should output:

+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+
 
Answer:
SELECT name, population, area FROM world WHERE area>3000000 OR population> 25000000;


8. Classes More than 5 Students
There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:

+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
Should output:

+---------+
| class   |
+---------+
| Math    |
+---------+
 

Note:
The students should not be counted duplicate in each course.

Answer:
SELECT class FROM courses GROUP BY class HAVING COUNT(DISTINCT student)>=5;


9. Trips and Users

The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
Write a SQL query to find the cancellation rate of requests made by unbanned users between Oct 1, 2013 and Oct 3, 2013. For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+

Answer:
SELECT a.request_at AS day, round(SUM(CASE WHEN a.status IN('cancelled_by_client', 'cancelled_by_driver') THEN 1 ELSE 0 END)/COUNT(a.status), 2) AS 'Cancellation Rate' 
FROM trips a 
JOIN(SELECT users_id, role FROM users WHERE banned='No') b ON a.client_id=b.users_id AND b.role='client' 
JOIN (SELECT users_id, role FROM users WHERE banned='No') c on a.driver_id=c.users_id AND c.role='driver' 
WHERE a.request_at BETWEEN DATE('2013-10-01') AND DATE('2013-10-03') 
GROUP BY a.request_at;


10. Consecutive Numbers
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+

Answer:
SELECT DISTINCT a.num AS consecutivenums FROM logs a
JOIN logs b ON a.num=b.num and a.id=b.id-1
JOIN logs c ON b.num=c.num AND b.id=c.id-1;

11. Combine Two Tables

Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.
Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table.
 

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

FirstName, LastName, City, State

Answer:
SELECT a.firstname, a.lastname, b.city, b.state FROM person AS a LEFT JOIN address AS b ON a.personid=b.personid;


12. Not Boring Movies

X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.
For example, table cinema:

+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
For the example above, the output should be:
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+

Answer:
SELECT * FROM cinema WHERE description != 'boring' AND id%2 =1 AND MOD(id,2)=1 ORDER BY rating DESC;

13. Duplicate Emails

Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+

Answer:
SELECT DISTINCT email FROM person GROUP BY email HAVING COUNT(*)>1;

14. Department Top Three Salaries, Oracle can evaluate the rank(), dense_rank(), row_number() function
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
Explanation:

In IT department, Max earns the highest salary, both Randy and Joe earn the second highest salary, and Will earns the third highest salary. There are only two employees in the Sales department, Henry earns the highest salary while Sam earns the second highest salary.

Answer:
SELECT a.name AS department, b.employee, b.salary FROM department a JOIN (
SELECT departmentid, name AS employee, salary, DENSE_RANK() over (PARTITION BY departmentid ORDER BY salary DESC) AS rank FROM employee ) b ON a.id=b.departmentid AND b.rank <=3;

15. Department Highest Salary

The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
Explanation:

Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

Answer:
SELECT a.name AS department, b.employee, b.salary FROM department a JOIN(
SELECT departmentid, name AS employee, salary, RANK() over (PARTITION BY departmentid ORDER BY salary DESC) AS rank FROM employee) b ON a.id=b.departmentid AND b.rank=1;


16. Exchange Seats

-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.
 

Mary wants to change seats for the adjacent students.
 

Can you write a SQL query to output the result for Mary?
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:
-- If the number of students is odd, there is no need to change the last one's seat.

Answer:
SELECT a.id_2 AS id, a.student FROM
(SELECT s.student, 
CASE WHEN MOD(s.id, 2)=0 THEN s.id-1
     WHEN MOD(s.id, 2)=1 AND s.id<c.counts THEN s.id+1 ELSE c.counts END AS id_2
FROM seat s JOIN(SELECT COUNT(*) AS counts FROM seat) c) a
ORDER BY a.id_2;

17. Employees Earning More Than Their Managers
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+

Answer:
SELECT a.name AS employee FROM
(SELECT name, managerid, salary AS salary_employee FROM employee WHERE managerid IS NOT NULL) a
JOIN (SELECT id, salary FROM employee) b ON a.managerid=b.id
AND a.salary_employee > b.salary;

18. Median Employee Salary

The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

Id	Company	Salary
1	A	2341
2	A	341
3	A	15
4	A	15314
5	A	451
6	A	513
7	B	15
8	B	13
9	B	1154
10	B	1345
11	B	1221
12	B	234
13	C	2345
14	C	2645
15	C	2645
16	C	2652
17	C	65
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

Id	Company	Salary
5	A	451
6	A	513
12	B	234
9	B	1154
14	C	2645

SELECT a.id, a.company, a.salary FROM employee a JOIN( SELECT b.company, b.salary FROM(
SELECT company, salary, ROW_NUMBER() over (PARTITION BY company ORDER BY salary) AS rank,
COUNT(*) over (PARTITION BY Company) AS counts FROM employee) AS b WHERE b.rank BETWEEN b.counts/2 AND b.counts/2+1) AS c ON a.company=c.company AND a.salary=c.salary;


19. Second Degree Follower

In facebook, there is a follow table with two columns: followee, follower.

Please write a sql query to get the amount of each follower’s follower if he/she has one.

For example:

followee	follower
A	B
B	C
B	D
D	E
should output:

follower	num
B	2
D	1
Explaination:
Both B and D exist in the follower list, when as a followee, B’s follower is C and D, and D’s follower is E. A does not exist in follower list.

Note:
Followee would not follow himself/herself in all cases.
Please display the result in follower’s alphabet order.

Answer:
SELECT DISTINCT a.follower, b.num FROM follow a
JOIN (SELECT followee, COUNT(DISTINCT follower) AS num FROM follow GROUP  BY followee) b ON a.follower=b.followee
ORDER BY a.follower;


20. Get Highest Rate Answer Question

Get the highest answer rate question from a table survey_log with these columns: uid, action, question_id, answer_id, q_num, timestamp.

uid means user id; action has these kind of values: “show”, “answer”, “skip”; answer_id is not null when action column is “answer”, while is null for “show” and “skip”; q_num is the numeral order of the question in current session.

Write a sql query to identify the question which has the highest answer rate.

Example:

Input:

uid	action	question_id	answer_id	q_num	timestamp
5	show	285	null	1	123
5	answer	285	124124	1	124
5	show	369	null	2	125
5	skip	369	null	2	126
Output:

survey_log
285
Explanation:
question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.

Note: The highest answer rate meaning is: answer number’s ratio in show number in the same question.
Answer:
SELECT a.question_id AS survey_log FROM (SELECT question_id, SUM(IF(answer_id IS NULL, 0, 1))/COUNT(*) AS ans_rate FROM servey_log GROUP BY question) a
ORDER BY a.ans_rate DESC LIMIT 1;

21. Winning Candidate
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+
Notes:
You may assume there is no tie, in other words there will be at most one winning candidate.

Answer:
SELECT a.name FROM candiate a JOIN (SELECT candidateid, COUNT(*) AS num FROM vote GROUP BY candidateid) b ON a.id=b.candidateid ORDER BY b.num DESC LIMIT 1;

22: Managers with at Least 5 Direct Reports

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+

Answer:
SELECT name FROM emplyee WHERE id IN(SELECT managerid FROM employee WHERE managerid IS NOT NULL GROUP BY managerid HAVING COUNT(DISTINCT id)>=5);

23. Biggest Single Number 
Table number contains many numbers in column num including duplicated ones.

Can you write a SQL query to find the biggest number, which only appears once.

num
8
8
3
3
1
4
5
6
For the sample data above, your query should return the following result:

num
6
Note;
If there is no such number, just output null.

Answer:
SELECT a.num FROM (SELECT DISTINCT num FROM number GROUP BY num HAVING COUNT(*)=1) a ORDER BY a.num DESC LIMIT 1;
SELECT MAX(a.num) FROM (SELECT DISTINCT num FROM number GROUP BY num HAVING COUNT(*)=1) a;

24. Shortest Distance in a Line
Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
Write a query to find the shortest distance between two points in these points.

x
-1
0
2
The shortest distance is ‘1’ obviously, which is from point ‘-1’ to ‘0’. So the output is as below:

shortest
1
Note: Every point is unique, which means there is no duplicates in table point.
Follow-up: What if all these points have an id and are arranged from the left most to the right most of x axis?

Answer:
SELECT MIN(ABS(a.x-b.x)) FROM point a JOIN point b ON a.x != b.x;

25. Swap Salary  (Just not like Switch Seats, Compare with that)

Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.

For example:

id	name	sex	salary
1	A	m	2500
2	B	f	1500
3	C	m	5500
4	D	f	500
After running your query, the above salary table should have the following rows:

id	name	sex	salary
1	A	f	2500
2	B	m	1500
3	C	f	5500
4	D	m	500
SELECT id, name, CASE WHEN sex='f' THEN 'm' WHEN sex='m' THEN 'f' END AS sex, salary FROM salary;










































