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
 