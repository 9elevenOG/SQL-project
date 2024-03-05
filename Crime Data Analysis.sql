SELECT * FROM Crime_Data

DELETE FROM Crime_Data
WHERE Date_Reported IS NULL

UPDATE Crime_Data
SET Victim_Age_Group = 'Aged'
WHERE Victim_Age_Group = 'FALSE'

DELETE FROM Crime_Data
WHERE Case_Status_Description = '#NAME?'


--Exploring the distribution of crime over time and no of crimes by area 

SELECT COUNT (*) Date_Occurred FROM Crime_Data AS Total_no_of_Crimes
SELECT COUNT (*) Date_Reported FROM Crime_Data AS Total_no_of_Crimes

SELECT YEAR(Date_Occurred) AS Year, MONTH(Date_Occurred) AS Month, COUNT (*) As No_of_Crimes
FROM Crime_Data
GROUP BY YEAR(Date_Occurred), MONTH(Date_Occurred)
ORDER BY Year, Month ASC

SELECT COUNT (DISTINCT Crime_ID_No) AS Crime_Count, Area_Name
FROM Crime_Data
GROUP BY Area_Name
ORDER BY Crime_Count DESC

--Analyzing the time of day when crime occurs the most

SELECT DATEPART(HOUR, Time_Occurred) AS Hour_Of_The_Day, COUNT(*) AS Crime_Count
FROM Crime_Data
GROUP BY DATEPART(HOUR, Time_Occurred)
ORDER BY Crime_Count DESC

--Exploring crime types distribution across age and victim demographic

SELECT COUNT (DISTINCT Crime_ID_No) AS Crime_count, Victim_Age_Group
FROM Crime_Data
GROUP BY Victim_Age_Group

SELECT COUNT (DISTINCT Crime_ID_No) AS Crime_count, Victim_Race
FROM Crime_Data
GROUP BY Victim_Race

SELECT COUNT (DISTINCT Crime_ID_No) AS Crime_count, Victim_Sex
FROM Crime_Data
GROUP BY Victim_Sex

--Weapon Usage Analysis

SELECT COUNT (*) Weapon_Description
FROM Crime_Data
WHERE Weapon_Description IS NOT NULL

--Analyzing the relationship between weapon usage and victim age group

SELECT Victim_Age_Group, COUNT(Weapon_Used_Code) AS Total_Cases
FROM Crime_Data
WHERE Weapon_Used_Code IS NOT NULL
GROUP BY Victim_Age_Group
ORDER BY Total_Cases DESC

--Case status  ansalysis

SELECT Case_Status_Description, COUNT (DISTINCT Crime_ID_No) AS Total_Cases
FROM Crime_Data
GROUP BY Case_Status_Description

--Checking the most common crimes 

SELECT Year, Crime_Code_Description 
FROM (
	SELECT YEAR(Date_Occurred) AS Year, Crime_Code_Description, COUNT(*) AS Crime_Count, ROW_NUMBER() OVER (PARTITION BY YEAR(Date_Occurred)
	ORDER BY COUNT(*) DESC) AS RN
FROM Crime_Data
GROUP BY YEAR(Date_Occurred), Crime_Code_Description
) AS Subquery
WHERE RN = 1
ORDER BY Year

SELECT Area_Name, Crime_Code_Description 
FROM (
	SELECT Area_Name, Crime_Code_Description, COUNT(*) AS Crime_Count, ROW_NUMBER() OVER (PARTITION BY Area_Name
	ORDER BY COUNT(*) DESC) AS RN
FROM Crime_Data
GROUP BY Area_Name, Crime_Code_Description
) AS Subquery
WHERE RN = 1

