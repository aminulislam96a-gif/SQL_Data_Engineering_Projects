/*
1. High-paying Data Engineer jobs and their required skills

Find all Data Engineer jobs and show the job title, company name, job location, 
yearly average salary, and every skill required for each job.

Requirements:
Only include jobs where the yearly average salary is greater than $100,000.
Sort the results from highest salary to lowest salary.
*/
SELECT
    jpf.job_title_short as job_title,
    cd.name as company_name,
    jpf.job_location,
    jpf.salary_year_avg as yearly_average_salary,
    sd.skills as required_skills 
FROM 
    job_postings_fact as jpf

LEFT JOIN company_dim as cd
    on jpf.company_id = cd.company_id

LEFT JOIN skills_job_dim as sjd
on sjd.job_id = jpf.job_id

LEFT JOIN skills_dim as sd
on sd.skill_id = sjd.skill_id

where job_title ='Data Engineer' AND salary_year_avg>100000
ORDER BY yearly_average_salary DESC
LIMIT 20;
/*
The results show Data Engineer jobs with yearly average salaries above $100,000 and the skills required for each position.

The highest-paying Data Engineer job in the results has an average yearly salary of **$410,000**. This position requires several important technical skills, including **Python, Java, Scala, Spark, and SQL (Structured Query Language)**.

Several jobs offer salaries around **$400,000** and require skills such as **Azure, MySQL, Python, Hadoop, AWS (Amazon Web Services), Java, PostgreSQL, SQL, and Spark**. This shows that high-paying Data Engineer positions often require a combination of programming, cloud computing, databases, and big data technologies.

Jobs with salaries around **$390,000** include skills such as **Python, Go, Linux, and Excel**, while another high-paying position at **$375,000** requires **Kafka**.

Each job can appear multiple times in the results because one job may require several different skills. For example, the $410,000 Data Engineer position appears once for Python, once for Java, once for Scala, and so on.

Key takeaways:

* The highest yearly average salary shown is **$410,000**.
* **Python** appears frequently among high-paying Data Engineer jobs.
* **SQL (Structured Query Language)** is another important skill for high-paying roles.
* Cloud skills such as **AWS (Amazon Web Services)** and **Azure** are valuable.
* Big data technologies such as **Spark, Hadoop, and Kafka** are commonly associated with high-paying Data Engineer positions.
* Programming languages such as **Java, Scala, Python, and Go** are also important.
* High-paying Data Engineer jobs usually require a combination of programming, databases, cloud platforms, and data processing technologies.

┌───────────────┬───┬───────────────────────┬─────────────────┐
│   job_title   │ … │ yearly_average_salary │ required_skills │
│    varchar    │ … │        double         │     varchar     │
├───────────────┼───┼───────────────────────┼─────────────────┤
│ Data Engineer │ … │              410000.0 │ java            │
│ Data Engineer │ … │              410000.0 │ scala           │
│ Data Engineer │ … │              410000.0 │ spark           │
│ Data Engineer │ … │              410000.0 │ python          │
│ Data Engineer │ … │              410000.0 │ sql             │
│ Data Engineer │ … │              400000.0 │ mysql           │
│ Data Engineer │ … │              400000.0 │ azure           │
│ Data Engineer │ … │              400000.0 │ python          │
│ Data Engineer │ … │              400000.0 │ spark           │
│ Data Engineer │ … │              400000.0 │ hadoop          │
│ Data Engineer │ … │              400000.0 │ postgresql      │
│ Data Engineer │ … │              400000.0 │ sql             │
│ Data Engineer │ … │              400000.0 │ python          │
│ Data Engineer │ … │              400000.0 │ java            │
│ Data Engineer │ … │              400000.0 │ aws             │
│ Data Engineer │ … │              390000.0 │ linux           │
│ Data Engineer │ … │              390000.0 │ python          │
│ Data Engineer │ … │              390000.0 │ go              │
│ Data Engineer │ … │              390000.0 │ excel           │
│ Data Engineer │ … │              375000.0 │ kubernetes      │
└───────────────┴───┴───────────────────────┴─────────────────┘
*/