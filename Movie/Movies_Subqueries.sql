--USE MOVIE
--GO

--1. Write a SQL query to find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
SELECT
	act_id, act_fname, act_lname, act_gender
FROM
	actor
WHERE
	act_id IN
	(SELECT act_id FROM movie_cast
		WHERE mov_id IN 
		(SELECT mov_id FROM movie
			WHERE mov_title = 'Annie Hall'))
GO

--2. Write a SQL query to find the director of a film that cast a role in 'Eyes Wide Shut'. Return director first name, last name.
SELECT
	dir_fname, dir_lname
FROM
	director
WHERE
	dir_id IN 
	(SELECT dir_id FROM movie_direction
		WHERE mov_id IN
		(SELECT mov_id FROM movie_cast
			WHERE role = ANY
			(SELECT role FROM movie_cast
				WHERE mov_id IN
				(SELECT mov_id FROM movie
					WHERE mov_title = 'Eyes Wide Shut'))))
GO

--3. Write a SQL query to find those movies that have been released in countries other than the United Kingdom. 
--Return movie title, movie year, movie time, and date of release, releasing country.
SELECT
	mov_title, mov_year, mov_time, mov_dt_rel, mov_rel_country
FROM
	movie
WHERE
	mov_rel_country NOT IN ('UK')
GO

--4. write a SQL query to find for movies whose reviewer is unknown.
--Return movie title, year, release date, director first name, last name, actor first name, last name.
SELECT
	mv.mov_title, mv.mov_year, mv.mov_dt_rel, dr.dir_fname, dr.dir_lname, ac.act_fname, ac.act_lname
FROM 
	movie mv, director dr, movie_direction md, actor ac, movie_cast mc
WHERE 
	mv.mov_id = md.mov_id AND 
	dr.dir_id = md.dir_id AND
	mv.mov_id = mc.mov_id AND
	ac.act_id = mc.act_id AND
	mv.mov_id IN
      (SELECT rt.mov_id
          FROM 
			rating rt, reviewer rv
          WHERE 
			rt.rev_id = rv.rev_id AND 
			rv.rev_name IS NULL)
GO

--5. Write a SQL query to find those movies directed by the director whose first name is Woody and last name is Allen. Return movie title.
SELECT
	mov_title
FROM
	movie
WHERE
	mov_id IN
	(SELECT mov_id FROM movie_direction
		WHERE dir_id IN
		(SELECT	dir_id FROM director
			WHERE
				dir_fname = 'Woody' AND
				dir_lname = 'Allen'))
GO

--6. Write a SQL query to determine those years in which there was at least one movie that received a rating of at least three stars. 
--Sort the result-set in ascending order by movie year. Return movie year.
SELECT DISTINCT 
	mov_year
FROM 
	movie
WHERE
	mov_id IN
	(SELECT mov_id FROM rating
    WHERE rev_stars >= 3)
ORDER BY 
	mov_year ASC
GO

--7. Write a SQL query to search for movies that do not have any ratings. Return movie title.
SELECT DISTINCT
	mov_title
FROM
	movie
WHERE
	mov_id IN
	(SELECT mov_id FROM movie
		WHERE mov_id NOT IN (SELECT mov_id FROM rating))
GO

--8. Write a SQL query to find those reviewers who have not given a rating to certain films. Return reviewer name.
SELECT
	rev_name
FROM
	reviewer
WHERE
	rev_id IN 
	(SELECT rev_id FROM rating
		WHERE rev_stars IS NULL)
GO

--9. Write a SQL query to find movies that have been reviewed by a reviewer and received a rating. 
--Sort the result-set in ascending order by reviewer name, movie title, review Stars. 
--Return reviewer name, movie title, review Stars.
SELECT
	rv.rev_name, mv.mov_title, rt.rev_stars
FROM
	reviewer rv, movie mv, rating rt
WHERE
	mv.mov_id = rt.mov_id AND
	rv.rev_id = rt.rev_id AND
	rt.rev_stars IS NOT NULL AND
	rv.rev_name IS NOT NULL
ORDER BY
	rv.rev_name ASC, mv.mov_title, rt.rev_stars
GO

--10. Write a SQL query to find movies that have been reviewed by a reviewer and received a rating. 
--Group the result set on reviewer’s name, movie title. Return reviewer’s name, movie title.
SELECT
	rv.rev_name, mv.mov_title
FROM
	movie mv, reviewer rv, rating rt, rating rt2
WHERE
	mv.mov_id = rt.mov_id AND
	rv.rev_id = rt.rev_id AND
	rv.rev_id = rt2.rev_id
GROUP BY
	rv.rev_name, mv.mov_title
HAVING
	COUNT(*) > 1
GO

--11. write a SQL query to find those movies, which have received highest number of stars.
--Group the result set on movie title and sorts the result-set in ascending order by movie title. 
--Return movie title and maximum number of review stars.
SELECT
    mv.mov_title, MAX(rt.rev_stars) AS max_review_stars
FROM 
	movie mv, rating rt
WHERE 
	mv.mov_id = rt.mov_id AND 
	rt.rev_stars = (SELECT MAX(rev_stars) FROM rating)
GROUP BY 
	mv.mov_title
ORDER BY
	mv.mov_title ASC;
GO

--12. Write a SQL query to find all reviewers who rated the movie 'American Beauty'. Return reviewer name.
SELECT
	rv.rev_name
FROM
	reviewer rv
WHERE
	rv.rev_id IN
		(SELECT rt.rev_id FROM rating rt
			WHERE rt.mov_id IN (SELECT mv.mov_id FROM movie mv
								WHERE mv.mov_title = 'American Beauty'))
GO

--13. Write a SQL query to find the movies that have not been reviewed by any reviewer body other than 'Paul Monks'. Return movie title.
SELECT
	mov_title
FROM
	movie
WHERE
	mov_id IN
	(SELECT mov_id FROM rating
		WHERE rev_id NOT IN
		(SELECT rev_id FROM reviewer
			WHERE rev_name = 'Paul Monks'))
GO

--14. Write a SQL query to find the movies with the lowest ratings. Return reviewer name, movie title, and number of stars for those movies.
SELECT
    r.rev_name, m.mov_title, rt.rev_stars
FROM 
	reviewer r, movie m, rating rt
WHERE
	r.rev_id = rt.rev_id AND 
	m.mov_id = rt.mov_id AND 
	rt.rev_stars =
      (SELECT MIN(rev_stars) FROM rating)
GO

--15. Write a SQL query to find the movies directed by 'James Cameron'. Return movie title.
SELECT
	mv.mov_title
FROM
	movie mv
WHERE
	mv.mov_id IN
	(SELECT md.mov_id FROM movie_direction md
		WHERE md.dir_id IN (SELECT d.dir_id FROM director d
								WHERE d.dir_fname = 'James' AND d.dir_lname = 'Cameron'))
GO

--16. Write a query in SQL to find the movies in which one or more actors appeared in more than one film.
SELECT
	mov_title
FROM
	movie
WHERE
	mov_id IN
	(SELECT mov_id FROM movie_cast
		WHERE act_id IN
		(SELECT act_id FROM movie_cast
			GROUP BY act_id
			HAVING COUNT(act_id) > 1))
GO