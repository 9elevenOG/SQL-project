select * from vgsales

select COUNT (DISTINCT Platform) as Platform_count
from vgsales

select * from vgsales
where Name like '%War'

select TOP 10 Name, Genre, Platform, Global_Sales from vgsales
where Genre = 'Shooter' and Platform = 'PS2'
group by Name, Genre, Platform, Global_Sales
order by Global_Sales DESC

select TOP 10 Name, Genre, Platform, Global_Sales from vgsales
where Genre = 'Role-playing' and Platform = 'PS2'
group by Name, Genre, Platform, Global_Sales
order by Global_Sales DESC

select TOP 10 Name, Genre, Platform, Global_Sales from vgsales
where Genre = 'Sports' and Platform = 'X360'
group by Name, Genre, Platform, Global_Sales
order by Global_Sales DESC

select top 10 Name, Genre, Year, Platform,  Global_Sales from vgsales
where Genre = 'Adventure' and Year BETWEEN '2005' AND '2010' and Platform = 'PS3'
group by Name, Genre, Year, Platform, Global_Sales
order by  Global_Sales DESC

select top 10 Name, Genre, Year, Platform, Publisher, Global_Sales 
from vgsales
where Platform = 'NES' and Genre = 'Shooter'
order by Global_Sales DESC
 
 select TOP 10 Name, Platform, Global_Sales from vgsales
 order by Global_Sales DESC

select TOP 10 Platform, COUNT(*) AS GamesReleased
from vgsales
group by Platform
order by GamesReleased DESC;

select Platform, SUM(Global_Sales) AS TotalSales
from vgsales
group by Platform
order by TotalSales DESC;

select Year, Genre, COUNT(*) AS GameCount
from vgsales
where Year = '2008'
group by Year, Genre
order by Year, GameCount DESC;

select Year, SUM(Global_Sales) AS TotalSales
from vgsales
where Year IS NOT NULL
group by Year
order by Year;


