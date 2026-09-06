SELECT UNNEST([1, 1, 1, 2])
UNION
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
UNION ALL
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
INTERSECT ALL
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
EXCEPT ALL
SELECT UNNEST([1, 1, 3]);
--Which unique job postings appeared in either 2023 or 2024
    SELECT 
        job_title_short,
         EXTRACT(YEAR FROM job_posted_date) AS job_posted_year
    FROM job_postings_fact
    WHERE Extract(year from job_posted_date) in (
        SELECT
        Extract(year from job_posted_date)
        FROM job_postings_fact
        WHERE Extract(year from job_posted_date) = '2023'
        UNION 
        SELECT
        Extract(year from job_posted_date)
        FROM job_postings_fact
        WHERE Extract(year from job_posted_date) = '2024'
    );

