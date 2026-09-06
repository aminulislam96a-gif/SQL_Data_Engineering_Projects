--Array Intro
SELECT ['Python','Sql','java'] as list_of_array;

SELECT UNNEST(['Python','Sql','java']);

WITH skills as (
    SELECT 'Python' as skill
    UNION ALL 
    SELECT 'SQL'
    UNION ALL 
    SELECT 'JAVA'
),
 array_of_skill AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills_array
    FROM skills
 )
SELECT 
    skills_array[1] AS first_skill,
    skills_array[2] AS Second_skill,
    skills_array[3] AS third_skill
FROM array_of_skill;

--Structs Intro

SELECT {name:'Amin', age:26, active:true} as List_Structs;

WITH info_stucts as (
SELECT 'Amin' AS user_name, 26 as user_age
UNION ALL
SELECT 'Bob', 28
UNION ALL
SELECT 'DAVE', 31
    )

informtions as (
    SELECT 
    STRUCT_PACK(
        name:= user_name,
        age:= user_age
    )as struct_info
    FROM info_stucts
)
;

--Array of Structs

SELECT [
    {name:'Amin', age:26, active_status:true},
    {name:'Amin', age:26, active_status:true}
]AS info_array_structs;

-- Final Example of Array of struct 

WITH array_struct_info AS (
    SELECT 'Amin' as user_name, 26 as user_age , true as active_status
    UNION ALL
    SELECT 'DAVE' , 26, TRUE 
    UNION ALL
    SELECT 'mike' , 32, FALSE
),
 array_information as (
    SELECT
    ARRAY_AGG (STRUCT_PACK( 
    name:= user_name,
    age:= user_age,
    status:= active_status
    )
     ORDER by user_name
 )AS user_information
 FROM array_struct_info
 )

 SELECT
    user_information[1] AS first_user_info,
    user_information[2] AS second_user_info,
    user_information[3] AS third_user_info
 FROM array_information;

 -- Map Function 
WITH user_map AS (
    SELECT MAP { 'name' : 'Amin', 'name1' : 'Dave'} as user_info
)
SELECT
    user_info['name']
FROM user_map;

--JSON(Javascript Object notation) Function
WITH initial_user as (
SELECT 
'[
    {"user_name": "Amin", "user_age": 26, "user_status": true},
    {"user_name": "Dave", "user_age": 28, "user_status": false}, 
    {"user_name": "Mike", "user_age": 31, "user_status": true}
]':: JSON AS user_info
)

SELECT 
   ARRAY_AGG(
        STRUCT_PACK(
            name:= json_extract_string(ui.value,'$.user_name'),
            age:= json_extract_string(ui.value, '$.user_age'):: INTEGER,
            status:= json_extract_string(ui.value, '$.user_status'):: BOOLEAN
        )
        ORDER by json_extract_string(ui.value,'$.user_name')
   ) AS User
 FROM initial_user, json_each(user_info) AS ui;

 --Array - Final Example 
 --Build a flat table for co-worker to access job titles, salary info, and skills in one table.

CREATE OR REPLACE TEMP table skills_flat as
 SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim as sd
ON sd.skill_id = sjd.skill_id
 GROUP BY ALL;

 SELECT 
    * 
FROM skills_flat;

--From the perspective of Data Analyst, Analyze the median salary per skill.
with cleaned_median_salary as(
SELECT
    job_id,
    job_title_short,
    unnest(skills) as skills,
    salary_year_avg,
FROM skills_flat
where salary_year_avg is not null
)
SELECT
    job_id,
    job_title_short,
    skills,
    salary_year_avg,
median(salary_year_avg) OVER(
        PARTITION BY skills
    )as madian_salry_skills
from cleaned_median_salary;

--Array of Stucts - Final Example 
--Build a flat skill & type for co-worker to acess job titles, salary info, skills, type in one table .
CREATE OR REPLACE TEMP table skills_and_type_flat as
 SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill:= sd.skills,
            type:= sd.type)
    ) AS skill_information
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim as sd
ON sd.skill_id = sjd.skill_id
 GROUP BY ALL;

 SELECT 
    * 
FROM skills_and_type_flat;


with unnest_skill_type as (
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skill_information) as skills_info
FROM skills_and_type_flat
where salary_year_avg is not null
)

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    skills_info.skill as skill,
    skills_info.type as type
FROM unnest_skill_type ;
