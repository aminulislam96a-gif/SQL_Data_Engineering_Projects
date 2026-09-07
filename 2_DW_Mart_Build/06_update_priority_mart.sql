-- Step 06: Mart - Update priority roles mart
SELECT '===Updating the riority_roles Data===' AS info;
--Update Data Engineer to Priority 1
UPDATE priority_mart.priority_roles
SET priority_lvl =1
WHERE role_name ='Data Engineer';

SELECT '===Inserting New Data Into Priority Mart===' AS info;

-- --Adding New Rows Into priority_roles table 
INSERT INTO priority_mart.priority_roles(
    role_id,
    role_name,
    priority_lvl
)
VALUES (4, 'Data Scientist', 3 );

--validating priority_roles table 
SELECT * FROM priority_mart.priority_roles;

SELECT '===Craeting Temp Table for Priority Mart===' AS info;
-- Create TEMP table 
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
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

SELECT '=== Batch Updating priority_jobs_snapshot for Priority Mart ' AS info;
--Merge Into 
MERGE INTO priority_mart.priority_jobs_snapshot as tgt
USING src_priority_jobs as src
ON tgt.job_id= src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
UPDATE SET  
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at

WHEN NOT MATCHED THEN
INSERT(
     job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
VALUES(
     src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

--Data Validation Check

SELECT 'priority_roles' AS table_name, COUNT(*) as record_count FROM priority_mart.priority_roles
UNION ALL 
SELECT 'priority_jobs_snapshot',COUNT(*) FROM priority_mart.priority_jobs_snapshot
UNION ALL
SELECT 'src_priority_jobs', COUNT(*) FROM src_priority_jobs;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM src_priority_jobs
GROUP BY job_title_short
ORDER BY job_count DESC;
