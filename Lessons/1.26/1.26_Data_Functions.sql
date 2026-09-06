SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestamptz 
FROM job_postings_fact
LIMIT 15;

--Extract fonction
SELECT 
    EXTRACT(YEAR FROM job_posted_date) AS YEAR,
     EXTRACT(MONTH  FROM job_posted_date) AS MONTH
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = '2023'
LIMIT 20;

--DATE_TRUNC function 
SELECT
    job_posted_date,
    DATE_TRUNC('week',job_posted_date) AS job_posted_day
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

--AT TIME ZONE Function

SELECT
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AS utc_time,
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC-4' AS virginia_time;

SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_york'
FROM job_postings_fact
LIMIT 20;