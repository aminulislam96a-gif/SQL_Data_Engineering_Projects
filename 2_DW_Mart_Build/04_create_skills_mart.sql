-- Step 4: Mart - Create skills demand mart (dimensional mart)
--Run this afteer step 3
-- This mart focuses on skill demand over time with aggregated posting measures

--DROP Schema 
DROP SCHEMA IF EXISTS skills_mart CASCADE;

-- Create the mart schema 
CREATE SCHEMA skills_mart;

--Create the dim_skill dimension tables 
CREATE TABLE skills_mart.dim_skill(
    skill_id                INTEGER          PRIMARY KEY,
    skills                  VARCHAR,
    type                    VARCHAR       
);

SELECT '===Loading data into dim_skill table===' as info;

--INSERT INTO dim_skill table 
INSERT INTO skills_mart.dim_skill(skill_id, skills, type)

SELECT
    skill_id, 
    skills, 
    type
FROM skills_dim;

--Create dim_date_month Dimension table
CREATE TABLE skills_mart.dim_date_month(
    month_start_date        DATE PRIMARY KEY,
    year                    INTEGER,
    month                   INTEGER,
    quarter                 INTEGER,
    quarter_name            VARCHAR,
    year_quarter            VARCHAR
);  

SELECT '===Loading data into dim_date_month table ===' AS info;

--INSERT INTO dim_date_month dimension table 
INSERT INTO skills_mart.dim_date_month(
    month_start_date,
    year, 
    month, 
    quarter, quarter_name, 
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month',job_posted_date)::DATE AS month_start_date,
    EXTRACT(year FROM job_posted_date)AS year,
    EXTRACT(month FROM job_posted_date)AS month,
    EXTRACT(quarter FROM job_posted_date )AS quarter,
    --Quarter name 
    'Q' || CAST(EXTRACT(quarter FROM job_posted_date ) AS  VARCHAR )AS quarter_name,
    --Year and quarter combination
    CAST(EXTRACT(year from job_posted_date) AS VARCHAR) || 'Q' ||
    CAST(EXTRACT(quarter FROM job_posted_date) AS VARCHAR) AS year_quarter
FROM job_postings_fact
ORDER BY month_start_date;
    

--Create fact_skill_demand_monthly Fact table
CREATE TABLE skills_mart.fact_skill_demand_monthly(
    skill_id                INTEGER,
    month_start_date        DATE,
    job_title_short         VARCHAR,
    postings_count          INTEGER,
    remote_postings_count   INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_postings_count INTEGER,
    PRIMARY KEY(skill_id,month_start_date,job_title_short),
    FOREIGN KEY(skill_id) REFERENCES skills_mart.dim_skill(skill_id),
    FOREIGN KEY(month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

SELECT '===Loading data into fact_skill_demand_monthly fact table===' AS info;

--INSER INTO fact_skill_demand_monthly fact table 
INSERT INTO skills_mart.fact_skill_demand_monthly(
    skill_id,month_start_date,job_title_short,postings_count,remote_postings_count,
    health_insurance_postings_count,no_degree_postings_count
)
SELECT
    sjd.skill_id,
    DATE_TRUNC('month',jpf.job_posted_date)::DATE AS month_start_date,
    jpf.job_title_short,
    COUNT(DISTINCT JPF.job_id) AS postings_count,
    COUNT(DISTINCT CASE
            WHEN jpf.job_work_from_home =true
            then jpf.job_id
    END   )AS remote_postings_count,
    COUNT(DISTINCT CASE
            WHEN jpf.job_health_insurance=true
            THEN jpf.job_id
    END)AS health_insurance_postings_count,
    COUNT(DISTINCT CASE
            WHEN jpf.job_no_degree_mention = true
            THEN jpf.job_id
    END)AS no_degree_postings_count

FROM job_postings_fact AS jpf

INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id

WHERE jpf.job_posted_date IS NOT NULL 
    AND jpf.job_title_short IS NOT NULL
    AND sjd.skill_id IS NOT NULL
GROUP BY 
    sjd.skill_id,
    month_start_date,
    jpf.job_title_short
ORDER BY skill_id,month_start_date,job_title_short;

--Data VAlidation 
SELECT 'dim_skill' AS table_name, COUNT(*) AS record_count FROM skills_mart.dim_skill
UNION ALL
SELECT 'dim_date_month' , COUNT(*) FROM skills_mart.dim_date_month
UNION ALL 
SELECT 'fact_skill_demand_monthly', COUNT(*) FROM skills_mart.fact_skill_demand_monthly;


SELECT ' === Skills Dimension Table === ' AS info;
SELECT * FROM skills_mart.dim_skill LIMIT 10;

SELECT ' === Date Month Dimension Table=== ' AS info;
SELECT * FROM skills_mart.dim_date_month LIMIT 10;

SELECT '=== Skill Demand Monthly Fact Table === ' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 10;
