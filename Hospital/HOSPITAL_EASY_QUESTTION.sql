USE HOSPITAL

--1. Show first name, last name, and gender of patients whose gender is 'M'

SELECT
	FIRST_NAME, LAST_NAME,GENDER
FROM
	PATIENTS
WHERE
	GENDER = 'M'

--2. Show first name and last name of patients who does not have allergies. (null)

SELECT
	FIRST_NAME, LAST_NAME
FROM
	PATIENTS
WHERE
	ALLERGIES IS NULL

--3. Show first name of patients that start with the letter 'C'

SELECT
	FIRST_NAME
FROM
	PATIENTS
WHERE
	FIRST_NAME LIKE 'C%'

--4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT
	FIRST_NAME, LAST_NAME
FROM
	PATIENTS
WHERE
	WEIGHT BETWEEN 100 AND 120

--5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

UPDATE
	PATIENTS
SET
	ALLERGIES = 'NKA'
WHERE
	ALLERGIES IS NULL

--6. Show first name and last name concatinated into one column to show their full name.

SELECT
	concat(FIRST_NAME,' ',LAST_NAME)AS FULL_NAME
FROM
	PATIENTS

--7. Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'

SELECT
	P.FIRST_NAME, P.LAST_NAME, PN.PROVINCE_NAME
FROM
	PATIENTS P
INNER JOIN
	PROVINCE_NAMES PN
ON
	P.PROVINCE_ID = PN.PROVINCE_ID

--8. Show how many patients have a birth_date with 2010 as the birth year.

SELECT
	COUNT(YEAR(BIRTH_DATE))AS BIRTY_YEAR
FROM
	PATIENTS
WHERE
	YEAR(BIRTH_DATE) = 2010
--9. Show the first_name, last_name, and height of the patient with the greatest height.

SELECT
	TOP(1) FIRST_NAME, LAST_NAME, HEIGHT
FROM
	PATIENTS
ORDER BY
	HEIGHT DESC
--OR
SELECT
  FIRST_NAME,
  LAST_NAME,
  HEIGHT
FROM PATIENTS
WHERE HEIGHT = (SELECT MAX(HEIGHT)
				FROM PATIENTS)
--10. Show all columns for patients who have one of the following patient_ids:1,45,534,879,1000

SELECT *
FROM
	PATIENTS
WHERE
	PATIENT_ID IN(1, 45, 534, 879, 1000)

--11. Show the total number of admissions

SELECT 
	COUNT(*) AS TOTAL_ADMISSIONS
FROM
	ADMISSIONS

--12. Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT * 
FROM
	ADMISSIONS
WHERE
	ADMISSION_DATE = DISCHARGE_DATE

--13. Show the patient id and the total number of admissions for patient_id 579.

SELECT
	PATIENT_ID, COUNT(PATIENT_ID) AS TOTAL_ADMISSIONS
FROM
	ADMISSIONS
WHERE
	PATIENT_ID = 579
GROUP BY
	PATIENT_ID

--14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

SELECT distinct(CITY)AS UNIQUE_CITY
FROM
	PATIENTS
WHERE
	PROVINCE_ID = 'NS'
--OR
SELECT 
	CITY
FROM
	PATIENTS
WHERE
	PROVINCE_ID = 'NS'
GROUP BY
	CITY

--15. Write a query to find the first_name, last name, and birth date of patients who has height greater than 160 
-- and weight greater than 70

SELECT
	FIRST_NAME, LAST_NAME, BIRTH_DATE
FROM
	PATIENTS
WHERE
	HEIGHT > 160 AND WEIGHT > 70

--16. Write a query to find list of patients first_name, last_name, and allergies from city 'Hamilton' 
-- where allergies is not null

SELECT
	FIRST_NAME, LAST_NAME, ALLERGIES
FROM
	PATIENTS
WHERE
	ALLERGIES IS NOT NULL AND 
	CITY = 'Hamilton'