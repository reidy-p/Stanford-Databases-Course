-- Q1
--  Add the reviewer Roger Ebert to your database, with an rID of 209.
INSERT INTO Reviewer (rID, name)
Values (209, "Roger Ebert")

-- Q2
--  Insert 5-star ratings by James Cameron for all movies in the database.
-- Leave the review date as NULL.
INSERT into Rating
  SELECT Rating.rID, Movie.mID, 5 AS stars, null AS ratingDate
  FROM Rating, Movie, Reviewer
  WHERE Rating.rID = Reviewer.rID
  AND Reviewer.name = 'James Cameron';

INSERT into Rating
  SELECT 207 as rID, Movie.mID, 5 AS stars, null AS ratingDate
  FROM Movie;

-- Q3
-- For all movies that have an average rating of 4 stars or higher, add 25 to the
-- release year. (Update the existing tuples; don't insert new tuples.)
UPDATE Movie
SET year = year + 25
WHERE mID in (
    SELECT Movie.mID
    FROM Movie
    JOIN Rating
    ON Movie.mID = Rating.mID
    GROUP BY Movie.mID
    HAVING avg(stars) >= 4)

-- Q4
-- Remove all ratings where the movie's year is before 1970 or after 2000,
-- and the rating is fewer than 4 stars. 
DELETE FROM Rating
WHERE mID in (
  SELECT distinct Rating.mID
  FROM Movie, Rating
  WHERE Movie.mID = Rating.mID
  AND (Movie.year > 2000 OR Movie.year < 1970)
)
AND stars < 4
