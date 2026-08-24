
SELECT 
    sd.skills,
    count(jpf.*) as in_demand_skills,
   ROUND(MEDIAN(jpf.salary_year_avg), 0) AS salary
FROM  job_postings_fact as jpf 

INNER JOIN skills_job_dim as sjd
    ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim as sd
    on sd.skill_id = sjd.skill_id

WHERE job_title_short = 'Data Engineer'
    AND job_work_from_home = true
GROUP BY sd.skills
ORDER BY count(jpf.*) DESC
LIMIT 20;
/*
The results show the relationship between skill demand and median salary for data engineering jobs.

SQL and Python remain the most requested skills, with more than 28,000 job postings each. Their median salaries are around $130,000 and $135,000.

Some skills have lower demand but higher salaries. Airflow stands out with the highest median salary at $150,000, followed by Kafka at $145,000.

Spark, PySpark, and Git also show strong salary levels at around $140,000, while still appearing frequently in job postings.

Cloud and data platform skills such as AWS, Azure, GCP, Snowflake, Databricks, and Redshift continue to show both strong demand and competitive salaries.

Key takeaways:

* SQL and Python have the highest overall demand.
* Airflow has the highest median salary among these skills.
* Kafka also offers a high median salary despite having fewer job postings.
* Spark and PySpark show strong value for big data processing.
* Cloud skills remain important across AWS, Azure, and GCP.
* Power BI and Tableau have lower median salaries compared with most of the other listed skills.

┌────────────┬──────────────────┬──────────┐
│   skills   │ in_demand_skills │  salary  │
│  varchar   │      int64       │  double  │
├────────────┼──────────────────┼──────────┤
│ sql        │            29221 │ 130000.0 │
│ python     │            28776 │ 135000.0 │
│ aws        │            17823 │ 137320.0 │
│ azure      │            14143 │ 128000.0 │
│ spark      │            12799 │ 140000.0 │
│ airflow    │             9996 │ 150000.0 │
│ snowflake  │             8639 │ 135500.0 │
│ databricks │             8183 │ 132750.0 │
│ java       │             7267 │ 135000.0 │
│ gcp        │             6446 │ 136000.0 │
│ kafka      │             6415 │ 145000.0 │
│ scala      │             6304 │ 137290.0 │
│ redshift   │             5737 │ 130000.0 │
│ hadoop     │             5447 │ 135000.0 │
│ pyspark    │             4898 │ 140000.0 │
│ git        │             4641 │ 140000.0 │
│ power bi   │             4600 │ 120000.0 │
│ nosql      │             4514 │ 134415.0 │
│ tableau    │             4402 │ 115000.0 │
│ docker     │             4316 │ 135000.0 │
└────────────┴──────────────────┴──────────┘
*/