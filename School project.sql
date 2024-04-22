select *
from Math




-- check every column in the data set

SELECT column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Math'







---- Socio-demographic Exploration:





-- Effect of parental cohabitation on grades

Select parent_status, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by parent_status


-- Percentage of different parental cohabitation

WITH parent_status_counts AS (
    SELECT parent_status, COUNT(*) AS Total_count,(COUNT(*) / CAST((SELECT COUNT(*) FROM Math) AS float)) * 100 AS Percentage
    FROM 
        Math
    GROUP BY 
        parent_status
)
SELECT parent_status, Total_count,ROUND(Percentage, 2) AS Percentage
FROM 
    parent_status_counts
ORDER BY
    parent_status



-- Rural vs urban address types average performance (casted as float to get decimal numbers)


Select address_type, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by address_type


-- Distribution of internet access based on Address type

SELECT address_type, COUNT(*) AS total_amount, SUM(CASE WHEN internet_access = 1 THEN 1 ELSE 0 END) AS with_internet_access
FROM 
    Math
GROUP BY 
    address_type


-- Average final grade based on the guardian


Select guardian, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by guardian



-- Travel time based on the Address type (since the data isn't clear I created a middle ground for each entry, however the results will obviously not be very accurate)


Select address_type, 
					ROUND(SUM(CASE 
							WHEN travel_time = '<15 min.' THEN 7
							WHEN travel_time = '15 to 30 min.' THEN 22.5
							WHEN travel_time = '30 min. to 1 hour' THEN 45
							WHEN travel_time = '>1 hour' THEN 75 
							ELSE 0
						END)/ COUNT(*), 2) AS average_travel_time
From Math
Group by address_type


--- Another method of comparison ---

select address_type, travel_time, count(travel_time)
from Math
Group by address_type, travel_time
Order by address_type



-- Larger families vs smaller families average performance


Select family_size, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by family_size










---- Education and Parental Background:



-- Education levels of parents comparison analysis


WITH subquery AS (
    SELECT mother_job AS job_type, 'mother' AS parent_type FROM Math
    UNION ALL
    SELECT father_job AS job_type, 'father' AS parent_type FROM Math
) 

SELECT 
    job_type,
    COUNT(CASE WHEN parent_type = 'mother' THEN 1 END) AS mother_job_count,
    COUNT(CASE WHEN parent_type = 'father' THEN 1 END) AS father_job_count,
    ROUND((COUNT(CASE WHEN parent_type = 'mother' THEN 1 END) / CAST(COUNT(*) AS float) * 100), 2) AS mother_job_percentage,
    ROUND((COUNT(CASE WHEN parent_type = 'father' THEN 1 END) / CAST(COUNT(*) AS float) * 100), 2) AS father_job_percentage
FROM subquery
GROUP BY job_type;



-- Academic Performance based on Parents' education (excluding none as not enough data to reach a conclusion)


Select mother_education, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by mother_education
Having mother_education != 'none'



Select father_education, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by father_education
Having father_education != 'none'



-- Percentage of students who want to pursue higher education based on their parents' education. (excluding none as not enough data to reach a conclusion)


Select mother_education, ROUND(CAST(SUM(CASE WHEN higher_ed = 1 THEN 1 ELSE 0 END) as FLOAT)/ count(*),2) as higher_ed_percentage
From Math
Group by mother_education
Having mother_education != 'none'



Select father_education, ROUND(CAST(SUM(CASE WHEN higher_ed = 1 THEN 1 ELSE 0 END) as FLOAT)/ count(*),2) as higher_ed_percentage
From Math
Group by father_education
Having father_education != 'none'




-- Guardian's identity impact on performance

Select guardian, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by guardian


-- Correlation between family support and Average Final grade


Select CASE WHEN family_support = 0 THEN 'Has support' ELSE 'No support' END AS Family_Support, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by Family_support




-- Relationship between parents' education and School choice reason


--- Mother

SELECT mother_education,
    SUM(CASE WHEN school_choice_reason = 'home' THEN 1 ELSE 0 END) AS close_to_home,
    SUM(CASE WHEN school_choice_reason = 'reputation' THEN 1 ELSE 0 END) AS school_reputation,
    SUM(CASE WHEN school_choice_reason = 'course' THEN 1 ELSE 0 END) AS course_preference,
    SUM(CASE WHEN school_choice_reason = 'other' THEN 1 ELSE 0 END) AS other
FROM Math
GROUP BY mother_education
HAVING mother_education != 'none'
ORDER BY mother_education


--- Father

SELECT father_education,
    SUM(CASE WHEN school_choice_reason = 'home' THEN 1 ELSE 0 END) AS close_to_home,
    SUM(CASE WHEN school_choice_reason = 'reputation' THEN 1 ELSE 0 END) AS school_reputation,
    SUM(CASE WHEN school_choice_reason = 'course' THEN 1 ELSE 0 END) AS course_preference,
    SUM(CASE WHEN school_choice_reason = 'other' THEN 1 ELSE 0 END) AS other
FROM Math
GROUP BY father_education
HAVING father_education != 'none'
ORDER BY father_education








---- Health and Lifestyle Factors:



-- Relationship between study time and academic performance


Select study_time, ROUND(AVG(CAST(final_grade as float)),2) as Average_grade
From Math
Group by study_time



-- Relationship between weekday alcohol consumption and academic performance


Select CASE 
			WHEN weekday_alcohol = 1 THEN 'very low'
			WHEN weekday_alcohol = 2 THEN 'low'
			WHEN weekday_alcohol = 3 THEN 'medium'
			WHEN weekday_alcohol = 4 THEN 'high'
			WHEN weekday_alcohol = 5 THEN 'very high'
			ELSE 'unknown' END AS Alcohol_consumption
		,ROUND(AVG(CAST(final_grade as float)),2)
From Math
Group by weekday_alcohol



-- Correlation between study time and weekday alcohol consumption


Select study_time, ROUND(CAST(SUM(weekday_alcohol) as float)/count(*),2) as Alcohol_frequency
From Math
Group by study_time



-- Relationship between health status and involvement in extracurricular activities


Select CASE WHEN activities = 0 THEN 'yes' ELSE 'no' END AS Activities, ROUND(CAST(SUM(health) as float)/count(*),2) as Average_health
From Math
Group by activities



-- Average free time in comparison to study time:


Select study_time, ROUND(CAST(SUM(free_time) as float)/count(*),2) as Free_time_average
From Math
Group by study_time



-- Relationship between weekday alcohol and Class_failures


Select CASE 
			WHEN weekday_alcohol = 1 THEN 'very low'
			WHEN weekday_alcohol = 2 THEN 'low'
			WHEN weekday_alcohol = 3 THEN 'medium'
			WHEN weekday_alcohol = 4 THEN 'high'
			WHEN weekday_alcohol = 5 THEN 'very high'
			ELSE 'unknown' END AS Alcohol_consumption, 
			ROUND(AVG(CAST(class_failures as float)),2) as Average_class_failures
From Math
GROUP by weekday_alcohol








---- General Academic Performance:



-- Relationship between absences and final grades



Select CASE 
			WHEN absences < 5 THEN  'very low'
			WHEN absences < 10 THEN 'low'
			WHEN absences < 15 THEN 'medium'
			WHEN absences < 25 THEN 'high'
			WHEN absences >= 25 THEN 'very high'
			Else 'uknown' END as Absence,
			ROUND(AVG(CAST(final_grade as float)),2) as average_grade
From Math
Group by CASE 
			WHEN absences < 5 THEN  'very low'
			WHEN absences < 10 THEN 'low'
			WHEN absences < 15 THEN 'medium'
			WHEN absences < 25 THEN 'high'
			WHEN absences >= 25 THEN 'very high'
			Else 'uknown' END 

		

-- Comparison of Grades by Gender


Select CASE WHEN sex = 'F' THEN 'Female' ELSE 'Male' END as Gender, ROUND(AVG(CAST(final_grade as float)),2) as average_grade
From Math
Group by sex


-- Impact of school support on grades


Select CASE WHEN school_support = 0 THEN 'No support' ELSE 'Support' END as School_Support, ROUND(AVG(CAST(final_grade as float)),2) as average_grade
From Math
Group by school_support



-- Relationship between Class Failures and Final Grades


Select class_failures, ROUND(AVG(CAST(final_grade as float)),2) as average_grade
From Math
Group by class_failures



-- Student Performance over the quarters


Select ROUND(AVG(CAST(grade_1 as float)),2) as First_Quarter, ROUND(AVG(CAST(grade_2 as float)),2) as Second_Quarter, ROUND(AVG(CAST(final_grade as float)),2) as Final_Grade
From Math




-- Student performance over the quarters related to the absences


Select CASE 
			WHEN absences < 5 THEN  'very low'
			WHEN absences < 10 THEN 'low'
			WHEN absences < 15 THEN 'medium'
			WHEN absences < 25 THEN 'high'
			WHEN absences >= 25 THEN 'very high'
			Else 'uknown' END as Absence, 
			ROUND(AVG(CAST(grade_1 as float)),2) as First_Quarter, ROUND(AVG(CAST(grade_2 as float)),2) as Second_Quarter, ROUND(AVG(CAST(final_grade as float)),2) as Final_Grade, COUNT(*) as Student_Number
From Math
GROUP BY CASE 
			WHEN absences < 5 THEN  'very low'
			WHEN absences < 10 THEN 'low'
			WHEN absences < 15 THEN 'medium'
			WHEN absences < 25 THEN 'high'
			WHEN absences >= 25 THEN 'very high'
			Else 'uknown' END








Select DISTINCT(final_grade)
from Math

























































































