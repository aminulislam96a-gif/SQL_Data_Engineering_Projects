
DROP TABLE  IF EXISTS staging.job_postings_flat;
DROP VIEW IF EXISTS staging.priority_job_flat_view;
CREATE TABLE if not EXISTS staging.job_postings_flat as 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date, 
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name,

FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;

SELECT *
FROM staging.job_postings_flat;

CREATE VIEW staging.priority_job_flat_view as 
SELECT 
jpf.* 
FROM staging.job_postings_flat as jpf
join staging.preferred_roles as r 
on jpf.job_title_short = r.role_name
where r.priority_lvl = 1;

SELECT 
    job_title_short,
    count(*) as job_count
FROM staging.priority_job_flat_view 
GROUP BY job_title_short
ORDER BY count(*) DESC;

CREATE TEMPORARY TABLE senior_jobs_flat_tamp as 
SELECT *
FROM staging.priority_job_flat_view
WHERE  job_title_short = 'Senior Data Engineer';

SELECT 
    job_title_short,
    count(*) as job_count
FROM senior_jobs_flat_tamp 
GROUP BY job_title_short
ORDER BY count(*) DESC;



DELETE FROM staging.job_postings_flat
WHERE job_posted_date<'2024-01-01';

TRUNCATE TABLE  staging.job_postings_flat;

INSERT INTO staging.job_postings_flat

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date, 
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name,

FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date>= '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_job_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_tamp;


