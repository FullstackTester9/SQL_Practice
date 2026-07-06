--USE MOVIE
--GO

--1. write a SQL query to find all reviewers whose ratings contain a NULL value. 
--Return reviewer name.
SELECT
	rv.rev_name
FROM
	reviewer rv
INNER JOIN
	rating rt
ON
	rv.rev_id = rt.rev_id
WHERE
	rt.rev_stars IS NULL

--2. write a SQL query to find out who was cast in the movie 'Annie Hall'. 
--Return actor first name, last name and role.
SELECT
	ac.act_fname, ac.act_lname, mc.role
FROM
	actor ac   
INNER JOIN
	movie_cast mc
ON
	ac.act_id = mc.act_id
INNER JOIN
	movie mv
ON
	mc.mov_id = mv.mov_id AND
	mv.mov_title = 'Annie Hall'
	
--3. write a SQL query to find the director who directed a movie that featured a role in 'Eyes Wide Shut'. 
--Return director first name, last name and movie title.
SELECT
	dr.dir_fname, dr.dir_lname, mv.mov_title
FROM
	director dr
INNER JOIN
	movie_direction md
ON
	dr.dir_id = md.dir_id
INNER JOIN
	movie mv
ON
	md.mov_id = mv.mov_id
WHERE
	mv.mov_title = 'Eyes Wide Shut'
--4. write a SQL query to find the director of a movie that cast a role as Sean Maguire. 
--Return director first name, last name and movie title.
SELECT
	dr.dir_fname, dr.dir_lname, mv.mov_title
FROM
	director dr
INNER JOIN
	movie_direction md
ON
	dr.dir_id = md.dir_id
INNER JOIN
	movie mv
ON
	md.mov_id = mv.mov_id
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
WHERE
	role = 'Sean Maguire'

--5. write a SQL query to find out which actors have not appeared in any movies between 1990 and 2000 (Begin and end values are included.).
--Return actor first name, last name, movie title and release year.
SELECT
	ac.act_fname, ac.act_lname, mv.mov_title
FROM
	actor ac
INNER JOIN
	movie_cast mc
ON
	ac.act_id = mc.act_id
INNER JOIN
	movie mv
ON
	mc.mov_id = mv.mov_id
WHERE
	mv.mov_year NOT BETWEEN 1990 AND 2000

--6. write a SQL query to find the directors who have directed films in a variety of genres.
--Group the result set on director first name, last name and generic title. 
--Sort the result-set in ascending order by director first name and last name. 
--Return director first name, last name and number of genres movies.
SELECT
	dr.dir_fname, dr.dir_lname, gn.gen_title, COUNT(gn.gen_title)
FROM
	director dr
INNER JOIN
	movie_direction md
ON
	dr.dir_id = md.dir_id
INNER JOIN
	movie_genres mg
ON
	md.mov_id = mg.mov_id
INNER JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
GROUP BY
	dr.dir_fname, dr.dir_lname, gn.gen_title
ORDER BY
	dr.dir_fname ASC,
	dr.dir_lname ASC

--7. write a SQL query to find the movies with year and genres. Return movie title, movie year and generic title.
SELECT
	mv.mov_title, mv.mov_year, gn.gen_title
FROM
	movie mv
LEFT JOIN
	movie_genres mg
ON
	mv.mov_id = mg.mov_id
RIGHT JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
ORDER BY
	mv.mov_title ASC

--8. write a SQL query to find all the movies with year, genres, and name of the director.
SELECT
	mv.mov_title, mv.mov_year, gn.gen_title, dr.dir_fname, dr.dir_lname
FROM
	movie mv
INNER JOIN
	movie_genres mg
ON
	mv.mov_id = mg.mov_id
INNER JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id

--9. write a SQL query to find the movies released before 1st January 1989. 
--Sort the result-set in descending order by date of release. 
--Return movie title, release year, date of release, duration, and first and last name of the director.
SELECT
	mv.mov_title, mv.mov_year, mv.mov_dt_rel, mv.mov_time, dr.dir_fname, dr.dir_lname
FROM
	movie mv
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
WHERE
	mv.mov_dt_rel < '1989-01-01'
ORDER BY
	mv.mov_dt_rel DESC

--10. write a SQL query to calculate the average movie length and count the number of movies in each genre.
--Return genre title, average time and number of movies for each genre.
SELECT
	gn.gen_title, AVG(mv.mov_time) AS AVG_MOV_TIME, COUNT(gn.gen_title) AS MOV_EACH_GENERE
FROM
	genres gn
INNER JOIN
	movie_genres mg
ON
	gn.gen_id = mg.gen_id
INNER JOIN
	movie mv
ON
	mg.mov_id = mv.mov_id
GROUP BY
	gn.gen_title


--11. write a SQL query to find movies with the shortest duration. 
--Return movie title, movie year, director first name, last name, actor first name, last name and role.
SELECT
	TOP(1) mv.mov_title, mv.mov_year, dr.dir_fname, dr.dir_lname, ac.act_fname, ac.act_lname, MIN(mv.mov_time)
FROM
	movie mv
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
INNER JOIN
	movie_cast mc
ON
	mc.mov_id = mv.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
GROUP BY
	mv.mov_title, mv.mov_year, dr.dir_fname, dr.dir_lname, ac.act_fname, ac.act_lname, mv.mov_time
ORDER BY
	mv.mov_time ASC

--12. write a SQL query to find the years in which a movie received a rating of 3 or 4. Sort the result in increasing order on movie year.
SELECT
	mv.mov_title, mv.mov_year, rt.rev_stars
FROM
	movie mv
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
WHERE
	rt.rev_stars IN (3, 4)
ORDER BY
	mv.mov_year ASC

--13. write a SQL query to get the reviewer name, movie title, and stars in an order that reviewer name will come first, 
--then by movie title, and lastly by number of stars.
SELECT
	rv.rev_name, mv.mov_title, rt.rev_stars
FROM
	movie mv
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
INNER JOIN
	reviewer rv
ON
	rt.rev_id = rv.rev_id
WHERE
	rv.rev_name IS NOT NULL
ORDER BY
	rv.rev_name ASC,
	mv.mov_title ASC,
	rt.rev_stars ASC

--14. write a SQL query to find those movies that have at least one rating and received the most stars. 
--Sort the result-set on movie title. Return movie title and maximum review stars.
SELECT
	mv.mov_title, MAX(rt.rev_stars)
FROM
	movie mv
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
GROUP BY
	mv.mov_title
HAVING
	MAX(rt.rev_stars) > 0
ORDER BY
	mv.mov_title
	
--15. write a SQL query to find out which movies have received ratings. 
--Return movie title, director first name, director last name and review stars.
SELECT
	mv.mov_title, dr.dir_fname, dr.dir_lname, rt.rev_stars
FROM
	movie mv
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
WHERE
	rt.rev_stars IS NOT NULL

--16. write a SQL query to find movies in which one or more actors have acted in more than one film. 
--Return movie title, actor first and last name, and the role.
SELECT
	mv.mov_title, ac.act_fname, ac.act_lname, mc.role
FROM
	movie mv
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
WHERE
	ac.act_id IN (SELECT act_id FROM movie_cast
					GROUP BY act_id
					HAVING COUNT(*) >= 2)

--17. write a SQL query to find the actor whose first name is 'Claire' and last name is 'Danes'.
--Return director first name, last name, movie title, actor first name and last name, role.
SELECT
	dr.dir_fname, dr.dir_lname, mv.mov_title, ac.act_fname, ac.act_lname, mc.role
FROM
	movie mv
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
WHERE
	ac.act_fname = 'Claire' AND
	ac.act_lname = 'Danes'

--18. write a SQL query to find for actors whose films have been directed by them. 
--Return actor first name, last name, movie title and role.
SELECT
	ac.act_fname, ac.act_lname, mv.mov_title, mc.role
FROM
	movie mv
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
WHERE
	dr.dir_fname = ac.act_fname AND
	dr.dir_lname = ac.act_lname

--19. write a SQL query to find the cast list of the movie ‘Chinatown’. Return first name, last name.
SELECT
	ac.act_fname, ac.act_lname
FROM
	movie mv
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
WHERE
	mv.mov_title = 'Chinatown'

--20. write a SQL query to find those movies where actor’s first name is 'Harrison' and last name is 'Ford'. Return movie title.
SELECT
	mv.mov_title
FROM
	movie mv
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
WHERE
	aC.act_fname = 'Harrison' AND
	ac.act_lname = 'Ford'

--21. write a SQL query to find the highest-rated movies. Return movie title, movie year, review stars and releasing country.
SELECT
	mv.mov_title, mv.mov_year, rt.rev_stars, mv.mov_rel_country
FROM
	movie mv
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
WHERE
	rt.rev_stars = (SELECT MAX(rev_stars) FROM rating)

--22. write a SQL query to find the highest-rated ‘Mystery Movies’. Return the title, year, and rating.
SELECT
	mv.mov_title, mv.mov_year, rt.num_o_ratings
FROM
	movie mv
INNER JOIN
	movie_genres mg
ON
	mv.mov_id = mg.mov_id
INNER JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
WHERE
	gn.gen_title = 'Mystery'

--23. write a SQL query to find the years when most of the ‘Mystery Movies’ produced. 
--Count the number of generic title and compute their average rating. 
--Group the result set on movie release year, generic title. 
--Return movie year, generic title, number of generic title and average rating.
SELECT
	mv.mov_year, GN.gen_title, COUNT(gn.gen_title), AVG(rt.rev_stars)
FROM
	movie mv
INNER JOIN
	movie_genres mg
ON
	mv.mov_id = mg.mov_id
INNER JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
WHERE
	gn.gen_title = 'Mystery'
GROUP BY
	mv.mov_year, GN.gen_title

--24. write a query in SQL to generate a report, which contain the fields movie title, 
--name of the female actor, year of the movie, role, movie genres, the director, date of release, and rating of that movie. 
SELECT
	mv.mov_title, ac.act_fname, ac.act_lname, mv.mov_year, mc.role, gn.gen_title, dr.dir_fname, dr.dir_lname, mv.mov_dt_rel, rt.rev_stars
FROM
	movie mv
INNER JOIN
	movie_cast mc
ON
	mv.mov_id = mc.mov_id
INNER JOIN
	actor ac
ON
	mc.act_id = ac.act_id
INNER JOIN
	movie_direction md
ON
	mv.mov_id = md.mov_id
INNER JOIN
	director dr
ON
	md.dir_id = dr.dir_id
INNER JOIN
	rating rt
ON
	mv.mov_id = rt.mov_id
INNER JOIN
	movie_genres mg
ON
	mv.mov_id = mg.mov_id
INNER JOIN
	genres gn
ON
	mg.gen_id = gn.gen_id
WHERE
	ac.act_gender = 'F'
