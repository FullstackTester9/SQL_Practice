USE HOSPITAL

--1. Show all of the patients grouped into weight groups.
--Show the total amount of patients in each weight group.
--Order the list by the weight group decending.
--For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT 
    (WEIGHT / 10) * 10 AS WEIGHT_GROUP,
    COUNT(*) AS TOTAL_PATIENTS
FROM 
    PATIENTS
GROUP BY 
    (WEIGHT / 10) * 10
ORDER BY 
    WEIGHT_GROUP DESC
--OR
SELECT
  COUNT(PATIENT_ID)AS TOTAL_PATIENTS,
  WEIGHT - WEIGHT % 10 AS WEIGHT_GROUP
FROM 
	PATIENTS
GROUP BY
	WEIGHT - WEIGHT % 10
ORDER BY
	WEIGHT_GROUP DESC

--2. Show patient_id, weight, height, isObese from the patients table.
--Display isObese as a boolean 0 or 1.
--Obese is defined as weight(kg)/(height(m)2) >= 30.
--weight is in units kg.
--height is in units cm.

SELECT 
    PATIENT_ID, WEIGHT, HEIGHT,
    CASE 
        WHEN WEIGHT / SQUARE(HEIGHT / 100.0) >= 30 THEN 1
        ELSE 0
    END AS ISOBESE
FROM 
    PATIENTS

--3. Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Dementia' and the doctor's first name is 'Lisa'
--Check patients, admissions, and doctors tables for required information.

SELECT 
    P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME, D.SPECIALITY
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
WHERE
	A.DIAGNOSIS = 'Epilepsy' AND
    D.FIRST_NAME = 'Lisa'
--OR

;WITH PATIENT_TABLE AS 
	(SELECT
		PATIENTS.PATIENT_ID, PATIENTS.FIRST_NAME, PATIENTS.LAST_NAME, ADMISSIONS.ATTENDING_DOCTOR_ID
	FROM 
		PATIENTS
    INNER JOIN
		ADMISSIONS
	ON
		PATIENTS.PATIENT_ID = ADMISSIONS.PATIENT_ID
    WHERE
		ADMISSIONS.DIAGNOSIS = 'EPILEPSY')
SELECT
  PATIENT_TABLE.PATIENT_ID, PATIENT_TABLE.FIRST_NAME, PATIENT_TABLE.LAST_NAME, DOCTORS.SPECIALITY
FROM 
	PATIENT_TABLE
INNER JOIN
	DOCTORS
ON
	PATIENT_TABLE.ATTENDING_DOCTOR_ID = DOCTORS.DOCTOR_ID
WHERE
	DOCTORS.FIRST_NAME = 'LISA'


--4. All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
--The password must be the following, in order:
--1. patient_id
--2. the numerical length of patient's last_name
--3. year of patient's birth_date

SELECT 
    P.PATIENT_ID, 
	CONCAT(P.PATIENT_ID,'',LEN(P.LAST_NAME),'',YEAR(P.BIRTH_DATE))AS TEMP_PASSWORD
FROM 
    PATIENTS P
INNER JOIN
	ADMISSIONS A
ON
	P.PATIENT_ID = A.PATIENT_ID
GROUP BY
	P.PATIENT_ID, P.LAST_NAME, P.BIRTH_DATE
ORDER BY
	P.PATIENT_ID

--5. Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
--All patients with an even patient_id have insurance.
--Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance.
--Add up the admission_total cost for each has_insurance group.

SELECT
	(CASE WHEN PATIENT_ID%2=0 THEN 'YES' ELSE 'NO' END)AS HAS_INSURANCE,
    SUM(CASE WHEN PATIENT_ID%2=0 THEN 10 ELSE 50 END)AS COST_AFTER_INSURANCE
FROM
	ADMISSIONS
GROUP BY
	(CASE WHEN PATIENT_ID%2=0 THEN 'YES' ELSE 'NO' END)

--6. Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

SELECT
	PN.PROVINCE_NAME
FROM
	PROVINCE_NAMES PN
INNER JOIN
	PATIENTS P
ON
	PN.PROVINCE_ID = P.PROVINCE_ID
GROUP BY
	PN.PROVINCE_NAME
HAVING
	SUM(CASE WHEN P.GENDER = 'M' THEN 1 ELSE 0 END) >
    SUM(CASE WHEN P.GENDER = 'F' THEN 1 ELSE 0 END) 

--7. We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'

SELECT *
FROM
	PATIENTS
WHERE
	PATIENT_ID % 2 != 0 AND
    FIRST_NAME LIKE '__r%' AND
    GENDER = 'F' AND
    MONTH(BIRTH_DATE) IN (2, 5, 12) AND
    (WEIGHT >= 60 AND WEIGHT <=80) AND
    CITY = 'Kingston'

--8. Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT 
    CONCAT(CAST(ROUND(SUM(CASE WHEN GENDER = 'M' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS DECIMAL(5,2)),'%') AS MALE_PERCENTAGE
FROM 
    PATIENTS

--9. For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

SELECT
	ADMISSION_DATE,
	COUNT(ADMISSION_DATE) AS ADMISSION_DAY,
	COUNT(ADMISSION_DATE) - LAG(COUNT(ADMISSION_DATE)) OVER(ORDER BY ADMISSION_DATE) AS ADMISSION_COUNT_CHANGE 
FROM
	ADMISSIONS
GROUP BY
	ADMISSION_DATE

--OR

;WITH DAILYADMISSIONS AS (
    SELECT 
        ADMISSION_DATE,
        COUNT(PATIENT_ID) AS TOTAL_ADMISSIONS
    FROM 
        ADMISSIONS
    GROUP BY 
        ADMISSION_DATE
)
SELECT 
    ADMISSION_DATE,
    TOTAL_ADMISSIONS,
    TOTAL_ADMISSIONS - LAG(TOTAL_ADMISSIONS, 1) OVER (ORDER BY ADMISSION_DATE) AS AMOUNT_CHANGED
FROM 
    DAILYADMISSIONS
ORDER BY 
    ADMISSION_DATE

--10. Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

SELECT 
    PROVINCE_NAME
FROM 
    PROVINCE_NAMES
ORDER BY 
    CASE WHEN PROVINCE_NAME = 'ONTARIO' THEN 0 ELSE 1 END, 
    PROVINCE_NAME ASC

--11. We need a breakdown for the total amount of admissions each doctor has started each year. 
--Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

SELECT
	D.DOCTOR_ID, CONCAT(D.FIRST_NAME,' ', D.LAST_NAME)AS DOCTOR_NAME,
    D.SPECIALITY, YEAR(A.ADMISSION_DATE)AS SELECTED_YEAR,
    COUNT(A.PATIENT_ID)AS TOTAL_ADMISSIONS
FROM
	DOCTORS D
INNER JOIN
	ADMISSIONS A
ON
	D.DOCTOR_ID = A.ATTENDING_DOCTOR_ID
GROUP BY
	D.DOCTOR_ID, CONCAT(D.FIRST_NAME,' ', D.LAST_NAME), D.SPECIALITY, YEAR(A.ADMISSION_DATE)
ORDER BY
	D.DOCTOR_ID