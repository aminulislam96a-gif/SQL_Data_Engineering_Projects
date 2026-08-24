/* Question: What are the most in-demand skills for data engineers?
. Identify the top 10 in-demand skills for data engineers
. Focus on the remote job postings 
. why?
    . Retrives the top 10 skils with the highest demand in the remote
    job market,providing insights into the most valuable skilss for the 
    data engineers sekking remote work.
*/
SELECT 
    sd.skills ,
    count(jpf.*) as in_demand_skills 
FROM job_postings_fact as jpf

INNER JOIN skills_job_dim as sjd
    ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id

WHERE job_title_short = 'Data Engineer'
    AND job_work_from_home = true
group by sd.skills 
ORDER BY count(jpf.*) DESC
LIMIT 10;
/*
The results show that SQL and Python are the strongest skills in the data engineering job market, with both appearing in nearly 29,000 job postings.

Cloud technologies are also in high demand. AWS has the highest demand among cloud platforms, followed by Azure and GCP — Google Cloud Platform.

Apache Spark is another major skill, showing that companies are looking for people who can work with large-scale data processing.

Tools such as Airflow, Snowflake, and Databricks also appear frequently, which shows how important data pipelines, cloud warehouses, and modern data platforms have become.

Key takeaways:

* SQL and Python are the most important core skills.
* AWS and Azure are the leading cloud platforms.
* Spark is highly valued for big data processing.
* Airflow, Snowflake, and Databricks are important modern data engineering tools.
* Java and GCP are also commonly requested skills.

┌────────────┬──────────────────┐
│   skills   │ in_demand_skills │
│  varchar   │      int64       │
├────────────┼──────────────────┤
│ sql        │            29221 │
│ python     │            28776 │
│ aws        │            17823 │
│ azure      │            14143 │
│ spark      │            12799 │
│ airflow    │             9996 │
│ snowflake  │             8639 │
│ databricks │             8183 │
│ java       │             7267 │
│ gcp        │             6446 │
└────────────┴──────────────────┘
*/
/*
Question: What are the highest-paying skills for data engineers?
 . Calculate the median salary for each skill required in data
  engineer positions.
 . Focus on remote positions with specified salaries
 . Include skills frequency to identify both salary and demand 
 . Why?
    . Helps identify which skills command the highest compensation
      while aslo shoing how common those skills are, providing a more
      complete picture for skills development priorities.
    . The median is used insted of the average to reduce the impact of 
      outlier salaries.
*/