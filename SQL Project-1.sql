Q:
select * from employee
order by levels desc
limit 1

Q:
select Count(*) as MOST_INc, billing_Country
from invoice
group by billing_country
order by MOST_INc 


Q:
Select total from Invoice
order by total desc
limit 5



Q;
Select Sum(total) as invoice_total, billing_city
from Invoice
group by billing_city
order by invoice_total desc



Q:
Select customer.customer_id, customer.first_name, customer.last_name, Sum(invoice.total) as total
from customer
Join invoice on customer.customer_id = invoice.customer_id
Group by customer.customer_id
order by total desc
limit 3 



Q:
select distinct email, first_name, last_name, 
from customer
Join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice.invoice_id
where track_id in(select track_id from track
           join genre on track.genre_id = genre.genre_id
           where genre.name like 'Pop'
)
order by email;



Q:
select artist.artist_id, artist.name, count(artist.artist_id) as Number_of_songs
from track
Join album on album.album_id = track.album_id
Join artist on artist.artist_id = album.artist_id
Join genre on genre.genre_id = track.genre_id
where genre.name like 'Pop'
Group by artist.artist_id
Order by number_of_songs Desc
LIMIT 10;


Q:
Select name, milliseconds
from Track
where milliseconds > (Select Avg(milliseconds) as avg_track_lenth
					 from track )
Order by milliseconds Desc;




Q:
with Best_selling_artist As( 
	           Select artist.artist_id as artist_id, artist.name as artist_name,
	Sum(invoice_line.unit_price*invoice_line.quantity) As Total_sales
	From invoice_line
	Join track on track.track_id = invoice_line.track_id
	Join album on album.artist_id = track.album_id
	Join artist on artist.artist_id = album.artist_id
	Group By 1
	Order by 3 Desc
	Limit 1
	)
Select c.customer_id, c.first_name, c.last_name, bsa.artist_name, Sum(il.unit_price*il.quantity) As amount_spent
from invoice i
Join customer c On c.customer_id = i.customer_id
Join invoice_line il on il.invoice_id = i.invoice_id
Join track t on t.track_id = il.track_id
Join album alb on alb.album_id = t.album_id
Join best_selling_Artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
Order by 5 desc;


Q:
with popular_genre As
( Select Count(invoice_line.quantity) As purchases, customer.country, genre.name, genre.genre_id,
 Row_number() over(partition by customer.country Order by count(invoice_line.quantity)DESC) as Row_no
 from invoice_line
 Join invoice on invoice.invoice_id = invoice_line.invoice_id
 Join customer on customer.customer_id = invoice.customer_id
 Join track on track.track_id = invoice_line.invoice_id
 Join genre on genre.genre_id = track.genre_id
 Group by 2,3,4
 order by 2 Asc, 1 Desc
)

Select * from Popular_genre where Row_no<=1;




Q:
with customer_with_country as 
(    Select customer.customer_id, first_name, last_name, billing_country, Sum(total) AS Total_spending,
     Row_Number() Over(partition by billing_country order By sum(total) Desc) As Row_NO
     From Invoice
Join customer on customer.customer_id = invoice.customer_id
 Group by 1,2,3,4
 Order by 4 ASC, 5 Desc
)
Select * from Customer_with_country Where Row_No<=1
