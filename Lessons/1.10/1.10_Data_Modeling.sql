SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM 
    job_postings_fact
LIMIT 10;

SELECT 
    company_id,
    name
FROM
    company_dim
LIMIT 10;

SELECT
    skill_id,
    skills,
    type
FROM
    skills_dim
LIMIT 10;



SELECT *
FROM 
    information_schema.table_contraints
WHERE 
    table_catalog = 'data_jobs';

