USE NORTHWIND;

--1. Show the category_name and description from the categories table sorted by category_name.
SELECT
	[CATEGORY_NAME], [DESCRIPTION]
FROM
	CATEGORIES
ORDER BY
	[CATEGORY_NAME];

--2. Show all the contact_name, address, city of all customers which are not from 'Germany', 'Mexico', 'Spain'
SELECT
	[CONTACT_NAME], [ADDRESS], [CITY]
FROM 
	CUSTOMERS
WHERE 
	COUNTRY NOT IN ('Germany','Mexico','Spain');

--3. Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26
SELECT
	[ORDER_DATE], [SHIPPED_DATE], [CUSTOMER_ID], [FRIGHT]
FROM
	ORDERS
WHERE
	[ORDER_DATE] = '2018-02-26';

--4. Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date
SELECT
	[EMPLOYEE_ID], [ORDER_ID], [CUSTOMER_ID], [REQUIRE_DATE], [SHIPPED_DATE]
FROM
	ORDERS
WHERE
	[REQUIRE_DATE] < [SHIPPED_DATE];

--5. Show all the even numbered Order_id from the orders table.
SELECT
	[ORDER_ID]
FROM
	ORDERS
WHERE
	ORDER_ID % 2 = 0;

--6. Show the city, company_name, contact_name of all customers from cities which contains the letter 'L' in the city name, sorted by contact_name
SELECT
	[CITY], [COMPANY_NAME], [CONTACT_NAME]
FROM
	CUSTOMERS
WHERE
	CITY LIKE '%L%'
ORDER BY
	CONTACT_NAME;

--7. Show the company_name, contact_name, fax number of all customers that has a fax number. (not null)
SELECT
	[COMPANY_NAME], [CONTACT_NAME], [FAX]
FROM
	CUSTOMERS
WHERE
	FAX IS NOT NULL;

--8. Show the first_name, last_name, hire_date of the most recently hired employee.
SELECT 
	[FIRST_NAME], [LAST_NAME], [HIRE_DATE]
FROM 
	EMPLOYEES
WHERE HIRE_DATE IN (SELECT MAX(HIRE_DATE) FROM EMPLOYEES)

--9. Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.
SELECT
	CAST(ROUND(AVG(UNIT_PRICE), 2)AS DECIMAL(5, 2))AS AVG_UNIT_PRICE,
	SUM(UNITS_IN_STOCK)AS TOTAL_UNITS,
	SUM(DISCONTINUED)AS DISCOUTINUED_PRODUCTS
FROM
	PRODUCTS;