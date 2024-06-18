# City with the most Gallons imported each month
SELECT MonthDate, City
	FROM(SELECT MONTH(PostingDate) as MonthDate,
    ROW_NUMBER() OVER(PARTITION BY MONTH(PostingDate) ORDER BY SUM(Gallons)) as ranking, 
    Ship_to_City as City
	FROM data
	GROUP BY Ship_to_City, MONTH(PostingDate)) as rankedcity
WHERE ranking = 1;

# Running Total Profit
WITH rolling_rank AS (
	SELECT 
		MONTH(PostingDate) as Month_Date, 
        SUM(Mat_Margin) as Profit, 
		SUM(SUM(Mat_Margin)) OVER(PARTITION BY MONTH(PostingDate)
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
	FROM data
    GROUP BY MONTH(PostingDate))

SELECT Month_Date, CONCAT("$", running_total) as running_total
FROM rolling_rank;

# Average Profit per City 
SELECT Ship_To_City as "City", round(SUM(Mat_Margin)/COUNT(Distinct ShipID),1) as "Avg Material Profit per Shipment", round(Distance/1609,2) as Distance_Miles, 
round(SUM(Mat_Margin)/SUM(Gallons),1) as "Avg Material Profit per Gallon"
FROM data
GROUP BY Ship_To_City, Distance_Miles
ORDER BY SUM(Mat_Margin)/COUNT(Distinct ShipID) DESC
LIMIT 30;

# Total profit and gallons sold per material
SELECT Material_Identifier, SUM(Gallons) as "Total Gallons Sold", COUNT(Distinct ShipID) as "Total Shipments", 
concat(round(((SUM(Net_Sales)-SUM(Mat_Margin))/SUM(Net_Sales))*100, 2), "%") as "Percent Expensed", round(SUM(Mat_Margin)/SUM(Gallons),2) as "Profit Per Gallon", round(SUM(Net_Sales)/SUM(Gallons),2) as "Net Sales per Gallon"
FROM data
GROUP BY Material_Identifier
ORDER BY SUM(Mat_Margin)/SUM(Gallons) DESC;

# Total Shipments, Gallons sold, and Sales per month -- supply demand, production levels required for factories
SELECT MONTH(PostingDate) as "2022 Month", COUNT(Distinct ShipID) as "Total Shipments", SUM(Gallons) as "Total Gallons Sold", SUM(Mat_Margin) as "Total Profit", 
round(SUM(Mat_Margin)/SUM(Gallons),2) as "Profit Per Gallon"
FROM data
GROUP BY MONTH(PostingDate)
ORDER BY SUM(Mat_Margin) DESC;

SELECT MONTH(PostingDate) as "2022 Month", round(AVG(TimeTravel),1) as "Avg Drive Duration (Hours)"
FROM data
GROUP BY MONTH(PostingDate)
ORDER BY AVG(TimeTravel) DESC;

SELECT Ship_To_City, Ship_To_State, ShipID, SUM(Gallons)
FROM data
GROUP BY Ship_To_City, ShipID, Ship_To_State
ORDER BY SUM(Gallons) DESC;
 
