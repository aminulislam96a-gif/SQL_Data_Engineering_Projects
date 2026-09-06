 SELECT CHAR_LENGTH('Aminul');

  SELECT UPPER('Aminul');

   SELECT LOWER('Aminul');
 SELECT LEFT('Aminul',4);
  SELECT RIGHT('Aminul',3);
   SELECT SUBSTRING('Aminul',3,2);

    SELECT TRIM('  Aminul  ');

    SELECT 'AMI' ||'-' || 'NUL';

SELECT 
    job_title_short,
    NULLIF(salary_year_avg,0) AS yearly_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;

-- Compute a Standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize Salaries into tiers of:
-- <75k 'Low'
-- <75k-150k 'Medium'
-- >=150k 'High'

SELECT 
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg , salary_hour_avg* 2080)As Satandalize_salary,
CASE 
    WHEN COALESCE(salary_year_avg , salary_hour_avg* 2080) IS NULL THEN 'MISSING'
    WHEN COALESCE(salary_year_avg , salary_hour_avg* 2080) <75000 THEN 'LOW'
    WHEN COALESCE(salary_year_avg , salary_hour_avg* 2080)<150000 THEN 'MID'
    ELSE 'HIGH'
END AS salary_bucket
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
ORDER BY Satandalize_salary;

