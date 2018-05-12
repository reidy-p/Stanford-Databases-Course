-- Q1
-- For every situation where student A likes student B, but student B likes a
-- different student C, return the names and grades of A, B, and C.
SELECT c.name, c.grade, d.name, d.grade, e.name, e.grade
FROM Likes as a
JOIN Likes as b
ON a.ID2 = b.ID1
JOIN Highschooler as c
ON a.ID1 = c.ID
JOIN Highschooler as d
ON a.ID2 = d.ID
JOIN Highschooler as e
ON b.ID2 = e.ID
WHERE a.ID1 <> b.ID2

-- Q2
-- Find those students for whom all of their friends are in different grades
-- from themselves. Return the students' names and grades.
SELECT distinct Highschooler.name, Highschooler.grade
FROM Friend
JOIN Highschooler
ON Friend.ID1 = Highschooler.ID
WHERE Friend.ID1 not in
(SELECT distinct a.ID1
FROM Friend as a
JOIN Highschooler as b
ON a.ID1 = b.ID
JOIN Highschooler as c
ON a.ID2 = c.ID
WHERE b.grade = c.grade)

-- Q3
--  What is the average number of friends per student? (Your result should
-- be just one number.)
SELECT avg(A.num_friends)
FROM
(SELECT count(ID2) as num_friends
FROM Friend
GROUP BY Friend.ID1) A

-- Q4
-- Find the number of students who are either friends with Cassandra or are
-- friends of friends of Cassandra. Do not count Cassandra, even though technically
-- she is a friend of a friend.
SELECT count(*)
FROM Friend as a
JOIN Friend as b
ON a.ID2 = b.ID1
WHERE b.ID1 <> 1709 AND (a.ID2 = 1709 OR b.ID2 = 1709)

-- Q5
-- Find the name and grade of the student(s) with the greatest number of friends. 
SELECT Highschooler.name, Highschooler.grade
FROM
(SELECT Friend.ID1, count(*) as num_friends
FROM Friend
GROUP BY ID1
HAVING num_friends = (SELECT max(A) FROM (SELECT count(*) as A
                                          FROM Friend
                                          GROUP BY ID1))) B
JOIN Highschooler
ON Highschooler.ID = B.ID1
