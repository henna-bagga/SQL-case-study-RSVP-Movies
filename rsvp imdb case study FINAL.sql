USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- A. Calculating no. of rows of director_mapping table
SELECT COUNT(*)
FROM   director_mapping; 
-- No. of rows in director_mapping table: 3867

-- B. Calculating no. of rows of genre table 
SELECT COUNT(*)
FROM   genre; 
-- No. of rows in genre table: 14662

-- C. Calculating no. of rows of movie table
SELECT COUNT(*)
FROM   movie; 
-- No. of rows in movie table: 7997

-- D. Calculating no. of rows of names table
SELECT COUNT(*)
FROM   names; 
-- No. of rows in names table: 25735

-- E. Calculating no. of rows of ratings table
SELECT COUNT(*)
FROM   ratings; 
-- No. of rows in ratings table: 7997

-- F. Calculating no. of rows of role_mapping table
SELECT COUNT(*)
FROM   role_mapping; 
-- No. of rows in role_mapping table: 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- checking movie table columns with null values and their counts.

SELECT SUM(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_ID,
       SUM(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_title,
       SUM(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_year,
       SUM(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_date_published,
       SUM(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_duration,
       SUM(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_country,
       SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_worlwide_gross_income,
       SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_languages,
       SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_production_company
FROM   movie; 
	
/* following columns of movie table have null values and their respective counts
1. null_count_country = 20
2. null_count_worlwide_gross_income= 3724
3. null_count_languages = 194
4. null_count_production_company= 528
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To find total no. of movies released each year

SELECT Year,
       COUNT(Title) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

/*
In 2017, 3052 movies were released
In 2018, 2944 movies were released
In 2019, 2001 movies were released

2017 has the highest no. of movies released 
*/

-- Month wise trend

SELECT MONTH(date_published) AS month_num,
       COUNT(title)          AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;  

/* 
1. December month has least no. of movies released
2. March month has highest no. of movies released.
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT year,
       COUNT(DISTINCT id) AS total_movies_count
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
       
-- No. of Movies produced by India or USA in year 2019 are 1059


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 

-- There are 13 unique genres in this dataset


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT g.genre,
       COUNT(m.id) AS movies_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY movies_count DESC
LIMIT  1; 


-- Drama genre has the highest no.(4285) of movies produced

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH count_of_genres
     AS (SELECT m.id,
                COUNT(g.genre) AS genre_count
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         GROUP  BY id)
SELECT COUNT(id) AS movie_count
FROM   count_of_genres
WHERE  genre_count = 1; 


-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       ROUND(Avg(m.duration), 2) AS avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre
ORDER  BY avg_duration DESC; 


-- Action genre has the highest average duration


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_details
     AS (SELECT g.genre,
                COUNT(DISTINCT m.id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY COUNT(DISTINCT m.id) DESC) AS genre_rank
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         GROUP  BY genre)
SELECT genre,
       movie_count,
       genre_rank
FROM   genre_rank_details
WHERE  genre = 'Thriller'; 

-- Thriller is at rank 3 in terms of number of movies produced

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below

SELECT ROUND(MIN(avg_rating)) AS min_avg_rating,
       ROUND(MAX(avg_rating)) AS max_avg_rating,
       MIN(total_votes)       AS min_total_votes,
       MAX(total_votes)       AS max_total_votes,
       MIN(median_rating)     AS min_median_rating,
       MAX(median_rating)     AS max_median_rating
FROM   ratings; 

/*
minimum avg_rating : 1
maximum avg_rating : 10
minimum total_votes : 100
maximum total_votes : 725138
minimum median_rating: 1
maximum median_rating: 10
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT     m.title,
           r.avg_rating,
           DENSE_RANK() OVER( ORDER BY r.avg_rating DESC) AS movie_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
GROUP BY   m.title,
           r.avg_rating LIMIT 10;


-- It can be seen that kirket, love in kilnerry has highest rating 10.0


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- It can be seen that median rating 7 has highest movie count


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH rank_details AS
(
           SELECT     m.production_company,
                      COUNT(r.movie_id)                                   AS movie_count,
                      DENSE_RANK() OVER( ORDER BY COUNT(r.movie_id) DESC) AS prod_company_rank
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           WHERE      r.avg_rating > 8
           AND        m.production_company IS NOT NULL
           GROUP BY   m.production_company)
SELECT production_company,
       movie_count,
       prod_company_rank
FROM   rank_details
WHERE  prod_company_rank = 1;

-- Both Dream Warrior Pictures, National Theatre Live both have produced highest no. of hit movies i.e. 3


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       COUNT(m.id) AS movie_count
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.year = '2017'
       AND MONTH(m.date_published) = 3
       AND m.country LIKE '%USA%'
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

-- drama genre had maximum movie count for movies produced in USA in march 2017 with greater than 1000 votes

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:	

SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'the%'
       AND r.avg_rating > 8
ORDER  BY r.avg_rating DESC ; 


-- The Brighton Miracle of drama genre has highest avg_rating among movie starting with 'The'. 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT r.median_rating,
       COUNT(r.movie_id) AS total_movie_count
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  r.median_rating = 8
       AND m.date_published BETWEEN '2018-04-1' AND '2019-04-01'
GROUP  BY r.median_rating; 

-- hence 361 movies had median rating 8 which were published between '2018-04-1' and '2019-04-01' 


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_movie_details
     AS (SELECT SUM(r.total_votes) AS german_movies_votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.languages LIKE '%german%'),
     italian_movie_details
     AS (SELECT SUM(r.total_votes) AS italian_movies_votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.languages LIKE '%Italian%')
SELECT german_movies_votes,
       italian_movies_votes,
       CASE
         WHEN german_movies_votes > italian_movies_votes THEN 'Yes'
         ELSE 'No'
       END AS test_votes
FROM   german_movie_details,
       italian_movie_details;  
/*
total votes for german language movies is 44,21,525 and total votes for italian language movies is 25,59,540. 
Hence yes the German movies get more votes than Italian movies.
*/


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
       SUM(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movie_nulls
FROM   names; 
        
/*
the columns of name table containing null values and their respective null_count are as follows: 
height_nulls: 17335
date_of_birth_nulls:    13431
known_for_movie_nulls:  15226
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS
(
           SELECT     g.genre,
                      COUNT(g.movie_id),
                      RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id=m.id
           INNER JOIN ratings r
           ON         r.movie_id=m.id
           WHERE      r.avg_rating>8
           GROUP BY   g.genre lIMIT 3 )
SELECT     n.name as director_name,
           COUNT(d.movie_id) AS movie_count
FROM       names n
INNER JOIN director_mapping d
ON         n.id=d.name_id
INNER JOIN movie m
ON         m.id=d.movie_id
INNER JOIN ratings r
ON         r.movie_id=m.id
INNER JOIN genre g
ON         m.id=g.movie_id
WHERE      avg_rating>8
AND        g.genre IN
           (
                  SELECT genre
                  FROM   top_3_genre )
GROUP BY   n.NAME
ORDER BY   movie_count DESC,
           n.NAME LIMIT 3;
		

/*
top 3 directors with respective movie counts in the top three genres whose movies have an average rating > 8 are:
James Mangold:	4
Anthony Russo:	3
Joe Russo:		3
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name              AS actor_name,
       COUNT(rol.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rol
               ON n.id = rol.name_id
       INNER JOIN movie m
               ON rol.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  r.median_rating >= 8
GROUP  BY n.name
ORDER  BY COUNT(rol.movie_id) DESC
LIMIT  2; 

/*
top two actors with their respective movie_counts whose movies have a median rating >= 8 are:-
Mammootty:	8
Mohanlal:	5
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           SUM(r.total_votes)                                  AS vote_count,
           DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
GROUP BY   m.production_company LIMIT 3;

/*
top three production houses with respective total votes and ranks are as follows:
Marvel Studios: 		26,56,967			1
Twentieth Century Fox: 	24,11,163			2
Warner Bros.: 			23,96,057			3
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.NAME
       AS
       actor_name,
       SUM(r.total_votes)
       AS total_votes,
       COUNT(r.movie_id)
       AS movie_count,
       ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)
       AS
       actor_avg_rating,
       DENSE_RANK()
         OVER(
           ORDER BY SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes) DESC)
       AS
       actor_rank
FROM   names n
       INNER JOIN role_mapping rol
               ON n.id = rol.name_id
       INNER JOIN movie m
               ON rol.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.country LIKE '%India%'
       AND rol.category = 'Actor'
GROUP  BY actor_name
HAVING COUNT(DISTINCT r.movie_id) >= 5; 

-- vijay sethupati is the top actor in India based on average ratings.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT     n.NAME                                                           AS actress_name,
           SUM(r.total_votes)                                               AS total_votes,
           COUNT(r.movie_id)                                                AS movie_count,
           ROUND(SUM(r.avg_rating                       * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
           DENSE_RANK() OVER( ORDER BY SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes) DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rol
ON         n.id = rol.name_id
INNER JOIN movie m
ON         rol.movie_id = m.id
INNER JOIN ratings r
ON         r.movie_id = m.id
WHERE      m.country LIKE '%India%'
AND        m.languages LIKE '%Hindi%'
AND        rol.category = 'Actress'
GROUP BY   actress_name
HAVING     COUNT(DISTINCT r.movie_id) >= 3 LIMIT 5;

/*
Following are the top 5 actresses in Hindi movies released in India based on average ratings
Taapsee Pannu:		7.74
Kriti Sanon:		7.05
Divya Dutta:		6.88
Shraddha Kapoor:	6.63
Kriti Kharbanda:	4.80
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit movies'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS category_avg_ratings
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  genre = 'Thriller'; 

-- Der mude Tod movie which is highest avg_rating thriller movie falls under hit movies category

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT g.genre,
       ROUND(AVG(m.duration), 0)                       AS avg_duration,
       SUM(ROUND(AVG(m.duration), 2))
         OVER (
           ORDER BY g.genre ROWS UNBOUNDED PRECEDING ) AS running_total_duration
       ,
       AVG(ROUND(AVG(m.duration), 2))
         OVER (
           ORDER BY g.genre ROWS UNBOUNDED PRECEDING )  AS moving_avg_duration
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY g.genre; 


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/*
- Upon inspection of the column "worlwide_gross_income" from "movie" table, we noticed that the gross income is in both INR and USD. 
- For standardization we converted all worldwide_gross_income enteries to USD assuming conversation rate to be 1 USD=70INR(average 
	value of 1 USD to INR conversion from 2017 to 2019)
*/

-- Top 3 Genres based on most number of movies
WITH top_3_genre AS
(
           SELECT     g.genre,
                      COUNT(g.movie_id)                            AS movie_count,
                      RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id=m.id
           GROUP BY   g.genre
           ORDER BY   movie_count DESC limit 3 ), worldwide_gross_income_converted AS
(
           SELECT     g.genre ,
                      m.year,
                      m.title,
                      CASE
                                 WHEN m.worlwide_gross_income LIKE '%INR%' THEN (1/70) * CAST(REPLACE(m.worlwide_gross_income, 'INR', '') AS DECIMAL)
                                 WHEN m.worlwide_gross_income LIKE '%$%' THEN CAST(REPLACE(m.worlwide_gross_income, '$', '') AS              DECIMAL)
                      END AS worldwide_gross_income
           FROM       movie m
           INNER JOIN genre g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_genre) ), final_output AS
(
         SELECT   genre,
                  year,
                  title                                                                     AS movie_name,
                  ROUND(worldwide_gross_income,0)                                           AS rounded_worldwide_gross_income ,
                  DENSE_RANK() OVER(PARTITION BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
         FROM     worldwide_gross_income_converted
         ORDER BY year )
SELECT genre,
       year,
       movie_name,
              CONCAT('$',rounded_worldwide_gross_income) AS worldwide_gross_income,
       movie_rank
FROM   final_output
WHERE  movie_rank <= 5;

/* 
in 2017, The Fate of the Furious movie was highest-grossing movie belonging to top 3 genres 
in 2018, Bohemian Rhapsody movie was highest-grossing movie belonging to top 3 genres 
in 2019, Avengers: Endgame movie was highest-grossing movie belonging to top 3 genres
*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     m.production_company,
           COUNT(id)                                  AS movie_count,
           DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      r.median_rating>=8
AND        m.production_company IS NOT NULL
AND        POSITION(',' IN languages)>0
GROUP BY   m.production_company lIMIT 2;

-- hence Star Cinema, Twentieth Century Fox are top 2 production houses (based on median ratings) that have produced the highest number of hits among multilingual movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     n.NAME                                                                AS actress_name,
           SUM(rat.total_votes)                                                  AS total_votes,
           COUNT(r.movie_id)                                                     AS movie_count,
           ROUND(SUM(rat.avg_rating* rat.total_votes) / SUM(rat.total_votes), 2) AS actress_avg_rating,
           DENSE_RANK() OVER(ORDER BY COUNT(r.movie_id) DESC)                    AS actress_rank
FROM       names n
INNER JOIN role_mapping r
ON         n.id= r.name_id
INNER JOIN movie m
ON         r.movie_id=m.id
INNER JOIN ratings rat
ON         m.id=rat.movie_id
INNER JOIN genre g
ON         rat.movie_id=g.movie_id
WHERE      r.category='Actress'
AND        rat.avg_rating>8
AND        g.genre='drama'
GROUP BY   n.name LIMIT 3;
/*
top 3 actress actresses based on number of Super Hit movies in drama genre are:
- Parvathy Thiruvothu
- Susan Brown
- Amanda Lawrence
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH date_director_ratings_details AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      LEAD(date_published, 1) OVER (PARTITION BY d.name_id ORDER BY date_published, movie_id) AS next_date
           FROM       director_mapping                                                                        AS d
           INNER JOIN names                                                                                   AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), date_diff_details AS
(
       SELECT *,
              DATEDIFF(next_date, date_published) AS date_difference
       FROM   date_director_ratings_details )
SELECT   name_id                        AS director_id,
         NAME                           AS director_name,
         COUNT(movie_id)                AS number_of_movies,
         ROUND(AVG(date_difference), 2) AS avg_inter_movie_days,
         ROUND(AVG(avg_rating), 2)      AS avg_rating,
         SUM(total_votes)               AS total_votes,
         MIN(avg_rating)                AS min_rating,
         MAX(avg_rating)                AS max_rating,
         SUM(duration)                  AS total_duration
FROM     date_diff_details
GROUP BY director_id
ORDER BY number_of_movies DESC LIMIT 9;
    
    
    
 
    
           






