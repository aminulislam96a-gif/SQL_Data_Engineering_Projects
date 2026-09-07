-- Step 05: Mart - Create priority roles mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;

--Create priority_mart schema 
CREATE SCHEMA priority_mart;

--Create priority_roles table
CREATE TABLE priority_mart.priority_roles(
    role_id                         INTEGER  PRIMARY KEY,
    role_name                       VARCHAR,
    priority_lvl                    INTEGER,
);


SELECT '===Loading data into priority_roles table===' AS info;

--INSERT INTO priority_roles table 
INSERT INTO priority_mart.priority_roles(
    role_id,
    role_name,
    priority_lvl
)
VALUES
    (1, 'Data Engineer',        2),
    (2, 'Senior Data Engineer', 1),
    (3,'Software Engineer',     3);

SELECT * FROM priority_mart.priority_roles;

SELECT '===Loading data into priority_jobs_snapshot table===' AS info;

--Create priority_jobs_snapshot table
CREATE TABLE priority_mart.priority_jobs_snapshot(
    job_id                  INTEGER      PRIMARY KEY,
    job_title_short         VARCHAR,
    company_name            VARCHAR,
    job_posted_date         TIMESTAMP,
    salary_year_avg         DOUBLE,
    priority_lvl            INTEGER,
    updated_at              TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot(
    job_id,job_title_short,company_name,job_posted_date,
    salary_year_avg,priority_lvl,updated_at
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM job_postings_fact as jpf

LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id

INNER JOIN priority_mart.priority_roles AS pr
ON jpf.job_title_short = pr.role_name;

SELECT 'priority_roles' AS table_name, COUNT(*) as record_count FROM priority_mart.priority_roles
UNION ALL 
SELECT 'priority_jobs_snapshot',COUNT(*) FROM priority_mart.priority_jobs_snapshot;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;


