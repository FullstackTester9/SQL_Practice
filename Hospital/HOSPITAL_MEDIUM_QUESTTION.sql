USE HOSPITAL;

--1. Show unique birth years from patients and order them by ascending.

SELECT distinct YEAR(BIRTH_DATE)AS BIRTH_YEAR
FROM
	PATIENTS
ORDER BY
	YEAR(BIRTH_DATE) ASC

--2. Show unique first names from the patients table which only occurs once in the list.
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. 
--If only 1 person is named 'Leo' then include them in the output.

SELECT 
	FIRST_NAME
FROM
	PATIENTS
GROUP BY
	FIRST_NAME
HAVING
	COUNT(FIRST_NAME) = 1
ORDER BY
	FIRST_NAME ASC

--3. Show patient_id and first_name from patients where their first_name start and ends with 's'
--and is at least 6 characters long.

SELECT PATIENT_ID, FIRST_NAME
FROM
	PATIENTS
WHERE
	FIRST_NAME LIKE 'S____%s' AND LEN(FIRST_NAME)>= 6
--OR
SELECT
  PATIENT_ID,
  FIRST_NAME
FROM PATIENTS
WHERE
  FIRST_NAME LIKE 'S%s' AND
  LEN(FIRST_NAME) >= 6

--4. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
--Primary diagnosis is stored in the admissions table.

SELECT P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME
FROM
	PATIENTS P
INNER JOIN
	ADMISSIONS A
ON
	P.PATIENT_ID = A.PATIENT_ID
WHERE
	DIAGNOSIS = 'Dementia'
--OR
SELECT
  PATIENT_ID, FIRST_NAME, LAST_NAME
FROM 
	PATIENTS
WHERE 
	PATIENT_ID IN 
				(SELECT PATIENT_ID
					FROM ADMISSIONS
					WHERE DIAGNOSIS = 'Dementia')
--OR
SELECT
  PATIENT_ID,
  FIRST_NAME,
  LAST_NAME
FROM PATIENTS P
WHERE 'Dementia' IN
				(SELECT DIAGNOSIS
					FROM ADMISSIONS
					WHERE ADMISSIONS.PATIENT_ID = P.PATIENT_ID)

--5. Display every patient's first_name. Order the list by the length of each name and then by alphabetically

SELECT FIRST_NAME
FROM
	PATIENTS
ORDER BY
	LEN(FIRST_NAME) ASC,
    FIRST_NAME ASC

--6. Show the total amount of male patients and the total amount of female patients in the patients table.
--Display the two results in the same row.

SELECT 
    SUM(CASE WHEN GENDER = 'M' THEN 1 ELSE 0 END) AS TOTAL_MALE_PATIENTS,
    SUM(CASE WHEN GENDER = 'F' THEN 1 ELSE 0 END) AS TOTAL_FEMALE_PATIENTS
FROM PATIENTS
--OR
SELECT 
  (SELECT COUNT(*) FROM PATIENTS WHERE GENDER='M') AS MALE_COUNT, 
  (SELECT COUNT(*) FROM PATIENTS WHERE GENDER='F') AS FEMALE_COUNT

--7. Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
--Show results ordered ascending by allergies then by first_name then by last_name.

SELECT FIRST_NAME, LAST_NAME, ALLERGIES
FROM
	PATIENTS	
WHERE
	ALLERGIES = 'Penicillin' OR ALLERGIES = 'Morphine'
order by
	ALLERGIES,
    FIRST_NAME,
    LAST_NAME
--OR

--8. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT
	PATIENT_ID, DIAGNOSIS
FROM
	ADMISSIONS
GROUP BY
	PATIENT_ID, DIAGNOSIS
HAVING
	COUNT(*) > 1

--9. Show the city and the total number of patients in the city.
--Order from most to least patients and then by city name ascending.

SELECT
	CITY, COUNT(PATIENT_ID)AS TOTAL_PATIENTS
FROM
	PATIENTS
GROUP BY
	CITY
ORDER BY
	COUNT(PATIENT_ID) DESC,
    CITY ASC

--10. Show first name, last name and role of every person that is either patient or doctor. 
--The roles are either "Patient" or "Doctor"

SELECT FIRST_NAME, LAST_NAME, 'Patient' AS ROLE FROM PATIENTS
UNION ALL
SELECT FIRST_NAME, LAST_NAME, 'Doctor'AS ROLE FROM DOCTORS

--11. Show all allergies ordered by popularity. Remove 'NKA' and NULL values from query.

SELECT
	ALLERGIES, COUNT(ALLERGIES)AS TOTAL_DIAGNOSIS
FROM
	PATIENTS
WHERE
	ALLERGIES IS NOT NULL AND
	ALLERGIES != 'NKA'
GROUP BY
	ALLERGIES
ORDER BY
	COUNT(ALLERGIES) DESC

--12. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
--Sort the list starting from the earliest birth_date.

SELECT
	FIRST_NAME, LAST_NAME, BIRTH_DATE
FROM
	PATIENTS
WHERE
	YEAR(BIRTH_DATE) BETWEEN 1970 AND 1979
ORDER BY
	BIRTH_DATE ASC
--OR
SELECT
  first_name, last_name, birth_date
FROM 
	patients
WHERE
	birth_date >= '1970-01-01' AND 
	birth_date < '1980-01-01'
ORDER BY 
	birth_date ASC


--13. We want to display each patient's full name in a single column. 
--Their last_name in all upper letters must appear first, then first_name in all lower case letters.
--Separate the last_name and first_name with a comma. 
--Order the list by the first_name in decending order EX: SMITH,jane

select
	CONCAT(UPPER(LAST_NAME),',', LOWER(FIRST_NAME))AS FULL_NAME
from
	PATIENTS
order by
	FIRST_NAME DESC

--14. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT
	PROVINCE_ID, SUM(HEIGHT)AS SUM_OF_HEIGHT
FROM
	PATIENTS
group by
	PROVINCE_ID
HAVING
	SUM(HEIGHT) >= 7000

--15. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT
	(MAX(WEIGHT) - MIN(WEIGHT))AS WEIGHT_DIFFERENCE
FROM
	PATIENTS 
WHERE
	LAST_NAME = 'Maroni'

--16. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
--Sort by the day with most admissions to least admissions.

SELECT
	DAY(ADMISSION_DATE)AS DAY_OF_MONTH, COUNT(*)AS TOTAL_ADMISSIONS
FROM
	ADMISSIONS
GROUP BY
	DAY(ADMISSION_DATE)
order by
	TOTAL_ADMISSIONS DESC

--17. Show the all columns for patient_id 542's most recent admission_date.

SELECT TOP(1) *
FROM
	ADMISSIONS
WHERE
	PATIENT_ID = 542
ORDER BY
	ADMISSION_DATE DESC
--OR
SELECT *
FROM ADMISSIONS
WHERE
  PATIENT_ID = '542' AND
  ADMISSION_DATE = (SELECT MAX(ADMISSION_DATE)
					FROM ADMISSIONS
					WHERE PATIENT_ID = '542')

--18. Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT 
	PATIENT_ID, ATTENDING_DOCTOR_ID, DIAGNOSIS
FROM
	ADMISSIONS
WHERE 
    (PATIENT_ID % 2 != 0 AND ATTENDING_DOCTOR_ID IN (1, 5, 19)) 
	OR
	(CAST(ATTENDING_DOCTOR_ID AS VARCHAR) LIKE '%2%' AND LEN(CAST(PATIENT_ID AS VARCHAR)) = 3)

--19. Show first_name, last_name, and the total number of admissions attended for each doctor.
--Every admission has been attended by a doctor.

SELECT
	D.FIRST_NAME, D.LAST_NAME, COUNT(D.DOCTOR_ID)TOTAL_ADMISSIONS
FROM
	DOCTORS D
INNER JOIN
	ADMISSIONS A
ON
	D.DOCTOR_ID = A.ATTENDING_DOCTOR_ID
GROUP BY
	D.FIRST_NAME, D.LAST_NAME, D.DOCTOR_ID

--20. For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT
	D.DOCTOR_ID, CONCAT(D.FIRST_NAME,' ', D.LAST_NAME)AS FULL_NAME,
    MIN(A.ADMISSION_DATE)AS FIRST_ADMISSION_DATE, MAX(A.ADMISSION_DATE)AS LAST_ADMISSION_DATE
FROM
	DOCTORS D
INNER JOIN
	ADMISSIONS A
ON
	D.DOCTOR_ID = A.ATTENDING_DOCTOR_ID
GROUP BY
	D.DOCTOR_ID, D.FIRST_NAME, D.LAST_NAME
ORDER BY
	D.DOCTOR_ID

--21. Display the total amount of patients for each province. Order by descending.

SELECT
	PN.PROVINCE_NAME, COUNT(P.PATIENT_ID)AS TOTAL_PATIENT
FROM
	PROVINCE_NAMES PN
INNER JOIN
	PATIENTS P
ON
	PN.PROVINCE_ID = P.PROVINCE_ID
group by
	PN.PROVINCE_NAME
ORDER BY
	TOTAL_PATIENT DESC

--22. For every admission, display the patient's full name, their admission diagnosis, 
--and their doctor's full name who diagnosed their problem.

SELECT
	CONCAT(P.FIRST_NAME,' ', P.LAST_NAME)AS PATIENT_FULL_NAME, A.DIAGNOSIS,
    CONCAT(D.FIRST_NAME,' ', D.LAST_NAME)AS DOCTOR_FULL_NAME
FROM
	PATIENTS P
INNER JOIN
	ADMISSIONS A
ON
	P.PATIENT_ID = A.PATIENT_ID
INNER JOIN
	DOCTORS D
ON
	A.ATTENDING_DOCTOR_ID = D.DOCTOR_ID


--23. display the first name, last name and number of duplicate patients based on their first name and last name.

SELECT
	FIRST_NAME, LAST_NAME, COUNT(*)AS DUPLICATE
FROM
	PATIENTS
GROUP BY
	FIRST_NAME, LAST_NAME
HAVING
	COUNT(*) > 1

--24. Display patient's full name,
--height in the unit feet rounded to 1 decimal,
--weight in the unit pounds rounded to 0 decimals,
--birth_date,
--gender non abbreviated.
--Convert CM to feet by dividing by 30.48.
--Convert KG to pounds by multiplying by 2.205.

SELECT 
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,
    CAST(ROUND(HEIGHT / 30.48, 1)AS DECIMAL(4, 1)) AS HEIGHT_FEET,
    CAST(ROUND(WEIGHT * 2.205, 0)AS INT) AS WEIGHT_POUNDS,
    BIRTH_DATE,
    CASE 
        WHEN GENDER = 'M' THEN 'MALE'
        WHEN GENDER = 'F' THEN 'FEMALE'
        ELSE GENDER 
    END AS GENDER
FROM PATIENTS

--25. Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
--(Their patient_id does not exist in any admissions.patient_id rows.)

SELECT PATIENT_ID, FIRST_NAME, LAST_NAME
FROM PATIENTS P
WHERE NOT EXISTS 
			(SELECT 1 
				FROM ADMISSIONS A 
				WHERE A.PATIENT_ID = P.PATIENT_ID)
--OR
SELECT
	P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME
FROM 
	PATIENTS P
LEFT JOIN
	ADMISSIONS A
ON
	P.PATIENT_ID = A.PATIENT_ID
WHERE
	A.PATIENT_ID IS NULL

--26. Display a single row with max_visits, min_visits, average_visits
--where the maximum, minimum and average number of admissions per day is calculated. 
--Average is rounded to 2 decimal places.

;WITH DAILYADMISSIONS AS (
    SELECT 
		COUNT(*) AS DAILY_VISITS
    FROM
		ADMISSIONS
    GROUP BY 
		ADMISSION_DATE
)
SELECT 
    MAX(DAILY_VISITS) AS MAX_VISITS,
    MIN(DAILY_VISITS) AS MIN_VISITS,
    CAST(ROUND(AVG(CAST(DAILY_VISITS AS DECIMAL(10,2))), 2) AS DECIMAL(4,2)) AS AVERAGE_VISITS
FROM 
	DAILYADMISSIONS

--27. Display every patient that has at least one admission and show their most recent admission 
--along with the patient and doctor's full name.

;WITH 
	RANKED_ADMISSIONS AS (
    SELECT 
        CONCAT(P.FIRST_NAME, ' ', P.LAST_NAME) AS PATIENT_NAME,
  		A.ADMISSION_DATE,
        CONCAT(D.FIRST_NAME, ' ', D.LAST_NAME) AS DOCTOR_NAME,
        ROW_NUMBER() OVER(PARTITION BY A.PATIENT_ID ORDER BY A.ADMISSION_DATE DESC) AS ROW_NUM
    FROM ADMISSIONS A
    INNER JOIN PATIENTS P ON A.PATIENT_ID = P.PATIENT_ID
    INNER JOIN DOCTORS D ON A.ATTENDING_DOCTOR_ID = D.DOCTOR_ID
)
SELECT 
    PATIENT_NAME, ADMISSION_DATE, DOCTOR_NAME
FROM 
	RANKED_ADMISSIONS
WHERE
	ROW_NUM = 1