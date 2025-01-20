

		-- SQL - REINFORCEMENT ANSWERS --


/* 1) FIND THE TOTAL NO OF ROWS IN EACH TABLE OF THE SCHEMA */

use imdb;

select 'Director_mapping' AS 'Table', count(*) AS TOTALROWS from Director_mapping
union all
select 'Genre' AS 'Table', count(*) AS TOTALROWS from Genre
union all
select 'Movie' AS 'Table', count(*) AS TOTALROWS from Movie
union all
select 'Names' AS 'Table', count(*) AS TOTALROWS from Names
union all
select 'Ratings' AS 'Table', count(*) AS TOTALROWS from Ratings
union all
select 'Role_mapping' AS 'Table', count(*) AS TOTALROWS from Role_mapping
order by totalrows desc;


/* 2) 	WHICH COLUMNS IN THE MOVIE TABLE HAVE NULL VALUES */

SELECT 'COUNTRY' AS column_name, count(*) AS null_count from movie WHERE country IS NULL
UNION ALL
SELECT 'DATE_PUBLISHED' AS column_name, count(*) AS null_count from movie WHERE date_published IS NULL
UNION ALL
SELECT 'DURATION' AS column_name, count(*) AS null_count from movie WHERE duration IS NULL
UNION ALL
SELECT 'ID' AS column_name, count(*) AS null_count from movie WHERE id IS NULL
UNION ALL
SELECT 'LANGUAGES' AS column_name, count(*) AS null_count from movie WHERE languages IS NULL
UNION ALL
SELECT 'PRODUCTION_COMPANY' AS column_name, count(*) AS null_count from movie WHERE production_company IS NULL
UNION ALL
SELECT 'TITLE' AS column_name, count(*) AS null_count from movie WHERE title IS NULL
UNION ALL
SELECT 'WORLDWIDE_GROSS_INCOME' AS column_name, count(*) AS null_count from movie WHERE worlwide_gross_income IS NULL
UNION ALL
SELECT 'YEAR' AS column_name, count(*) AS null_count from movie WHERE year IS NULL;


/* 3.Find the total number of movies released each year. 
     How does the trend look month-wise */


select YEAR, count(*) AS Total_Movies from  movie
group by year;

select month(date_published) as 'Month',count(*) as Total_Movies
from movie
group by month
order by month;


/* 4. How many movies were produced in the USA or India in the year 2019 */

select year, country, count(*) AS Total_movies 
from movie
where (country = 'USA' or country = 'INDIA')
AND YEAR = 2019
group by year, country;


/* 5.	Find the unique list of genres present in the dataset and 
        how many movies belong to only one genre. */

select distinct genre from genre;


Select Count(movie_id) As Single_genre_movies
From (
    Select movie_id, Count(genre) As number_of_movies
    From genre
    Group by movie_id
    Having Count(genre) = 1
) As subquery;


/*6. Which genre had the highest number of movies produced overall */

select genre, count(*) AS No_of_Movies
  from genre
  group by genre
  order by No_of_Movies desc
  limit 1;
  
  
/* 7.	What is the	 average duration of movies in each genre */
  
  select g.genre, ROUND(avg(m.duration), 2) AS Avg_duration
      from genre g join movie m on g.movie_id = m.id
      group by g.genre
      order by avg_duration desc;
      
      
/* 8.  Identify actors or actresses who have worked in more than three movies 
		with an average rating below 5 */

select n.name, count(*) AS low_rated_movies
       from names n join role_mapping rm on
       n.id = rm.name_id join ratings r on
       rm.movie_id = r.movie_id
       where r.avg_rating < 5
       group by n.id
       having count(rm.movie_id) > 3
       order by low_rated_movies desc;
       
       
/* 9.	Find the minimum and maximum values in each column of the ratings table except the movie_id column. */

select min(avg_rating) AS min_rating, max(avg_rating) AS max_rating, 
	   min(total_votes) AS min_votes, max(total_votes) AS max_votes, 
       min(median_rating) AS min_median_rating, max(median_rating) AS max_median_rating
from ratings;


/* 10   Which are the top 10 movies based on average rating */

select m.title, r.avg_rating 
	from movie m join ratings r on
    m.id = r.movie_id
    order by r.avg_rating desc
	limit 10;
    

/*  11.	Summarise the ratings table based on the movie counts by median ratings */

select median_rating, count(*) AS moviecounts
from ratings
group by median_rating
order by median_rating;


/* 12.	How many movies released in each genre during March 2017 
							in the USA had more than 1,000 votes */

select g.genre, count(*) AS Totalmovie
from genre g JOIN movie m ON 
g.movie_id = m.id JOIN ratings r ON 
g.movie_id = r.movie_id
where year = "2017" and month(date_published)=3 and country = "usa" and r.total_votes>1000
group by g.genre
order by totalmovie desc;


/* 13.	Find movies of each genre that start with the word ‘The’ 
                           and which have an average rating > 8  */

select g.genre, m.title, r.avg_rating 
	from movie m JOIN genre g ON 
    m.id = g.movie_id JOIN ratings r ON 
    g.movie_id = r.movie_id
    where (m.title like 'THE %') and r.avg_rating > 8
    order by g.genre;
    
    
/* 14.	Of the movies released between 1 April 2018 and 1 April 2019, 
							how many were given a median rating of 8 */


Select Count(*) as totalmovies
	FROM movie m JOIN ratings r 
    ON m.id = r.movie_id
    WHERE date_published BETWEEN "2018-04-01" AND "2019-04-01" AND r.median_rating = 8;



 /* 15. Do German movies get more votes than Italian movies? */ 
   
Select m.country, sum(r.total_votes) as total_votes 
	from movie m join ratings r on
    m.id = r.movie_id
    where m.country in ("Germany","Italy")
    group by m.country
    order by m.country;


/* 16. Which columns in the names table have null values */ 

SELECT  'Id' AS column_name, COUNT(*) AS null_count FROM names WHERE id IS NULL
UNION ALL
SELECT  'Name' AS column_name, COUNT(*) AS null_count FROM names WHERE Name IS NULL
UNION ALL
SELECT  'Height' AS column_name, COUNT(*) AS null_count FROM names WHERE height IS NULL
UNION ALL
SELECT  'Date_of_birth' AS column_name, COUNT(*) AS null_count FROM names WHERE date_of_birth IS NULL
UNION ALL
SELECT  'Known_for_movies' AS column_name, COUNT(*) AS null_count FROM names WHERE known_for_movies IS NULL;   


/* 17. Who are the top two actors whose movies have a median rating >= 8? */
  
SELECT n.name, count(*) AS Rating
FROM names n JOIN role_mapping rm ON 
n.id = rm.name_id JOIN ratings r ON 
rm.movie_id = r.movie_id
WHERE rm.category = 'actor' AND r.median_rating >= 8
GROUP BY n.name
ORDER BY Rating DESC
LIMIT 2;


/* 18. Which are the top three production houses based on the number of votes received by their movies? */

select m.production_company, sum(r.total_votes) as totalvotes 
	from movie m join ratings r on
    m.id = r.movie_id 
    group by m.production_company
    order by totalvotes desc
    limit 3;
    

/* 19. How many directors worked on more than three movies? */    

Select n.name, count(*) as total_movies
	from names n join director_mapping dm on
    n.id = dm.name_id 
    group by n.name
    having count(dm.movie_id) > 3
    order by total_movies desc;
    
    
/* 20.	Find the average height of actors and actresses separately. */

Select rm.category, round(avg(n.height), 2) as Avg_height
   from role_mapping rm join names n on
   rm.name_id = n.id 
   group by rm.category
   order by Avg_height desc;
   
   
/* 21.	Identify the 10 oldest movies in the dataset along with its title, country, and director */


select m.title,m.country,n.name AS Director_name, m.date_published
   from movie m JOIN director_mapping dm ON
   m.id = dm.movie_id JOIN names n ON
   dm.name_id=n.id
   order by m.date_published, m.country
   LIMIT 10;
   
   
-- 22.	List the top 5 movies with the highest total votes and their genres
   
   SELECT m.title,g.genre,r.total_votes
       FROM movie m JOIN genre g ON m.id = g.movie_id
					JOIN ratings r ON g.movie_id = r.movie_id
		order by g.genre, r.total_votes desc
        limit 5;
        
        
-- 23.	Find the movie with the longest duration, along with its genre and production company
        
       SELECT m.title, m.duration, g.genre, m.production_company
              FROM movie m JOIN genre g ON m.id = g.movie_id
              order by duration desc
              Limit 1;
              
              
-- 24.	Determine the total votes received for each movie released in 2018.
       
       SELECT m.title, r.total_votes
            FROM movie m JOIN ratings r ON
            m.id = r.movie_id
            where year(m.date_published) = "2018"
            ORDER BY r.total_votes desc;
            
            
-- 25.	Find the most common language in which movies were produced
       
         SELECT languages, count(*) AS Total_Movies
             FROM movie 
             GROUP BY languages
             ORDER BY Total_Movies DESC
             LIMIT 1;
             
    
        
 