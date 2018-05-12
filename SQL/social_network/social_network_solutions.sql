-- Q1
-- Find the names of all students who are friends with someone named Gabriel. 
SELECT name
FROM Highschooler
WHERE ID in
(SELECT FRIEND.ID2
FROM FRIEND
JOIN Highschooler
ON FRIEND.ID1 = Highschooler.ID
WHERE Highschooler.name = "Gabriel")

-- Q2
-- For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade, and the name and grade of the student
-- they like.
SELECT A.name, A.grade, Highschooler.name, Highschooler.grade
FROM
(SELECT name, grade, ID2 as I
FROM LIKES
JOIN Highschooler
ON LIKES.ID1 = Highschooler.ID) A
JOIN Highschooler
ON A.I = Highschooler.ID
WHERE A.grade - Highschooler.grade >= 2

-- Q3
-- For every pair of students who both like each other, return the name and
-- grade of both students. Include each pair only once, with the two names
-- in alphabetical order.
SELECT Highschooler.name, Highschooler.grade, T.name, T.grade
FROM
(SELECT Likes.ID1 as X, B.ID1 as Y
FROM Likes
JOIN Likes B
ON Likes.ID1 = B.ID2 AND Likes.ID2 = B.ID1) Q
JOIN Highschooler
ON Q.X = Highschooler.ID
JOIN Highschooler T
ON Q.Y = T.ID
WHERE Highschooler.name < T.name;

-- Q4
-- Find all students who do not appear in the Likes table (as a student who
-- likes or is liked) and return their names and grades. Sort by grade, then by
-- name within each grade.
SELECT name, grade
FROM Highschooler
WHERE ID not in (SELECT distinct ID1 FROM Likes)
AND ID not in (SELECT distinct ID2 FROM Likes)
ORDER BY grade, name

-- Q5
-- For every situation where student A likes student B, but we have no
-- information about whom B likes (that is, B does not appear as an ID1 in the Likes table),
-- return A and B's names and grades.
SELECT A.name, A.grade, Highschooler.name, Highschooler.grade
FROM
(SELECT *
FROM Likes
Join Highschooler
ON Likes.ID1 = Highschooler.ID
WHERE Likes.ID2 not in (SELECT distinct ID1 from Likes)) A
JOIN Highschooler
ON A.ID2 = Highschooler.ID

-- Q6
-- Find names and grades of students who only have friends in the same grade.
-- Return the result sorted by grade, then by name within each grade.
SELECT A.name, Highschooler.grade
FROM
(SELECT Friend.ID1, Friend.ID2, Highschooler.name, Highschooler.grade
FROM Friend
JOIN Highschooler
ON Friend.ID1 = Highschooler.ID) A
JOIN Highschooler
ON A.ID2 = Highschooler.ID
GROUP BY A.ID1
HAVING max(Highschooler.grade) - min(Highschooler.grade) = 0
ORDER BY Highschooler.grade, A.name

-- Q7
-- For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!). For all
-- such trios, return the name and grade of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, (
  select * from Likes
  except
  -- A likes B and A/B are friends
  select Likes.ID1, Likes.ID2
  from Likes, Friend
  where Friend.ID1 = Likes.ID1 and Friend.ID2 = Likes.ID2
) as LikeNotFriend
where F1.ID1 = LikeNotFriend.ID1
and F2.ID1 = LikeNotFriend.ID2
-- has a shared friend
and F1.ID2 = F2.ID2
and H1.ID = LikeNotFriend.ID1
and H2.ID = LikeNotFriend.ID2
and H3.ID = F2.ID2

-- Q8
-- Find the difference between the number of students in the school and the number of different first names.
SELECT count(distinct ID) - count(distinct name)
FROM Highschooler

-- Q9
-- Find the name and grade of all students who are liked by more than one other student.
SELECT Highschooler.name, Highschooler.grade
FROM Likes
JOIN Highschooler
ON Highschooler.ID = Likes.ID2
GROUP BY ID2
HAVING count(ID2) > 1
