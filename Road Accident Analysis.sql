SELECT * FROM road_accident

SELECT SUM(number_of_casualties) AS total_no_casualties
FROM road_accident 

SELECT SUM(number_of_casualties) AS total_fatal_casualties
FROM road_accident 
WHERE accident_severity = 'Fatal'

SELECT SUM(number_of_casualties) AS total_fatal_casualties
FROM road_accident 
WHERE accident_severity = 'Slight'

SELECT SUM(number_of_casualties) AS total_fatal_casualties
FROM road_accident 
WHERE accident_severity = 'Serious'

SELECT SUM(number_of_casualties) AS total_fatal_casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022' AND road_surface_conditions = 'Wet or damp'

SELECT COUNT (DISTINCT accident_index) AS total_accidents
FROM road_accident

SELECT accident_severity, CAST(SUM(number_of_casualties) AS DECIMAL (10, 2)) *100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL (10, 2)) FROM road_accident) AS percentage_severity
FROM road_accident
GROUP BY accident_severity

SELECT DISTINCT vehicle_type FROM road_accident

SELECT
     CASE
	    WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc') THEN 'Bikes'
		WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Buses'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Van / Goods 3.5 tonnes mgw or under', 'Goods over 3.5t. and under 7.5t') THEN 'Vans'
		ELSE 'Others'
	END AS vehicle_group,
	SUM(number_of_casualties) AS no_of_casualties_by_vehicle
FROM road_accident
GROUP BY  CASE
	    WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc') THEN 'Bikes'
		WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Buses'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Van / Goods 3.5 tonnes mgw or under', 'Goods over 3.5t. and under 7.5t') THEN 'Vans'
		ELSE 'Others'
	END 

SELECT DATENAME(MONTH,accident_date) AS month_name, SUM(number_of_casualties) AS current_year_casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH,accident_date)

SELECT road_type, SUM(number_of_casualties)
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type

SELECT urban_or_rural_area,SUM(number_of_casualties) AS total_casualties, CAST(SUM(number_of_casualties) AS DECIMAL (10, 2)) * 100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10, 2)) FROM road_accident) AS percentage_of_rural_urban_area
FROM road_accident
GROUP BY urban_or_rural_area

SELECT DISTINCT light_conditions
FROM road_accident 

SELECT 
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - no lighting', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - lighting unknown') THEN 'Night'
		END AS light_condition,
		CAST(SUM(number_of_casualties) AS DECIMAL (10, 2)) * 100/
		(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10, 2)) FROM road_accident) AS percentage_of_light_conditions 
		FROM road_accident
		GROUP BY CASE
				WHEN light_conditions IN ('Daylight') THEN 'Day'
				WHEN light_conditions IN ('Darkness - no lighting', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - lighting unknown') THEN 'Night'
		END

SELECT TOP 10 local_authority, SUM(number_of_casualties) AS total_accidents
FROM road_accident
GROUP BY local_authority
ORDER BY total_accidents DESC

SELECT DISTINCT weather_conditions FROM road_accident

SELECT 
	CASE
		WHEN weather_conditions IN ('Fog or mist', 'Snowing no high winds', 'Snowing + high winds') THEN 'Snow'
		WHEN weather_conditions IN ('Raining + high winds','Raining no high winds') THEN 'Rainy'
		WHEN weather_conditions IN ('Fine no high winds', 'Fine + high winds') THEN 'Fine'
		ELSE 'Other'
		END AS weather_condition,
	COUNT(DISTINCT accident_index) AS total_accident
	FROM road_accident
	GROUP BY CASE
		WHEN weather_conditions IN ('Fog or mist', 'Snowing no high winds', 'Snowing + high winds') THEN 'Snow'
		WHEN weather_conditions IN ('Raining + high winds','Raining no high winds') THEN 'Rainy'
		WHEN weather_conditions IN ('Fine no high winds', 'Fine + high winds') THEN 'Fine'
		ELSE 'Other'
		END

SELECT 
	CASE
		WHEN weather_conditions IN ('Fog or mist', 'Snowing no high winds', 'Snowing + high winds') THEN 'Snow'
		WHEN weather_conditions IN ('Raining + high winds','Raining no high winds') THEN 'Rainy'
		WHEN weather_conditions IN ('Fine no high winds', 'Fine + high winds') THEN 'Fine'
		ELSE 'Other'
		END AS weather_condition,
	SUM(number_of_casualties) AS total_casualties
	FROM road_accident
	GROUP BY CASE
		WHEN weather_conditions IN ('Fog or mist', 'Snowing no high winds', 'Snowing + high winds') THEN 'Snow'
		WHEN weather_conditions IN ('Raining + high winds','Raining no high winds') THEN 'Rainy'
		WHEN weather_conditions IN ('Fine no high winds', 'Fine + high winds') THEN 'Fine'
		ELSE 'Other'
		END

SELECT TOP 10 local_authority, COUNT(DISTINCT accident_index) AS total_accidents, SUM(number_of_casualties) AS total_casualties
FROM road_accident
WHERE speed_limit >60 AND accident_severity = 'Fatal'
GROUP BY local_authority
ORDER BY total_casualties DESC

SELECT DISTINCT road_surface_conditions FROM road_accident

SELECT 
	CASE
		WHEN road_surface_conditions IN ('Dry') THEN 'Dry'
		WHEN road_surface_conditions IN ('Wet or damp', 'Flood over 3cm. deep') THEN 'Wet'
		WHEN road_surface_conditions IN ('Frost or ice','Snow' ) THEN 'Snow'
		END AS road_surface_condition,
		CAST(SUM(number_of_casualties) AS DECIMAL (10, 2)) * 100/
		(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10, 2)) FROM road_accident) AS percentage_of_road_condition 
		FROM road_accident
		GROUP BY 
			CASE
				WHEN road_surface_conditions IN ('Dry') THEN 'Dry'
				WHEN road_surface_conditions IN ('Wet or damp', 'Flood over 3cm. deep') THEN 'Wet'
				WHEN road_surface_conditions IN ('Frost or ice','Snow' ) THEN 'Snow'
			END 