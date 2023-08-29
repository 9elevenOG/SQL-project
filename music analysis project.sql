--Who is the senior most employee based on job title?

select * from employee$
order by levels DESC

--Which countries have the most invoices?

select COUNT (*) as C, billing_country
from invoice$
group by billing_country
order by C DESC

--What are top 3 values of total invoice

select top 3 total from invoice$
order by total DESC

--Which city has the best customers? we would like to throw a promotiona music festival in the city we made the most money. 
--write a query that returns one city that has the highest sum of invoice totals. Return both city name & sum of all invoice totals

select * from invoice$

select SUM(total) as invoice_total, billing_city
from invoice$
group by billing_city
order by invoice_total DESC

--Who is the best customer? 

select * from customer$

select  top 3 customer$.customer_id, customer$.first_name,customer$.last_name, customer$.address, SUM(invoice$.total) as total
from customer$ 
JOIN invoice$ ON customer$.customer_id = invoice$.customer_id
group by customer$.customer_id, customer$.first_name,customer$.last_name, customer$.address
order by total DESC

--Provide the email, first name, lastname and genre of all rock music listeners. order alphabetically by email

select DISTINCT email, first_name, last_name
from customer$
JOIN invoice$ on customer$.customer_id = invoice$.customer_id
JOIN invoice_line$ on invoice$.invoice_id = invoice_line$.invoice_id
where track_id in(
	select track_id from track$
	JOIN genre$ on track$.genre_id = genre$.genre_id
	where genre$.name like 'Rock'
)

order by email

--extend invitation to artist who have written the most metal music in the dataset.
--return the artist name and total track count of the top metal band/ artists

select top 10 artist$.artist_id, artist$.name, COUNT(artist$.artist_id) as no_of_songs
from track$
JOIN album$ on album$.album_id = track$.album_id
JOIN artist$ on artist$.artist_id = album$.artist_id
JOIN genre$ on genre$.genre_id = track$.genre_id
where genre$.name like 'Metal'
group by artist$.artist_id, artist$.name
order by no_of_songs DESC

--Return all the track names that have a song lenght longer than the average song lenght.
--return the name and milliseconds for each track, order by the longest songs

select name, milliseconds
from track$
where milliseconds > (
	select AVG(milliseconds) as avg_track_lenght
	from track$)
order by milliseconds DESC

--Find out how much amount spent by each customer on artsists
--return customer name, artsit name and total spent

WITH best_selling_artist AS (
    SELECT TOP 1
        artist$.artist_id AS artist_id,
        artist$.name AS artist_name,
        SUM(invoice_line$.unit_price * invoice_line$.quantity) AS total_sales
    FROM invoice_line$
    JOIN track$ ON track$.track_id = invoice_line$.track_id
    JOIN album$ ON album$.album_id = track$.album_id
    JOIN artist$ ON artist$.artist_id = album$.artist_id
    GROUP BY artist$.artist_id, artist$.name
    ORDER BY total_sales DESC
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    bsa.artist_name,
    SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice$ i
JOIN customer$ c ON c.customer_id = i.customer_id
JOIN invoice_line$ il ON il.invoice_id = i.invoice_id
JOIN track$ t ON t.track_id = il.track_id
JOIN album$ alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    bsa.artist_name
ORDER BY amount_spent DESC;


--find out the most popular genre of music for each country. return each country along wiyth its top genre.
--if maximum number of purchases is shared return all.

WITH popular_genre_counts AS (
    SELECT
        COUNT(invoice_line$.quantity) AS purchases,
        customer$.country,
        genre$.name,
        genre$.genre_id,
        ROW_NUMBER() OVER(PARTITION BY customer$.country ORDER BY COUNT(invoice_line$.quantity) DESC) AS row_no
    FROM invoice_line$
    JOIN invoice$ ON invoice$.invoice_id = invoice_line$.invoice_id
    JOIN customer$ ON customer$.customer_id = invoice$.customer_id
    JOIN track$ ON track$.track_id = invoice_line$.track_id
    JOIN genre$ ON genre$.genre_id = track$.genre_id
    GROUP BY customer$.country, genre$.name, genre$.genre_id
)
SELECT
    purchases,
    country,
    name,
    genre_id
FROM (
    SELECT
        purchases,
        country,
        name,
        genre_id,
        row_no,
        ROW_NUMBER() OVER(PARTITION BY country ORDER BY purchases DESC) AS ordered_row_no
    FROM popular_genre_counts
) ranked_genre
WHERE ordered_row_no = 1
ORDER BY country ASC;
 

--Which of the customer that has spent the most on music for each country
--return the country along with the top consumer and how much thry spent, provide all customers who spent this amount

WITH customer_with_country AS (
    SELECT
        customer$.customer_id,
        first_name,
        last_name,
        billing_country,
        SUM(total) AS total_spending
    FROM invoice$
    JOIN customer$ ON customer$.customer_id = invoice$.customer_id
    GROUP BY 
        customer$.customer_id,
        first_name,
        last_name,
        billing_country
),
ranked_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        billing_country,
        total_spending,
        ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY total_spending DESC) AS row_no
    FROM customer_with_country
)
SELECT
    customer_id,
    first_name,
    last_name,
    billing_country,
    total_spending
FROM ranked_customers
WHERE row_no = 1;



	













--