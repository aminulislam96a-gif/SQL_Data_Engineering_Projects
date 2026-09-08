--Step 07: Mart - Create Company Mart

DROP SCHEMA IF EXISTS company_mart CASCADE;
--Create company_mart Schema 
CREATE SCHEMA company_mart;

--Create dim_job_title Dimension Table
CREATE TABLE company_mart.dim_job_title (
    job_title_id                    INTEGER  PRIMARY KEY,
    job_title                       VARCHAR
);

SELECT '=== Loading Data into dim_job_title Dimension table ===' AS info;

INSERT INTO company_mart.dim_job_title( 
    job_title,
    job_title_id
)
SELECT
job_title,
    ROW_NUMBER() OVER (
    ORDER BY job_title
) AS job_title_id
FROM (
    SELECT DISTINCT
    job_title
    FROM job_postings_fact
    WHERE job_title IS NOT NULL
);

--Create dim_job_title_short Dimension table
CREATE TABLE company_mart.dim_job_title_short(
    job_title_short_id                  INTEGER         PRIMARY KEY,
    job_title_short                     VARCHAR
);

SELECT '=== Loading Data into dim_job_title_short Dimension Table' AS info;



INSERT INTO company_mart.dim_job_title_short(
    
    job_title_short,
    job_title_short_id

)
SELECT
    job_title_short,
    ROW_NUMBER() OVER(
        ORDER BY job_title_short
    ) AS job_title_short_id
FROM(
    SELECT DISTINCT
    job_title_short
    FROM job_postings_fact
    WHERE job_title_short IS NOT NULL
);

--Create bridge_job_title Bridge Table
CREATE TABLE company_mart.bridge_job_title(
    job_title_short_id              INTEGER ,
    job_title_id                    INTEGER ,
    PRIMARY KEY(job_title_short_id,job_title_id),
    FOREIGN KEY(job_title_short_id) REFERENCES company_mart.dim_job_title_short(job_title_short_id),
    FOREIGN KEY(job_title_id) REFERENCES company_mart.dim_job_title(job_title_id)
);

SELECT '=== Loading Data into bridge_job_title Bridgetable ===' AS info;

INSERT INTO company_mart.bridge_job_title(
    job_title_short_id,
    job_title_id
)
SELECT DISTINCT
    djts.job_title_short_id,
    djt.job_title_id
FROM job_postings_fact AS jpf

INNER JOIN company_mart.dim_job_title_short AS djts
ON jpf.job_title_short = djts.job_title_short

INNER JOIN company_mart.dim_job_title AS djt 
ON djt.job_title = jpf.job_title

WHERE jpf.job_title_short IS NOT NULL
AND jpf.job_title IS NOT NULL;

--Create dim_company Dimension Table
CREATE TABLE company_mart.dim_company(
    company_id                 INTEGER  PRIMARY KEY,
    company_name               VARCHAR    
);

SELECT '=== Loading Data dim_company Dimension table ===' AS info;

INSERT INTO company_mart.dim_company(
    company_id,
    company_name
)
SELECT 
    company_id,
    name AS company_name
FROM company_dim;

--Create dim_location Dimension Table
CREATE TABLE company_mart.dim_location(
    location_id             INTEGER    PRIMARY KEY,
    job_location            VARCHAR,
    job_country             VARCHAR,
    UNIQUE(job_location,job_country)
);

SELECT '=== Loading Data into dim_location Dimension table ===' AS info;

INSERT INTO company_mart.dim_location(
    location_id, job_location,job_country
)
SELECT
       ROW_NUMBER() OVER(
        ORDER BY job_location,job_country
    ) AS location_id,
    job_location,
    job_country
FROM (
    SELECT DISTINCT
    job_location,
    job_country
    FROM job_postings_fact
    WHERE job_location IS NOT NULL
    AND job_country IS NOT NULL
);

--Create dim_date_month Dimension Table
CREATE TABLE company_mart.dim_date_month(
    month_start_date         DATE PRIMARY KEY,
    Year                     INTEGER,
    month                    INTEGER
);

SELECT '=== Loading Data into dim_date_month Dimension table ===' AS info;

INSERT INTO company_mart.dim_date_month(
    month_start_date, year , month
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date):: DATE AS month_start_date,
    EXTRACT(Year FROM job_posted_date) AS year,
    EXTRACT(Month FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_posted_date IS NOT NULL;

--CREATE bridge_company_location Bridge Table
CREATE TABLE company_mart.bridge_company_location(
    company_id          INTEGER,
    location_id         INTEGER,
    PRIMARY KEY(company_id,location_id),
    FOREIGN KEY(company_id) REFERENCES company_mart.dim_company(company_id),
    FOREIGN KEY(location_id) REFERENCES company_mart.dim_location(location_id)
);

SELECT '=== Loading Data into bridge_company_location Bridge table ===' AS info;

INSERT INTO company_mart.bridge_company_location(
    company_id, location_id
)
SELECT DISTINCT
    dm.company_id,
    dl.location_id
FROM job_postings_fact AS jpf

INNER JOIN company_mart.dim_company AS dm
ON jpf.company_id = dm.company_id

INNER JOIN company_mart.dim_location dl 
ON jpf.job_location = dl.job_location
and jpf.job_country = dl.job_country;

--Create fact_company_hiring_monthly Fact Table 
CREATE TABLE company_mart.fact_company_hiring_monthly(
    company_id              INTEGER,
    job_title_short_id      INTEGER,
    month_start_date        DATE,
    job_country             VARCHAR,
    postings_count          INTEGER,
    median_salary_year      DOUBLE,
    min_salary_year         DOUBLE,
    max_salary_year         DOUBLE,
    salary_postings_count   INTEGER,
    salary_coverage_share   DECIMAL(5,2),
    remote_share            DECIMAL(5,2),
    health_insurance_share  DECIMAL(5,2),
    no_degree_mention_share DECIMAL(5,2),
    PRIMARY KEY(company_id, job_title_short_id, month_start_date, job_country ),
    FOREIGN KEY(company_id) REFERENCES company_mart.dim_company(company_id),
    FOREIGN KEY(job_title_short_id) REFERENCES company_mart.dim_job_title_short(job_title_short_id),
    FOREIGN KEY(month_start_date) REFERENCES company_mart.dim_date_month(month_start_date)
);

SELECT '=== Loading Data into fact_company_hiring_monthly Fact table ===' AS info;

INSERT INTO company_mart.fact_company_hiring_monthly(
    company_id, job_title_short_id, month_start_date, job_country, postings_count,
    median_salary_year, min_salary_year, max_salary_year,salary_postings_count,
    salary_coverage_share, remote_share, health_insurance_share, no_degree_mention_share
)
SELECT
    dc.company_id,
    djts.job_title_short_id,
    ddm.month_start_date,
    jpf.job_country,
    COUNT(DISTINCT jpf.job_id) AS postings_count,
    MEDIAN(jpf.salary_year_avg)AS median_salary_year,
    MIN(jpf.salary_year_avg) AS min_salary_year,
    MAX(jpf.salary_year_avg) AS max_salary_year,
    
    COUNT(DISTINCT CASE
        WHEN jpf.salary_year_avg IS NOT NULL
        THEN jpf.job_id
    END) AS salary_postings_count,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN jpf.salary_year_avg IS NOT NULL
            THEN jpf.job_id
        END)
        /
        NULLIF(COUNT(DISTINCT jpf.job_id), 0),
        2
    ) AS salary_coverage_share,

    ROUND(
        100.0*
        COUNT(DISTINCT CASE
                WHEN jpf.job_work_from_home = TRUE
                THEN jpf.job_id
            END)
        / NULLIF(COUNT(DISTINCT jpf.job_id),0),2
       )AS remote_share,
    ROUND(
        100.0*
        COUNT(
            DISTINCT CASE
            WHEN jpf.job_health_insurance = TRUE
            THEN jpf.job_id
        END)
        / NULLIF(COUNT(DISTINCT jpf.job_id),0),2
    )AS health_insurance_share,
    ROUND(
        100.0*
        COUNT(
            DISTINCT CASE 
            WHEN jpf.job_no_degree_mention = TRUE
            THEN jpf.job_id
        END)
        / NULLIF(COUNT(DISTINCT jpf.job_id),0),2
    )AS no_degree_mention_share

FROM job_postings_fact AS jpf

INNER JOIN company_mart.dim_company AS dc
ON jpf.company_id = dc.company_id

INNER JOIN company_mart.dim_job_title_short AS djts
ON jpf.job_title_short = djts.job_title_short

INNER JOIN company_mart.dim_date_month AS ddm 
ON DATE_TRUNC('month',jpf.job_posted_date):: DATE = ddm.month_start_date

WHERE jpf.job_posted_date is NOT NULL
    AND jpf.job_country is NOT NULL
    AND jpf.job_title_short IS NOT NULL
GROUP BY 
    dc.company_id,
    djts.job_title_short_id,
    ddm.month_start_date,
    jpf.job_country;

                                                --Data validation

--Checking Total Row Count For  All Table
SELECT 'dim_job_title_short' AS table_name, COUNT(*) AS record_count FROM company_mart.dim_job_title_short
UNION ALL 
SELECT 'dim_job_title' , COUNT(*) FROM company_mart.dim_job_title
UNION ALL
SELECT 'bridge_job_title', COUNT(*) FROM company_mart.bridge_job_title
UNION ALL
SELECT 'dim_company', COUNT(*) FROM company_mart.dim_company
UNION ALL
SELECT 'dim_location', COUNT(*) FROM company_mart.dim_location
UNION ALL
SELECT 'dim_date_month', COUNT(*) FROM company_mart.dim_date_month
UNION ALL
SELECT 'bridge_company_location', COUNT(*) FROM company_mart.bridge_company_location
UNION ALL
SELECT 'company_mart.fact_company_hiring_monthly', COUNT(*) FROM company_mart.fact_company_hiring_monthly;

--Validating Each Table Sparatly 
SELECT ' === dim_job_title_short === ' AS info;
SELECT * FROM company_mart.dim_job_title_short LIMIT 10;

SELECT ' === dim_job_title === ' AS info;
SELECT * FROM company_mart.dim_job_title LIMIT 10;

SELECT ' === bridge_job_title === ' AS info;
SELECT * FROM company_mart.bridge_job_title LIMIT 10;

SELECT ' === dim_company  === ' AS info;
SELECT * FROM company_mart.dim_company LIMIT 10;

SELECT ' === dim_location === ' AS info;
SELECT * FROM company_mart.dim_location LIMIT 10;

SELECT ' === dim_date_month === ' AS info;
SELECT * FROM company_mart.dim_date_month LIMIT 10;

SELECT ' === bridge_company_location === ' AS info;
SELECT * FROM company_mart.bridge_company_location LIMIT 10;

SELECT ' === fact_company_hiring_monthly === ' AS info;
SELECT * FROM company_mart.fact_company_hiring_monthly LIMIT 10;

--how many monthly company groups actually have salary information.
SELECT
    COUNT(*) AS total_fact_rows,
    COUNT(median_salary_year) AS rows_with_salary,
    COUNT(*) - COUNT(median_salary_year) AS rows_without_salary
FROM company_mart.fact_company_hiring_monthly;

-- Validate salary coverage
SELECT
    postings_count,
    salary_postings_count,
    salary_coverage_share,
    median_salary_year
FROM company_mart.fact_company_hiring_monthly
WHERE salary_postings_count > 0
LIMIT 10;