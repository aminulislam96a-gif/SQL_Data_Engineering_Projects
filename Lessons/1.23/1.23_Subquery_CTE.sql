SELECT *
FROM (
    SELECT *
    FROM staging.job_postings_flat
    WHERE salary_year_avg IS NOT NULL
    LIMIT 15
)AS valid_salaries;

WITH valid_salaries as (
    SELECT *
    FROM staging.job_postings_flat
    WHERE salary_year_avg IS NOT NULL
    LIMIT 15
)
SELECT * 
FROM valid_salaries;

--Show only job's salary next to the overall median:

SELECT 
    job_title_short,
    salary_year_avg,
    (
    SELECT
        MEDIAN(salary_year_avg) 
    FROM staging.job_postings_flat
    WHERE salary_year_avg IS NOT NULL 
    )as overall_median_salaries
 
FROM staging.job_postings_flat
WHERE salary_year_avg is not null
LIMIT 10;

--Stage only jobs that are remote before aggregting with overall median salalry.
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) as madian_salary,
    (
        SELECT
        MEDIAN(salary_year_avg) 
        FROM staging.job_postings_flat
        where job_work_from_home = true and salary_year_avg is not null
    ) as Before_aggregating_madian_salary
FROM
    staging.job_postings_flat
where job_work_from_home = true
GROUP by job_title_short;

--Keep only job title whose median salary is above the overall median.
SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) as madian_salary
FROM
staging.job_postings_flat
where salary_year_avg is not null
GROUP by job_title_short
having MEDIAN(salary_year_avg)> (SELECT
        MEDIAN(salary_year_avg)
        FROM staging.job_postings_flat
        where salary_year_avg is not null);

-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
--Use a CTE to calculate the median salary by title and work arrangment , then compare those medians.

with madian_salary as (SELECT 
job_title_short,
MEDIAN(salary_year_avg) :: int as madian_salary,
job_work_from_home
FROM staging.job_postings_flat
WHERE salary_year_avg IS NOT NULL
GROUP by job_title_short,
        job_work_from_home
)

SELECT 
remote.job_title_short,
remote.madian_salary as remote_salary,
onsite.madian_salary as onsite_salary,
remote.madian_salary-onsite.madian_salary as deference_salary
FROM madian_salary as remote
INNER JOIN madian_salary as onsite
ON remote.job_title_short = onsite.job_title_short
WHERE remote.job_work_from_home = TRUE AND onsite.job_work_from_home = FALSE
ORDER BY deference_salary DESC ;



SELECT *
FROM  RANGE(3)AS src (key);

SELECT *
FROM RANGE (4) AS tgt(key);

SELECT *
FROM  RANGE(4)AS src (key)
WHERE NOT EXISTS(
    FROM RANGE (3) AS tgt(key)
    WHERE tgt.key = src.key
);

--Identify job postings that have no associated skills before loading them into a data mart.
SELECT
jpf.job_id,
jpf.job_title_short
FROM data_jobs.job_postings_fact AS jpf
 WHERE NOT EXISTS (
    SELECT 1
    FROM data_jobs.skills_job_dim as sjd 
    where jpf.job_id = sjd.job_id
    ORDER BY job_id
);
--Show each job_title_short with its median salary. Return only job titles whose median salary is higher than the median salary of all jobs.
    WITH madian_salary as (
        SELECT 
            job_title_short,
            MEDIAN(salary_year_avg) as madian_salary
            FROM staging.job_postings_flat
            where salary_year_avg is not null
            GROUP BY job_title_short
    )

    SELECT 
    job_title_short,
    madian_salary
    FROM madian_salary
    WHERE  madian_salary>(
        SELECT MEDIAN(salary_year_avg)
        FROM staging.job_postings_flat
        where salary_year_avg is not null  
    )
ORDER by  madian_salary DESC ;

-- Write a SQL query to return each job_title_short and its average salary_year_avg.

-- Only return job titles where the average salary is higher than the overall average salary across all job postings.

-- Exclude rows where salary_year_avg is NULL.

with average_salary as (SELECT 
    job_title_short,
    avg(salary_year_avg) :: int as average_year_salary
    FROM staging.job_postings_flat
    where salary_year_avg is not null
    GROUP by job_title_short
)

    SELECT 
        job_title_short,
        average_year_salary
     FROM average_salary
     where average_year_salary> (
        SELECT
        avg(salary_year_avg)
        FROM staging.job_postings_flat
        WHERE salary_year_avg is not null
     );

-- Write a SQL query to return each company_id and its total number of job postings, but only include companies
--  whose number of postings is greater than the average number of postings across all companies.

with total_jobs as (SELECT 
    company_name,
    COUNT(job_id) as number_of_jobs
FROM staging.job_postings_flat
  GROUP BY company_name
)

SELECT 
    company_name,
  number_of_jobs
    FROM total_jobs
    where number_of_jobs>(
        SELECT 
        AVG(number_of_jobs)
        FROM total_jobs
    )
ORDER BY number_of_jobs DESC ;

SELECT *
FROM (
    SELECT
        company_name,
        COUNT(*) AS number_of_jobs
    FROM staging.job_postings_flat
    GROUP BY company_name
) AS company_jobs;

-- Write a SQL query using a temporary table to store each company_name with its total number of job postings, 
-- then return only companies with more than 100 job postings.

 CREATE OR REPLACE TEMP TABLE total_num_jobs as SELECT 
    company_name,
    COUNT(*) as total_jobs
FROM staging.job_postings_flat
GROUP BY company_name;

SELECT 
    company_name,
    total_jobs
FROM total_num_jobs
WHERE total_jobs>100;

-- Your team wants a company-level data quality report. For each company, return the company name and
--  two separate indicators: whether the company has at least one job posting with salary information, 
-- and whether it has at least one job posting without salary information.

SELECT 
cd.name,
CASE 

    WHEN EXISTS (
        SELECT 1
        FROM data_jobs.job_postings_fact as jpf
        WHERE jpf.company_id = cd.company_id
        and salary_year_avg is not null
    )

    THEN 'YES'
    ELSE 'NO'
    END AS 'HAS JOB WITH SALARY',
CASE 
    WHEN EXISTS (
        SELECT 1
        FROM data_jobs.job_postings_fact as jpf
        WHERE jpf.company_id = cd.company_id
        and salary_year_avg is null
    )
    THEN 'YES'
    ELSE 'NO'
    END AS 'HAS JOB WITHOUT SALARY'

 FROM data_jobs.company_dim as cd;

