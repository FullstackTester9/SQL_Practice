USE NORTHWIND;
--1. Show the employee's first_name and last_name, a "Num_Orders" column with a count of the orders taken, 
--and a column called "Shipped" that displays "On Time" if the order shipped on time and "Late" if the order shipped late. 
--Group records by employee first_name and last_name and then by the "Shipped" status. Order by employee lastname, then by firstname, 
--and then descending by number of orders.

SELECT 
	E.FIRST_NAME, E.LAST_NAME, COUNT(O.ORDER_ID) AS NUM_OF_ORDERS,
CASE
	WHEN SHIPPED_DATE <= REQUIRE_DATE THEN 'ON TIME'
    WHEN SHIPPED_DATE IS NULL THEN 'NOT SHIPPED'
    ELSE 'LATE'
END AS SHIPPED
FROM 
	EMPLOYEES E 
INNER JOIN 
	ORDERS O 
ON
	E.EMPLOYEE_ID = O.EMPLOYEE_ID
GROUP BY 
	E.FIRST_NAME, E.LAST_NAME,
	CASE
		WHEN SHIPPED_DATE <= REQUIRE_DATE THEN 'ON TIME'
  	    WHEN SHIPPED_DATE IS NULL THEN 'NOT SHIPPED'
  	ELSE 'LATE'
	END
ORDER BY 
	LAST_NAME, FIRST_NAME, NUM_OF_ORDERS DESC;

--2. Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places.
SELECT 
    YEAR(O.ORDER_DATE) AS ORDER_YEAR,
    ROUND(SUM(P.UNIT_PRICE * OD.QUANTITY * OD.DISCOUNT), 2) AS MONEY_LOST
FROM 
    ORDERS O
INNER JOIN 
    ORDER_DETAILS OD
ON
	O.ORDER_ID = OD.ORDER_ID
INNER JOIN
	PRODUCTS P
ON
	P.PRODUCT_ID = OD.PRODUCT_ID
GROUP BY 
    YEAR(O.ORDER_DATE)
ORDER BY 
    ORDER_YEAR DESC;