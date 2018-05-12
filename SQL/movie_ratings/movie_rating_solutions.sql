-- Q1
--  Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM Movie
WHERE director = "Steven Spielberg";

-- Q2
--  Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.
SELECT distinct Movie.year
FROM Rating
INNER JOIN Movie
ON Rating.mID = Movie.mID
WHERE Rating.stars >= 4
ORDER BY Movie.year;

-- Q3
--  Find the titles of all movies that have no ratings.
SELECT distinct Movie.title
FROM Movie
WHERE Movie.mID not in (SELECT distinct mID FROM Rating);

-- Q4
--  Some reviewers didn't provide a date with their rating. Find the names
-- of all reviewers who have ratings with a NULL value for the date.
SELECT Reviewer.name
FROM Rating INNER JOIN Reviewer
ON Rating.rID = Reviewer.rID
WHERE ratingDate is null;

-- Q5
-- Write a query to return the ratings data in a more readable format: reviewer
-- name, movie title, stars, and ratingDate. Also, sort the data, first by
-- reviewer name, then by movie title, and lastly by number of stars.
SELECT T.name, Movie.title, T.stars, T.ratingDate
FROM (Rating INNER JOIN Reviewer
ON Rating.rID = Reviewer.rID) T
INNER JOIN Movie
ON T.mID = Movie.mID
ORDER BY T.name, Movie.title, T.stars;

-- Q6
-- For all cases where the same reviewer rated the same movie twice and
-- gave it a higher rating the second time, return the reviewer's name and
-- the title of the movie.
SELECT Reviewer.name, Movie.title
FROM Rating, Rating A
JOIN Reviewer
ON Rating.rID = Reviewer.rID
JOIN Movie
ON Rating.mID = Movie.mID
WHERE Rating.rID = A.rID
AND Rating.mID = A.mID
AND Rating.ratingDate < A.ratingDate
AND Rating.stars < A.stars;

-- Q7
--  For each movie that has at least one rating, find the highest number of
-- stars that movie received. Return the movie title and number of stars.
-- Sort by movie title.
SELECT Movie.title, max(stars)
FROM Rating
JOIN Movie ON Rating.mID = Movie.mID
GROUP BY Movie.mID
ORDER BY Movie.title;

-- Q8
--  For each movie, return the title and the 'rating spread', that is, the
-- difference between highest and lowest ratings given to that movie. Sort by
-- rating spread from highest to lowest, then by movie title.
SELECT movie.title, max(Rating.stars) - min(Rating.stars) AS spread
FROM Rating
JOIN Movie ON Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY spread desc, movie.title;

-- Q9
--  Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980. (Make sure to
-- calculate the average rating for each movie, then the average of those
-- averages for movies  before 1980 and movies after. Don't just calculate the
-- overall average rating before and after 1980.) 
SELECT X.avg_stars_2 - Y.avg_stars_B
FROM
(SELECT avg(B.avg_stars_1) as avg_stars_2
FROM
(SELECT Rating.mID, avg(stars) as avg_stars_1
FROM Rating JOIN Movie ON Rating.mID = Movie.mID
GROUP BY Rating.mID
HAVING movie.year < 1980) B) X,
(SELECT avg(C.avg_stars_A) as avg_stars_B
FROM
(SELECT Rating.mID, avg(stars) as avg_stars_A
FROM Rating JOIN Movie ON Rating.mID = Movie.mID
GROUP BY Rating.mID
HAVING movie.year > 1980) C) Y;
