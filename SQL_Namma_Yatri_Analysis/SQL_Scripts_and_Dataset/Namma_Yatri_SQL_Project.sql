-- getting total no.of the tables

select count(*) as number_of_successful_trips from trips;
select count(*) as total_number_of_trips from trips_details;

-- checking for any duplicate values

select tripid,count(tripid) from trips_details
group by tripid 
having count(tripid)>1;

-- total drivers
select count(distinct driverid) as Total_drivers from trips;

-- total earnings
select sum(fare) as Total_earnings from trips;

-- total completed trips
select count(distinct tripid) as `total completed trips` from trips;

-- total searches
select sum(searches) as `total searches` from trips_details;

-- total searches which got estimates
select sum(searches_got_estimate) as `total searches` from trips_details;

-- total searches_for_quotes
select sum(searches_for_quotes) as `total searches_for_quotes` from trips_details;

-- total searches_got_quotes
select sum(searches_got_quotes) as `total searches_got_quotes` from trips_details;

-- total rides cancelled by drivers
select count(*) - sum(driver_not_cancelled) as `rides cancelled by drivers` from trips_details;

-- total otp_entered
select sum(otp_entered) as `total otp entered` from trips_details;

-- total rided ended 
select sum(end_ride) as `total end_ride` from trips_details;

-- average fare
select round(avg(fare),0) as average_fare from trips;

-- average distance
select round(avg(distance),0) as average_distance from trips;

-- most used payment methods
SELECT method
FROM payment
JOIN (
    SELECT faremethod
    FROM trips
    GROUP BY faremethod
    ORDER BY COUNT(DISTINCT tripid) DESC
    LIMIT 1
) AS fare_methods
ON payment.id = fare_methods.faremethod;

-- highest payment made thorugh which mode
select method as `method used for the highest fare trip` from payment
join (
select faremethod from trips
group by faremethod
order by max(fare) desc 
limit 1) as max_faremethod
on payment.id = max_faremethod.faremethod;

-- payment method wise sum of fare 

SELECT  SUM(fare) AS total_fare,
       (SELECT method FROM payment WHERE trips.faremethod = payment.id LIMIT 1) AS payment_method
FROM trips
LEFT JOIN payment ON trips.faremethod = payment.id
GROUP BY trips.faremethod
ORDER BY total_fare DESC;

-- two location with most trips are from 
select loc_from,loc_to , count(distinct tripid) as trip from trips
group by loc_from,loc_to
order by count(distinct tripid) desc
limit 2;

-- top 5 earning drivers

select dense_rank() over(order by sum(fare) desc) as `rank` ,driverid,sum(fare) as `fare collected` from trips
group by driverid
order by sum(fare) desc
limit 5 ;

-- identifying two peak hours
select trips.duration as durationid,duration.duration,count(tripid) as `no of trips` from trips
inner join duration on trips.duration = duration.id
group by durationid,duration.duration 
order by count(tripid) desc
limit 2;

-- which driver customer pair had more orders
select driverid,custid ,count(tripid) as `no of trips` from trips
group by driverid,custid
order by count(tripid) desc
limit 2 ;

-- search to estimate ratio
select concat(round(sum(searches_got_estimate)/sum(searches) *100,2),'%') as ` search to estimate ratio`
from trips_details;

-- which area got highest trips in which duration
select loc.assembly1 as locality, duration.duration , no_of_trips from (
select loc_from,duration , count(tripid) as no_of_trips from trips
group by loc_from,duration) as most
join loc on most.loc_from = loc.id
join duration on most.duration = duration.id
order by most.no_of_trips desc
limit 1;

-- top 3 locality which has highest earnings
select loc.assembly1 as locality,sum(trips.fare) as total_fare from trips 
join loc on trips.tripid = loc.id
group by loc.assembly1
order by sum(trips.fare) desc
limit 3;

-- top 5 duration by earnings
select duration.duration,count(trips.tripid) as `no. of trips`,sum(trips.fare) as total_fare from trips
join duration on trips.duration = duration.id
group by duration.duration
order by count(trips.tripid) desc
limit 5


