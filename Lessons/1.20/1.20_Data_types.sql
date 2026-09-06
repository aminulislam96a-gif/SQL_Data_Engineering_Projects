-- -- SELECT 
-- --     table_name,
-- --     column_name,
-- --     data_type
-- -- FROM information_schema.columns
-- -- WHERE 
-- --    table_name ='company_dim';

-- -- DESCRIBE 
-- -- SELECT 
-- --     job_title_short,
-- --     salary_year_avg
-- -- FROM 
-- --     job_postings_fact;

-- SELECT CAST('123'AS INTEGER);

-- Changing data type to diffrent one

--     SELECT
--         job_id ,
--         CAST(job_work_from_home AS INTEGER),
--         CAST(job_title_short AS CHARACTER),
--         CAST(job_posted_date AS TIMESTAMPTZ),
--         CAST(salary_year_avg AS DECIMAL)
-- FROM(
--     SELECT * 
--     FROM job_postings_fact 
--     LIMIT 10
--     );
  SELECT
        job_id || '--' || company_id ,
        job_work_from_home :: INTEGER ,
        job_title_short :: CHARACTER,
        job_posted_date :: TIMESTAMPTZ,
        salary_year_avg :: DECIMAL
FROM(
    SELECT * 
    FROM job_postings_fact 
    WHERE salary_year_avg is not null
    LIMIT 10
    );

    SELECT (3+5.5):: double;