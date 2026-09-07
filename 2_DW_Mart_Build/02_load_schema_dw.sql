--Step2:DW -load data from CSV files into tables 

--loading data into the company_dim table
SELECT '--Loading company_dim table' as info;

INSERT INTO company_dim(company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true);

--loading data into the skills_dim table
SELECT '--Loading skills_dim  table' as info;

INSERT INTO skills_dim (skill_id,skills,type)
SELECT skill_id,skills,type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=true);
--loading data into the job_postings_fact table
SELECT '--Loading job_postings_fact table' as info;

INSERT INTO job_postings_fact (job_id, company_id,job_title_short,job_title,job_country,job_location,job_no_degree_mention,
    job_posted_date,job_schedule_type,job_via,job_work_from_home,job_health_insurance,
    search_location,salary_rate,salary_year_avg,salary_hour_avg
)
SELECT job_id, company_id,job_title_short,job_title,job_country,job_location,job_no_degree_mention,
    job_posted_date,job_schedule_type,job_via,job_work_from_home,
    job_health_insurance,search_location,salary_rate,salary_year_avg,salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=true);

--loading data into the skills_job_dim table
SELECT '--Loading skills_job_dim  table' as info;

INSERT INTO skills_job_dim( skill_id,job_id)
SELECT skill_id,job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=true);

SELECT 'company_dim' as table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL 
SELECT 'skills_dim', COUNT(*) FROM skills_dim
UNION ALL 
SELECT 'job_postings_fact', COUNT(*) FROM job_postings_fact
UNION ALL 
SELECT 'skills_job_dim', COUNT(*) FROM skills_job_dim;

SELECT '=== Company Dimension Sample ===' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills job Bridge Sample ===' AS info;
SELECT * FROM skills_job_dim LIMIT 5;