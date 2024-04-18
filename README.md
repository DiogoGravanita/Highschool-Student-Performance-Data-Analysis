# Highschool Student Performance Data Analysis (Microsoft SQL Server + PowerBI)


## Introduction:

This project aims to analyze and visualize diverse high school student data using Power BI. The dataset includes various demographic factors, academic metrics, and lifestyle variables, providing valuable insights into the factors influencing student performance.


<br/><br/>

## Project Overview

### Data Source

The data set was downloaded from the following website: https://www.kaggle.com/datasets/dillonmyrick/high-school-student-performance-and-demographics?resource=download . The file will be added as "space_missions.csv". 

### Objectives

 1. Data Exploration: Dive deep into the dataset to understand the demographics, academic metrics, and lifestyle factors of high school students.

 2. Interactive Dashboards: Create interactive dashboards and reports to visualize key insights and trends in student performance.

 3. Statistical Analysis: Conduct statistical analysis to identify correlations and relationships between various factors and academic outcomes.

<br/><br/>



## Charts and Visualizations:

We'll create a variety of charts and visualizations to present the data effectively:



1. Area Chart of Average Grades by Study Time: Visualizes the average grades achieved by students based on their weekly study time.
2. Stacked Column Chart of Count of Family Relationship Level: Displays the distribution of family relationship levels among students using a stacked column chart.
3. Scatter Plot of Grades by Family Support and Absences: Shows the relationship between student grades and absences, with their level of family support as an additional factor.
4. Pie Chart with Student Health Percentages: Illustrates the distribution of student health statuses using a pie chart.
5. Bar Charts of Average Grades by Family Size, Father's Job, and Parents' Education: Provides separate bar charts to compare average grades based on family size, father's job, and parents' education levels.
6. Pie Chart of Different Guardian Percentages: Represents the percentage distribution of different guardians among students using a pie chart.
7. Bar Chart of Count of Each Address Type (Rural or Urban): Displays the count of students from rural and urban areas using a bar chart.
8. Column Chart of Average Grades by Internet Access: Shows the average grades achieved by students based on their access to the internet at home.
9. Area Chart of Average Grades by Travel Time: Visualizes the relationship between student grades and travel time to school using an area chart.
10. Pie Chart of Free Time: Illustrates the distribution of free time after school among students using a pie chart.
11. 4 Tables representative of Student grades categorized by the respective metrics of each page. 




<br/><br/>

<br/><br/>

## Tools and Technologies:

 - Microsoft SQL Server Management Studio for data manipulation and analysis.
 - PowerBI for data visualization and statistical analysis.
 - Obsidian for documentation purposes.

<br/><br/>

## Attribute explanation for the Columns in the Table for better understanding: 

school - student's school (binary: "GP" - Gabriel Pereira or "MS" - Mousinho da Silveira)
sex - student's sex (binary: "F" - female or "M" - male)
age - student's age (numeric: from 15 to 22)
address_type - student's home address type (binary: "Urban" or "Rural")
family_size - family size (binary: "Less or equal to 3" or "Greater than 3")
parent_status - parent's cohabitation status (binary: "Living together" or "Apart")
mother_education - mother's education (ordinal: "none", "primary education (4th grade)", "5th to 9th grade", "secondary education" or "higher education")
father_education - father's education (ordinal: "none", "primary education (4th grade)", "5th to 9th grade", "secondary education" or "higher education")
mother_job - mother's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
father_job - father's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
reason - reason to choose this school (nominal: close to "home", school "reputation", "course" preference or "other")
guardian - student's guardian (nominal: "mother", "father" or "other")
travel_time - home to school travel time (ordinal: "<15 min.", "15 to 30 min.", "30 min. to 1 hour", or 4 - ">1 hour")
study_time - weekly study time (ordinal: 1 - "<2 hours", "2 to 5 hours", "5 to 10 hours", or ">10 hours")
class_failures - number of past class failures (numeric: n if 1<=n<3, else 4)
school_support - extra educational support (binary: yes or no)
family_support - family educational support (binary: yes or no)
extra_paid_classes - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no)
activities - extra-curricular activities (binary: yes or no)
nursery - attended nursery school (binary: yes or no)
higher_ed - wants to take higher education (binary: yes or no)
internet - Internet access at home (binary: yes or no)
romantic_relationship - with a romantic relationship (binary: yes or no)
family_relationship - quality of family relationships (numeric: from 1 - very bad to 5 - excellent)
free_time - free time after school (numeric: from 1 - very low to 5 - very high)
social - going out with friends (numeric: from 1 - very low to 5 - very high)
weekday_alcohol - workday alcohol consumption (numeric: from 1 - very low to 5 - very high)
weekend_alcohol - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high)
health - current health status (numeric: from 1 - very bad to 5 - very good)
absences - number of school absences (numeric: from 0 to 93)


<br/><br/>

# SQL Data Analysis:
<br/><br/>



## Socio-demographic Exploration:


<br/><br/>


### Effect of parental cohabitation on grades

```sql
Select parent_status, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by parent_status
```

<br/><br/>

### Percentage of different parental cohabitation stats

```sql
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
```

<br/><br/>

### Rural vs urban address types average performance (casted as float to get decimal numbers)

```sql
Select address_type, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by address_type
```

<br/><br/>

### Distribution of internet access based on Address type

```sql
SELECT address_type, COUNT(*) AS total_amount, SUM(CASE WHEN internet_access = 1 THEN 1 ELSE 0 END) AS with_internet_access
FROM 
    Math
GROUP BY 
    address_type
```

<br/><br/>

### Average final grade based on the guardian

```sql
Select guardian, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by guardian
```

<br/><br/>

### Travel time based on the Address type (since the data isn't clear I created a middle ground for each entry, however the results will obviously not be very accurate)

```sql
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
```

Another method of comparison:

```sql
select address_type, travel_time, count(travel_time)
from Math
Group by address_type, travel_time
Order by address_type
```

<br/><br/>

### Larger families vs smaller families average performance

```sql
Select family_size, ROUND(AVG(CAST(final_grade as float)),3) as Average_grade
From Math
Group by family_size
```

<br/><br/>

## Education and Parental Background:

<br/><br/>

### Education levels of parents comparison analysis

```sql

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

```

<br/><br/>

### Dividing the Location column:

```sql

```

<br/><br/>

### Dividing the Location column:

```sql

```

<br/><br/>

### Dividing the Location column:

```sql

```

<br/><br/>

### Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>

## Dividing the Location column:

```sql

```

<br/><br/>


<br/><br/>

## Power BI Enhancements:



<br/><br/>

## Data visualization:

### Summary of Dashboard Insights




<br/><br/>

<br/><br/>

<br/><br/>


## Dashboard image:
<br/><br/>

<br/><br/>

<br/><br/>


<br/><br/>
<br/><br/>
# Results/findings
<br/><br/>


## Key Performance Indicators (KPIs)




1. Total Missions: 5000
2. Mission Success Rate: 89,89%
3. Average Mission Cost: 128.3 Million €
4. Countries Involved: 22


<br/><br/>


## Charts and Visualizations Findings:

<br/><br/>
### Mission Amount by Rocket/Country/Company/Year:



<br/><br/>

### Average Price by Company:



<br/><br/>

### Missions by Year:



<br/><br/>

### Successful Missions by Country/Launch Center/Company:


<br/><br/>

### Success Rate by Country:



<br/><br/>

### Mission Status Percentage:



<br/><br/>

### Average Price by Country/Rocket/Company:


<br/><br/>

### Total Cost by Year:


<br/><br/>

### Mission by Rocket Status:



<br/><br/>

## Conclusion:
