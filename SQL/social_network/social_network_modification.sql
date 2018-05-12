-- Q1
-- It's time for the seniors to graduate. Remove all 12th graders
-- from Highschooler. 
DELETE FROM Highschooler
WHERE grade = 12;

-- Q2
-- If two students A and B are friends, and A likes B but not vice-versa,
-- remove the Likes tuple.
delete from Likes
where ID1 in (
  select ID1 from (
    select A.ID1, A.ID2
    from Friend, Likes A
    where Friend.ID1 = A.ID1
    and Friend.ID2 = A.ID2
    except
    select B.ID1, B.ID2
    from Likes B, Likes C
    where B.ID1 = C.ID2
    and B.ID2 = C.ID1
  )
)

-- Q3
-- For all cases where A is friends with B, and B is friends with C, add a new
-- friendship for the pair A and C. Do not add duplicate friendships,
-- friendships that already exist, or friendships with oneself. (This one is a
-- bit challenging; congratulations if you get it right.)
-- ?
