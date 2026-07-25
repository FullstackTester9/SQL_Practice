USE NORTHWIND;
--1. Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
SELECT
	P.PRODUCT_NAME, S.COMPANY_NAME, C.CATEGORY_NAME
FROM 
	PRODUCTS P
INNER JOIN
	SUPPLIERS S
ON
	P.SUPPLIER_ID = S.SUPPLIER_ID
INNER JOIN
	CATEGORIES C
ON
	C.CATEGORY_ID = P.CATEGORY_ID;

--2. Show the category_name and the average product unit price for each category rounded to 2 decimal places.
SELECT
	C.CATEGORY_NAME, CAST(ROUND(AVG(P.UNIT_PRICE),2)AS DECIMAL (5, 2))AS AVG_UNIT_PRICE
FROM
	CATEGORIES C
INNER JOIN
	PRODUCTS P
ON
	C.CATEGORY_ID = P.CATEGORY_ID
GROUP BY
	C.CATEGORY_NAME;

--3. Show the city, company_name, contact_name from the customers and suppliers table merged together.
--Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
SELECT 
	CITY, COMPANY_NAME, CONTACT_NAME, 'CUSTOMERS' AS TABLE_NAME
FROM 
	CUSTOMERS 
UNION
SELECT 
	CITY, COMPANY_NAME, CONTACT_NAME, 'SUPPLIERS' 
FROM 
	SUPPLIERS;

--4. Show the total amount of orders for each year/month.
SELECT
	YEAR(ORDER_DATE) AS ORDER_YEAR, MONTH(ORDER_DATE)AS ORDER_MONTH,
    COUNT(ORDER_ID)AS NO_OF_ORDER
FROM
	ORDERS
GROUP BY
	YEAR(ORDER_DATE), MONTH(ORDER_DATE)
ORDER BY
	ORDER_MONTH