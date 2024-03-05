SELECT * FROM Border_Crossing_Entry_Data 

---Total number of crossings for the year

SELECT SUM(Value) AS Total_Crossings
FROM Border_Crossing_Entry_Data

--- Counting the total number of ports for each border

SELECT Border, COUNT(DISTINCT Port_Name)
FROM Border_Crossing_Entry_Data
GROUP BY Border

---Identifying the busiest ports for the year

SELECT TOP 10 Port_Name, SUM(Value) AS Total_crossings
FROM Border_Crossing_Entry_Data
GROUP BY Port_Name
ORDER BY Total_crossings DESC

---Total number of monthly and daily crossings

SELECT Month, SUM(Value) AS total_monthly_crossings
FROM Border_Crossing_Entry_Data
GROUP BY Month
ORDER BY total_monthly_crossings DESC

SELECT Day_of_the_week, SUM(Value) AS total_crossings
FROM Border_Crossing_Entry_Data
GROUP BY Day_of_the_week
ORDER BY total_crossings DESC

--- Analyzing measure of crossings

SELECT Measure, SUM(Value) AS total_crossings
FROM Border_Crossing_Entry_Data
GROUP BY Measure
ORDER BY total_crossings DESC

--- AVerage number of crossings by state

SELECT State, AVG(Value) AS Avg_crossings
FROM Border_Crossing_Entry_Data
GROUP BY State
ORDER BY Avg_crossings DESC

---Crossings by border type

SELECT Border, SUM(Value) AS total_crossings
FROM Border_Crossing_Entry_Data
GROUP BY Border

--- Peak crossing days

SELECT TOP 10 Date, SUM(Value) AS Daily_Crossing
FROM Border_Crossing_Entry_Data
GROUP BY Date
ORDER BY Daily_Crossing DESC

--- Checking the top means of crossings by Border

SELECT Border, Measure, SUM(Value) AS Total_crosssings
FROM Border_Crossing_Entry_Data
GROUP BY Border, Measure
ORDER BY Total_crosssings DESC

--- checking the highest monthly crossings for each border

WITH MonthlyRankings AS (
 SELECT Border, Month, RANK() OVER (PARTITION BY Month ORDER BY SUM(Value) DESC) AS monthly_rank,
 SUM(Value) AS total_crossings
 FROM Border_Crossing_Entry_Data
 GROUP BY Border, Month
)

SELECT Border, Month, total_crossings
FROM MonthlyRankings
ORDER BY total_crossings DESC