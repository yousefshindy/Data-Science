-- Part A: SQL


--A)
SELECT 

COUNT(DISTINCT TAIL_NUMBER) AS Distinct_Aircrafts ,
COUNT(*) AS Total_num_of_flights,
MIN(DEPARTURE_DELAY) AS Minimum_Departure_Delay, 
MAX(DEPARTURE_DELAY) AS Maximum_Departure_Delay, 
AVG(DEPARTURE_DELAY) AS Average_Departure_Delay 

FROM FLIGHTS


----------------------------------------------------------------------------------------------------------------------------------------------------


--B)
CREATE VIEW FlightSummaryView AS
SELECT CONCAT(f.YEAR, '-', f.MONTH, '-', f.DAY) AS Date,
a.IATA_CODE AS Iata_Code,
f.ORIGIN_AIRPORT,
CONCAT(a.CITY ,' ', a.STATE ,' ', a.COUNTRY) AS Address,
COUNT(*) AS Total_number_Of_Flights

FROM FLIGHTS f JOIN AIRPORTS a
ON f.ORIGIN_AIRPORT = a.iata_code
WHERE f.MONTH = 1 AND f.DAY BETWEEN 1 AND 7
GROUP BY  a.IATA_CODE, f.ORIGIN_AIRPORT, a.city, a.state, a.country, f.YEAR, f.MONTH, f.DAY;

SELECT * FROM FlightSummaryView
ORDER BY Iata_Code DESC,Date;


----------------------------------------------------------------------------------------------------------------------------------------------------

--C)
SELECT ORIGIN_AIRPORT, DESTINATION_AIRPORT, rank
FROM (
    SELECT ORIGIN_AIRPORT, DESTINATION_AIRPORT, 
           RANK() OVER (PARTITION BY ORIGIN_AIRPORT ORDER BY count(*) DESC) AS rank
    FROM FLIGHTS
    GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
) AS ranked_routes
WHERE rank <= 3
order by ORIGIN_AIRPORT , rank desc

----------------------------------------------------------------------------------------------------------------------------------------------------

--D)
select a.IATA_CODE , a.AIRPORT , l.IATA_CODE , l.AIRLINE , f.FLIGHT_NUMBER , f.TAIL_NUMBER , f.ORIGIN_AIRPORT , f.DESTINATION_AIRPORT , f.DEPARTURE_TIME , f.ARRIVAL_TIME
from FLIGHTS f 
join AIRPORTS a 
on f.ORIGIN_AIRPORT = a.IATA_CODE
join airlines l 
on f.AIRLINE = l.IATA_CODE 
where ((f.DAY_OF_WEEK = 6) or (f.DAY_OF_WEEK = 7)) and (f.ARRIVAL_TIME between 0400 and 0500)

----------------------------------------------------------------------------------------------------------------------------------------------------

--E)
with total_flights as (
    select COUNT(FLIGHT_NUMBER) as total_count
    from FLIGHTS
),
JFK_total_flights as (
	select count(FLIGHT_NUMBER) as JFK_total_count
	from FLIGHTS 
	where ORIGIN_AIRPORT = 'JFK'
	),
NY_total_flights as (
	select count(FLIGHT_NUMBER) as NY_total_count
	from FLIGHTS
	WHERE ORIGIN_AIRPORT in ('JFK','LGA','EWR')
)
	select t.total_count , f.JFK_total_count, (cast (f.JFK_total_count as decimal) / (t.total_count)) * 100 AS JFK_over_total, (cast (f.JFK_total_count as decimal) / (n.NY_total_count)) * 100 AS JFK_over_NY
	from total_flights t , JFK_total_flights f, NY_total_flights n 

----------------------------------------------------------------------------------------------------------------------------------------------------

--F)
SELECT *
FROM FLIGHTS
WHERE DESTINATION_AIRPORT IN('JFK', 'LGA', 'EWR')
AND ELAPSED_TIME > 500

UPDATE FLIGHTS
SET CANCELLED = 1
WHERE DESTINATION_AIRPORT IN('JFK', 'LGA', 'EWR')
AND ELAPSED_TIME > 500

----------------------------------------------------------------------------------------------------------------------------------------------------

--G)
CREATE TABLE #Departure_Delays(
iata_code VARCHAR(10),
airline VARCHAR(100),
delay_category VARCHAR(20),
total_delays INT
);

INSERT INTO #Departure_Delays(iata_code, airline, delay_category, total_delays)
SELECT
    ORIGIN_AIRPORT AS IATA_CODE,
    AIRLINE,
    CASE
        WHEN DEPARTURE_DELAY > 50 THEN 'Big Delay'
        WHEN DEPARTURE_DELAY > 25 THEN 'Medium Delay'
        ELSE 'Small Delay'
    END AS delay_category,
    COUNT(*) AS total_delays
FROM FLIGHTS
WHERE
    departure_delay > 0 AND departure_delay IS NOT NULL
GROUP BY
	ORIGIN_AIRPORT,
    AIRLINE,
	CASE
        WHEN DEPARTURE_DELAY > 50 THEN 'Big Delay'
        WHEN DEPARTURE_DELAY > 25 THEN 'Medium Delay'
        ELSE 'Small Delay'
    END
	

SELECT iata_code, airline, delay_category, SUM(total_delays) AS total_delays
FROM #Departure_Delays
GROUP BY iata_code,airline,delay_category,total_delays
ORDER BY total_delays DESC
DROP TABLE #Departure_Delays;