-- Bucket Salaries
-- < 25 = 'Low'
-- 25-50 = 'Medium'
-- > 50 = 'High'
SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg <25 THEN 'Low'
        WHEN  salary_hour_avg <50 THEN 'Medum'
        ELSE 'High'
    END as salary_category
FROM job_postings_fact
where job_title_short ='Data Engineer' and salary_hour_avg is not null
LIMIT 20;
-- Handing missing data (Nulls)
-- Filler NULL salary values
SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg is null then 'Missing'
        WHEN salary_hour_avg <25 THEN 'Low'
        WHEN  salary_hour_avg <50 THEN 'Medum'
        ELSE 'High'
    END as salary_category
FROM job_postings_fact;

-- Categorizing Categorical Values 
-- Classify the 'Job_title' colum values as :
-- 'Data Analyst'
-- 'Data Engineer'
-- 'Data Scientist'
SELECT 
    job_title,
    job_title_short,
    CASE 
    WHEN job_title like '%Data%' and job_title LIKE '%Analyst' THEN 'Data Analyst'
    WHEN job_title like '%Data%' and job_title LIKE '%Engineer' THEN 'Data Engineer'
    WHEN  job_title like '%Data%' and job_title LIKE '%Scientist' THEN 'Data Scientist'
    ELSE 'Others'
END AS Job_title
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- Conditional Aggregation
-- Calculate Median Salaries for Different Buckets for Diffrent job Postings
-- <$100k
-- >=$100k
SELECT 
    job_title_short,
    COUNT(*) AS Total_Postings,
    MEDIAN(
        CASE 
            WHEN salary_year_avg<100000 THEN salary_year_avg
        END 
    )AS median_low_salary,
    MEDIAN(
        CASE 
            WHEN salary_year_avg>=100000 THEN salary_year_avg
        END 
    )AS median_high_salary
FROM job_postings_fact
where salary_year_avg is not null
GROUP BY job_title_short;

-- Compute a Standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize Salaries into tiers of:
-- <75k 'Low'
-- <75k-150k 'Medium'
-- >=150k 'High'
SELECT 
    job_title_short,
    MEDIAN(salary_year_avg)::INTEGER AS yearly_median_salary,
    MEDIAN(salary_hour_avg*2040)::INTEGER AS Hourly_median_salary,
    CASE 
        WHEN yearly_median_salary<70000 THEN 'Low'
        WHEN yearly_median_salary<150000 THEN 'Medium'
        ELSE 'HIGH'
    END AS Standardized_yearly_salary,
    CASE 
         WHEN Hourly_median_salary<70000 THEN 'Low'
        WHEN Hourly_median_salary<150000 THEN 'Medium'
        ELSE 'HIGH'
    END AS Standardized_Hourly_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
GROUP BY job_title_short
ORDER BY RANDOM();


