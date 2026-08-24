/*
Question: What are the most optimal skills for data engineers_balancing both demand salary?
- Create a ranking colum that combines demand count and median salary to identify the most valuable skills.
- Why?
    - This approch highlights skills that balance market demand and financial reward . It weights core skills 
      appropriatley, rather than letting rare,outlier skills distort the results.
*/
SELECT 
    sd.skills,
    ROUND(median(jpf.salary_year_avg),0 )as salary,
    ROUND(LN(count(jpf.*))) as in_demand_skills,
    ROUND(median(jpf.salary_year_avg) * LN(count(jpf.*))/1000000, 2)
    as skill_value_score
FROM job_postings_fact as jpf

INNER JOIN skills_job_dim as sjd
    ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim as sd
    ON sd.skill_id = sjd.skill_id

WHERE job_title_short ='Data Engineer'
    AND job_work_from_home = true
    AND jpf.salary_year_avg is not null

GROUP BY 
    sd.skills
HAVING  count(jpf.*)>100
ORDER BY skill_value_score DESC
LIMIT 25;
/*
The results show which skills provide the best balance between salary and demand for data engineers.

Terraform ranks highest with a skill value score of 0.97 and a median salary of $184,000. Python follows closely with a score of 0.95, showing a strong combination of high demand and competitive salary.

AWS and SQL both score 0.91, confirming that cloud computing and database skills are highly valuable in the data engineering market.

Airflow, Spark, Kafka, and Snowflake also rank highly, showing that pipeline orchestration, big data processing, and cloud data platforms are important skills for data engineers.

Kubernetes has a high median salary of $150,500, but its lower demand score places it below some more commonly requested skills.

Key takeaways:

* Terraform has the highest overall skill value score.
* Python provides one of the strongest combinations of salary and demand.
* SQL and AWS remain highly valuable core skills.
* Airflow, Spark, Kafka, and Snowflake are strong specialized data engineering skills.
* Some skills, such as Kubernetes, offer high salaries but have slightly lower demand.
* The strongest skills are not always the ones with the highest salary, but the ones that balance both salary and market demand.
┌────────────┬──────────┬──────────────────┬───────────────────┐
│   skills   │  salary  │ in_demand_skills │ skill_value_score │
│  varchar   │  double  │      double      │      double       │
├────────────┼──────────┼──────────────────┼───────────────────┤
│ terraform  │ 184000.0 │              5.0 │              0.97 │
│ python     │ 135000.0 │              7.0 │              0.95 │
│ aws        │ 137320.0 │              7.0 │              0.91 │
│ sql        │ 130000.0 │              7.0 │              0.91 │
│ airflow    │ 150000.0 │              6.0 │              0.89 │
│ spark      │ 140000.0 │              6.0 │              0.87 │
│ kafka      │ 145000.0 │              6.0 │              0.82 │
│ snowflake  │ 135500.0 │              6.0 │              0.82 │
│ azure      │ 128000.0 │              6.0 │              0.79 │
│ java       │ 135000.0 │              6.0 │              0.77 │
│ scala      │ 137290.0 │              6.0 │              0.76 │
│ kubernetes │ 150500.0 │              5.0 │              0.75 │
│ git        │ 140000.0 │              5.0 │              0.75 │
│ databricks │ 132750.0 │              6.0 │              0.74 │
│ redshift   │ 130000.0 │              6.0 │              0.73 │
│ gcp        │ 136000.0 │              5.0 │              0.72 │
│ hadoop     │ 135000.0 │              5.0 │              0.71 │
│ nosql      │ 134415.0 │              5.0 │              0.71 │
│ pyspark    │ 140000.0 │              5.0 │               0.7 │
│ mongodb    │ 135750.0 │              5.0 │              0.67 │
│ docker     │ 135000.0 │              5.0 │              0.67 │
│ go         │ 140000.0 │              5.0 │              0.66 │
│ r          │ 134775.0 │              5.0 │              0.66 │
│ github     │ 135000.0 │              5.0 │              0.65 │
│ bigquery   │ 135000.0 │              5.0 │              0.65 │
└────────────┴──────────┴──────────────────┴───────────────────┘
*/