SELECT * FROM dbo.Orders

SELECT COUNT(DISTINCT Order_ID) AS Distinct_order_count
FROM dbo.Orders 

SELECT COUNT(DISTINCT Product_Name) AS Distinct_product_name
FROM dbo.Orders

SELECT Customer_Segment, COUNT(*) AS Customer_Count
FROM dbo.Orders
GROUP BY Customer_Segment
ORDER BY Customer_segment

--calculating monthly and yearly sales trend

SELECT YEAR(Order_Date) AS Sales_year,
       MONTH(Order_Date) AS Sales_month,
       SUM(Sales) AS total_sales
FROM dbo.Orders
WHERE YEAR(Order_Date) IN (2017, 2018, 2019, 2020)
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Sales_year, Sales_month


SELECT YEAR(Order_Date) AS Sales_year,
       SUM(Sales) AS Total_sales
FROM dbo.Orders
GROUP BY YEAR(Order_Date)
ORDER BY Sales_year

--Analyzing sales by customer segment and region

SELECT Customer_Segment, Region, SUM(Sales) AS total_sales
FROM dbo.Orders
GROUP BY Customer_Segment, Region
ORDER BY Customer_Segment, Region

--Calculating profit margin for each product category

SELECT Product_Category,
       AVG((profit / NULLIF(sales, 0)) * 100) AS Profit_margin
FROM dbo.Orders
GROUP BY Product_Category
ORDER BY Profit_margin DESC
 
--Identifying the most and least profitable Customer category

SELECT Customer_Segment,
        AVG(Profit) AS Average_profit
FROM dbo.Orders
GROUP BY Customer_Segment
ORDER BY Average_profit DESC

--Evaluating the correlation between discount and profit

SELECT (COUNT(*) * SUM(Discount * Profit) - SUM(Discount) * SUM(Profit))/
       SQRT((COUNT(*) * SUM(Discount * Discount) - POWER(SUM(Discount), 2)) * 
       (COUNT(*) * SUM(Profit * Profit) - POWER(SUM(Profit), 2))) AS Correlation_coefficient
FROM dbo.Orders

--Evaluating the correlation between discount and sales

SELECT (COUNT(*) * SUM(Discount * Sales) - SUM(Discount) * SUM(Sales))/
       SQRT((COUNT(*) * SUM(Discount * Discount) - POWER(SUM(Discount), 2)) * 
       (COUNT(*) * SUM(Sales * Sales) - POWER(SUM(Sales), 2))) AS Correlation_coefficient
FROM dbo.Orders
WHERE Discount IS NOT NULL 


--Identify high value and low value customer segment

WITH Customer_Segment_Sales AS (
    SELECT Customer_Segment, SUM(Sales) AS Total_sales
	FROM dbo.Orders
	GROUP BY Customer_Segment
)

SELECT Customer_Segment, Total_sales,
     CASE 
	     WHEN Total_sales >= (
		 SELECT AVG(Total_sales) FROM Customer_Segment_Sales
		 )
	         THEN 'High-Value'
	         ELSE 'Low-Value'
     END AS value_category
FROM Customer_Segment_Sales
ORDER BY Total_sales DESC

--Evaluating buying patterns of each customer segment

SELECT Customer_Segment, AVG(Order_Quantity) AS Average_order_quatity
FROM dbo.Orders
GROUP BY Customer_Segment
ORDER BY Average_order_quatity

--Calculating sales and profit contribution by product category

SELECT Product_Category, SUM(Sales) AS Total_sales, SUM(Profit) AS Total_profit
FROM dbo.Orders
GROUP BY Product_Category
ORDER BY Product_Category

--Analyzing trends in sales and profitability for each category

SELECT Product_Category, 
       YEAR(Order_Date) AS sales_year,
	   SUM(Sales) AS total_sales,
	   SUM(Profit) AS total_profit
FROM dbo.Orders
GROUP BY Product_Category, YEAR(Order_Date)
ORDER BY Product_Category, sales_year

--Identifying categories with high and low unit prices

SELECT Product_Category, AVG(Unit_Price) AS Average_unit_price
FROM dbo.Orders
GROUP BY Product_Category
ORDER BY Average_unit_price

--Analyzing the relationship between shipping mode and shipping costs

SELECT Ship_Mode,
       AVG(Shipping_Cost) AS average_shipping_cost,
	   MAX(Shipping_Cost) AS max_shipping_cost,
	   MIN(Shipping_Cost) AS min_shipping_cost
FROM dbo.Orders
GROUP BY Ship_Mode

--Identifying regions with the highest shipping cost

SELECT Region, SUM(Shipping_Cost) AS total_shipping_cost
FROM dbo.Orders
GROUP BY Region
ORDER BY total_shipping_cost

--Evaluating the impact of discount on product base margin

SELECT Discount,
       AVG(Product_Base_Margin) AS average_product_margin
FROM (
    SELECT Discount, Product_Base_Margin
    FROM dbo.Orders
    WHERE Discount IS NOT NULL
) AS subquery
GROUP BY Discount
ORDER BY Discount

--Analyzing the relationship between order quantity and sales

SELECT Order_Quantity, AVG(Sales) AS average_sales
FROM dbo.Orders
GROUP BY Order_Quantity
ORDER BY average_sales DESC

--Identifying the top customers for each region

WITH RankedCustomers AS (
    SELECT Customer_Name,
	       Customer_Segment,
	       Region,
		   RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS purchase_rank
	FROM dbo.Orders
	GROUP by Customer_Name, Customer_Segment, Region
)
SELECT Customer_Name, Customer_Segment, Region
FROM RankedCustomers
WHERE purchase_rank <=5