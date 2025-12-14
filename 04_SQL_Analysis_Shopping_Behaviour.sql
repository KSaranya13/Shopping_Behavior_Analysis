-- Shopping Behaviour Dataset Analysis
----------------------------------------

-- View entire dataset
select * from shopping_behavior_updated

-----------------------------------------
--1. Most preferred product category
-----------------------------------------
SELECT 
	Category, 
	COUNT(*) AS Count
FROM shopping_behavior_updated
GROUP BY Category
ORDER BY Count DESC

-----------------------------------------
--2. Top 5 most purchased items
-----------------------------------------
SELECT 
	Top 5 Item_Purchased, 
	COUNT(*) AS Count
FROM shopping_behavior_updated
GROUP BY Item_Purchased
ORDER BY Count DESC

-----------------------------------------
--3. Gender-wise Category Purchases
-----------------------------------------
SELECT 
	Gender, 
	Category, 
	COUNT(*) AS Count
FROM shopping_behavior_updated
GROUP BY Gender, Category
ORDER BY Gender, Count DESC

--------------------------------------------------------------
--4. Count of male vs female customers who bought Accessories
--------------------------------------------------------------
SELECT
    SUM(CASE WHEN Gender = 'Male' THEN 1 END) AS Male_Accessory_Buyers,
    SUM(CASE WHEN Gender = 'Female' THEN 1 END) AS Female_Accessory_Buyers
FROM shopping_behavior_updated
WHERE Category = 'Accessories'

--------------------------------------------------------
--5. Ranking items by popularity within each category
--------------------------------------------------------
SELECT 
    Category,
    Item_Purchased,
    COUNT(*) AS Purchase_Count,
    RANK() OVER (PARTITION BY Category ORDER BY COUNT(*) DESC) AS Rank_In_Category
FROM shopping_behavior_updated
GROUP BY Category, Item_Purchased
order by Rank_In_Category

-------------------------------------------------
--6. Top 3 locations where females shop the most
-------------------------------------------------
SELECT 
	Top 3  Location, 
	COUNT(*) AS Female_Shoppers
FROM shopping_behavior_updated
WHERE Gender = 'Female'
GROUP BY Location
ORDER BY Female_Shoppers DESC

-----------------------------------------------
--7. Percentage of Customers using Credit Card
-----------------------------------------------
SELECT 
    CAST((COUNT(CASE WHEN Payment_Method = 'Credit Card' THEN 1 END) * 100.0) / COUNT(*) AS DECIMAL(10,4)) AS Credit_Card_Percentage
FROM shopping_behavior_updated

----------------------------------------------------------------------------
--8.  Count of monthly purchasers using Free Shipping (by Gender & Season)
----------------------------------------------------------------------------
SELECT 
    Gender,
    Season,
    COUNT(Customer_ID) AS Total_Customers
FROM shopping_behavior_updated
WHERE Frequency_of_Purchases = 'Monthly' AND Shipping_Type = 'Free Shipping'
GROUP BY Gender, Season
ORDER BY Gender Desc,Total_Customers DESC

-----------------------------------------
--9. Most common item for each size
-----------------------------------------
SELECT 
	s.Size, 
	s.Item_Purchased, 
	s.Item_Count
FROM (
    SELECT Size, Item_Purchased, COUNT(*) AS Item_Count,
           ROW_NUMBER() OVER (PARTITION BY Size ORDER BY COUNT(*) DESC) AS rn
    FROM shopping_behavior_updated
    GROUP BY Size, Item_Purchased
) s
WHERE s.rn = 1

---------------------------------------------------------------------
--10. Count of customers by payment method (grouped into categories)
---------------------------------------------------------------------
SELECT 
    CASE 
        WHEN Payment_Method IN ('Credit Card','Cash','PayPal','Venmo','Bank Transfer','Debit Card')
            THEN Payment_Method
        ELSE 'Other'
    END AS Payment_Category,
    COUNT(*) AS Count
FROM shopping_behavior_updated
GROUP BY 
    CASE 
        WHEN Payment_Method IN ('Credit Card','Cash','PayPal','Venmo','Bank Transfer','Debit Card')
            THEN Payment_Method
        ELSE 'Other'
    END
ORDER BY Count DESC

---------------------------------------------------------------
--11. Least preferred item in each category (anti-popularity)
---------------------------------------------------------------
SELECT 
	Category, 
	Item_Purchased, 
	Item_Count
FROM (
    SELECT Category, Item_Purchased, COUNT(*) AS Item_Count,
           RANK() OVER (PARTITION BY Category ORDER BY COUNT(*) ASC) AS rn
    FROM shopping_behavior_updated
    GROUP BY Category, Item_Purchased
) x
WHERE rn = 1
Order BY Item_Count

-----------------------------------------
--12. Total purchases per season
-----------------------------------------
SELECT 
	Season, 
	COUNT(*) AS Total_Purchases
FROM shopping_behavior_updated
GROUP BY Season
ORDER BY Total_Purchases DESC

--------------------------------------------
--13. Gender-wise payment method preference
--------------------------------------------
SELECT 
	Payment_Method, 
	Gender,  
	COUNT(*) AS Count
FROM shopping_behavior_updated
GROUP BY Gender, Payment_Method
ORDER BY Gender, Count DESC