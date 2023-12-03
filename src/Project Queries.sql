SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

# Avg Sales per Company shipped to
SELECT Identifier, round(AVG(NetSales),1)
FROM TransactionInfo
GROUP BY Identifier
ORDER BY AVG(NetSales) Desc;

# Average Profit per City 
SELECT s.City as "City", round(AVG(transactioninfo.MatMargin),1) as "Material Profit"
FROM transactioninfo 
INNER JOIN shipmentinfo as s
ON transactioninfo.ShipID = s.ShipID 
GROUP BY s.City
ORDER BY AVG(transactioninfo.MatMargin) DESC
LIMIT 10;

# Total profit and gallons sold per material
SELECT MaterialID, SUM(Gallons) as "Total Gallons", SUM(MatMargin) as "Total Material Profit"
FROM transactioninfo
GROUP BY MaterialID
ORDER BY SUM(Gallons) DESC
LIMIT 20;

# Total Sales and Gallons sold per State 
SELECT c.State as "State", round(SUM(transactioninfo.NetSales),1) as "Total Sales", SUM(transactioninfo.Gallons) as "Total Gallons"
FROM transactioninfo 
INNER JOIN shipmentinfo as s
ON transactioninfo.ShipID = s.ShipID 
INNER JOIN cityinfo as c
ON c.city = s.city
GROUP BY c.State
ORDER BY SUM(transactioninfo.NetSales) DESC
LIMIT 10;

# Total Gallons Delievered and Distance driven per Driver, along with Age
SELECT d.DriverID as "Driver ID", d.DriverAge as "Driver Age", SUM(t.Gallons) as "Total Gallons Delievered", round(AVG(s.DistanceMiles),1) as "Average Distance Driven (Miles)"
FROM driverinfo as d
INNER JOIN shipmentinfo as s
ON  s.DriverID = d.DriverID 
INNER JOIN transactioninfo as t
ON t.ShipID = s.ShipID
GROUP BY d.DriverID, d.DriverAge
HAVING SUM(t.Gallons) >= 15000
ORDER BY SUM(t.Gallons) DESC;

# Total Shipments, Gallons sold, and Sales per month -- supply demand, production levels required for factories
SELECT MONTH(s.date) as "2022 Month", COUNT(Distinct s.ShipID) as "Total Shipments", SUM(Gallons) as "Total Gallons Sold", SUM(t.NetSales) as "Total Sales"
FROM shipmentinfo as s
INNER JOIN transactioninfo as t
ON t.ShipID = s.ShipID
GROUP BY MONTH(s.date)
ORDER BY COUNT(Distinct s.ShipID) DESC;

# Per State total profit received per month (IE most shipping)
SELECT c.State, MONTH(s.date) as "2022 Month", SUM(t.MatMargin) as "Total Profit"
FROM transactioninfo as t
INNER JOIN shipmentinfo as s
ON s.ShipID = t.ShipID
INNER JOIN cityinfo as c
ON c.city = s.city
GROUP BY MONTH(s.date), c.State
ORDER BY SUM(t.MatMargin) DESC;

# Per State total distance shipments traveled to reach -- overall highest shipping costs
SELECT c.State, round(SUM(s.DistanceMiles),1) as "Total Distance"
FROM shipmentinfo as s
INNER JOIN cityinfo as c
ON c.city = s.city
GROUP BY c.State
ORDER BY SUM(s.DistanceMiles) DESC
LIMIT 15;

# Per month average drive duration of shipments -- spikes of shipping costs/if drivers are spending longer driving during holiday months
SELECT MONTH(s.date) as "2022 Month", round(AVG(DriveDuration),1) as "Avg Drive Duration (Hours)"
FROM shipmentinfo as s
GROUP BY MONTH(s.date)
ORDER BY AVG(DriveDuration) DESC;

# Distance to Company, and overall avg material profit per transaction - whether its worth to travel at all
SELECT t.Identifier as "Company", round(s.DistanceMiles,1) as "Distance in Miles", AVG(t.MatMargin) as "Avg Material Profit"
FROM transactioninfo as t
INNER JOIN shipmentinfo as s
ON s.ShipID = t.ShipID
GROUP BY t.Identifier, s.DistanceMiles
ORDER BY AVG(t.MatMargin) DESC
LIMIT 15;
