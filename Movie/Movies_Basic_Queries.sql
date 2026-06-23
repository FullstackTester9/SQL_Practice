--USE MOVIE
--GO

--1. Write a SQL query to find the name and year of the movies. Return movie title, movie release year.
SELECT 
	mov_title AS Movie_Title, mov_year AS Movie_Release_Year
FROM 
	movie
GO

--2. Write a SQL query to find when the movie 'American Beauty' released. Return movie release year.
SELECT
	mov_year AS Movie_Release_Year
FROM
	movie
WHERE
	mov_title = 'American Beauty'
GO

--3. Write a SQL query to find the movie that was released in 1999. Return movie title.
SELECT
	mov_title AS Movie_Title
FROM
	movie
WHERE
	mov_year = 1999
GO

--4. Write a SQL query to find those movies, which were released before 1998. Return movie title.
SELECT
	mov_title AS Movie_Title
FROM
	movie
WHERE
	mov_year < 1998
GO

--5. Write a SQL query to find the name of all reviewers and movies together in a single list. 
SELECT rev_name FROM reviewer
UNION
SELECT mov_title FROM movie
GO

--6. Write a SQL query to find all reviewers who have rated seven or more stars to their rating. Return reviewer name.
SELECT DISTINCT 
	rev_name
FROM 
	reviewer
WHERE 
	rev_id IN
		(SELECT rev_id FROM rating    
		WHERE rev_stars >= 7)
GO



--7. Write a SQL query to find the movies without any rating. Return movie title.
SELECT
	mov_title AS Movies_Without_Rating
FROM
	movie
WHERE
	mov_id NOT IN 
		(SELECT mov_id FROM rating)
GO

--OR

SELECT
	mov_title
FROM
	movie m
WHERE
	NOT EXISTS
		(SELECT 1 FROM rating r WHERE r.mov_id = m.mov_id)
GO

--8. Write a SQL query to find the movies with ID 905 or 907 or 917. Return movie title.
SELECT
	mov_title
FROM
	movie
WHERE
	mov_id IN (905, 907, 917)
GO

--9. Write a SQL query to find the movie titles that contain the word 'Boogie Nights'. 
-- Sort the result-set in ascending order by movie year. Return movie ID, movie title and movie release year.
SELECT
	mov_id, mov_title, mov_year
FROM
	movie
WHERE
	mov_title = 'Boogie Nights'
ORDER BY
	mov_year
GO

--10. Write a SQL query to find those actors with the first name 'Woody' and the last name 'Allen'. Return actor ID. 
SELECT
	act_id
FROM
	actor
WHERE
	act_fname = 'Woody' AND act_lname = 'Allen'
GO