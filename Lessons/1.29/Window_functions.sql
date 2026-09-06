--Count Rows -Aggregation Only
SELECT 
COUNT(*)
FROM job_postings_fact;


--Count Rows - Window Function
SELECT 
    job_id,
    job_title_short,
    Count(job_id) OVER(
        PARTITION BY job_id
    ) AS job_id
FROM job_postings_fact;

--PARTITION BY -Find yearly salary

SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    avg(salary_year_avg) OVER(
        PARTITION BY job_title_short
    )AS yearly_salary_by_title
FROM job_postings_fact
where salary_year_avg is  not null;

--RANK  BY -Find yearly salary

SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    ROW_NUMBER() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_year_avg DESC
    )AS rank_number
FROM job_postings_fact
where salary_year_avg is  not null
ORDER BY salary_year_avg DESC;

--NEVIGATION TO -Find yearly salary