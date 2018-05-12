-- Q1
-- Find the names of all reviewers who rated Gone with the Wind.
SELECT Reviewer.name
FROM Reviewer
WHERE rID in (SELECT distinct rID
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
WHERE Rating.mID = 101);

-- Q2
-- For any rating where the reviewer is the same as the director of the movie,
-- return the reviewer name, movie title, and number of stars.
SELECT Movie.director, Movie.title, Rating.stars
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
JOIN Reviewer
ON Rating.rID = Reviewer.rID
WHERE Reviewer.name = Movie.director;

-- Q3
-- Return all reviewer names and movie names together in a single list,
-- alphabetized. (Sorting by the first name of the reviewer and first word in
-- the title is fine; no need for special processing on last names
-- or removing "The".)
SELECT name
FROM Reviewer
UNION
SELECT title
FROM Movie;

-- Q4
-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT title
FROM Movie
WHERE mID not in
(SELECT distinct Rating.mID
FROM Reviewer
JOIN Rating
ON Reviewer.rID = Rating.rID
WHERE Rating.rID = 205);

-- Q5
-- For all pairs of reviewers such that both reviewers gave a rating to the
-- same movie, return the names of both reviewers. Eliminate duplicates,
-- don't pair reviewers with themselves, and include each pair only once.
-- For each pair, return the names in the pair in alphabetical order.
SELECT distinct C.name, D.name
FROM Rating A, Rating B
JOIN Reviewer C
ON A.rID = C.rID
JOIN Reviewer D
ON B.rID = D.rID
WHERE A.mID = B.mID
AND C.name < D.name
ORDER BY C.name;

-- Q6
-- For each rating that is the lowest (fewest stars) currently in the database,
-- return the reviewer name, movie title, and number of stars.
SELECT Reviewer.name, Movie.title, Rating.stars
FROM Rating
JOIN Reviewer
ON Rating.rID = Reviewer.rID
JOIN Movie
ON Rating.mID = Movie.mID
WHERE stars = (SELECT min(stars) FROM Rating)

-- Q7
-- List movie titles and average ratings, from highest-rated to lowest-rated.
-- If two or more movies have the same average rating, list them
-- in alphabetical order.
SELECT Movie.title, avg(stars) as S
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY S desc, Movie.title

-- Q8
-- Find the names of all reviewers who have contributed three or more ratings.
-- (As an extra challenge, try writing the query without HAVING or
-- without COUNT.)
SELECT N
FROM
(SELECT Reviewer.name as N, COUNT(Rating.rID) as C
FROM Rating
JOIN Reviewer
ON Rating.rID = Reviewer.rID
GROUP BY Rating.rID
HAVING C >= 3);

-- Q9
-- Some directors directed more than one movie. For all such directors, return
-- the titles of all movies directed by them, along with the director name.
-- Sort by director name, then movie title. (As an extra challenge,
-- try writing the query both with and without COUNT.)
SELECT movie.title, director
FROM movie
WHERE director in
(SELECT director
FROM
(SELECT count(director) as C, director
FROM Movie
GROUP BY director
HAVING C > 1))
ORDER BY director, movie.title

-- Q10
-- Find the movie(s) with the highest average rating. Return the movie title(s)
-- and average rating. (Hint: This query is more difficult to write in
-- SQLite than other systems; you might think of it as finding the highest
-- average rating and then choosing the movie(s) with that average rating.)
SELECT title, avg(stars)
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
GROUP BY Rating.mID
HAVING avg(stars) =
(SELECT max(S)
FROM
(SELECT mID, avg(stars) as S
FROM Rating
GROUP BY Rating.mID))

-- Q11
-- Find the movie(s) with the lowest average rating. Return the movie title(s)
-- and average rating. (Hint: This query may be more difficult to write in
-- SQLite than other systems;  you might think of it as finding the lowest
-- average rating and then choosing the movie(s) with that average rating.)
SELECT title, avg(stars)
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
GROUP BY Rating.mID
HAVING avg(stars) =
(SELECT min(S)
FROM
(SELECT mID, avg(stars) as S
FROM Rating
GROUP BY Rating.mID))

-- Q12
-- For each director, return the director's name together with the title(s)
-- of the movie(s) they directed that  received the highest rating among all of
-- their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director, Movie.title, max(stars)
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
WHERE director is not NULL
GROUP BY Movie.director

SELECT X.director, X.title, Rating.stars
FROM Rating
JOIN
(SELECT Rating.rID, director, title,  max(stars) as m
FROM Rating
JOIN Movie
ON Rating.mID = Movie.mID
WHERE director is not NULL
GROUP BY Movie.director) X
ON Rating.rID = X.rID
WHERE Rating.stars = m
ORDER BY X.director;
