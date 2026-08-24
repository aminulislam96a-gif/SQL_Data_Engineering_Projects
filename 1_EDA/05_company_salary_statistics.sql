/*
Find each company’s salary statistics.
Requirements:

Only include jobs where salary_year_avg is not NULL.
Only show companies that have at least 10 jobs with salary information.
Sort by average yearly salary from highest to lowest.
Show only the top 15 companies.
*/

SELECT 
    cd.name as company_name,
    ROUND(avg(salary_year_avg),0) as average_yearly_salary,
    count(jpf.job_title_short)as number_of_jobs
FROM 
    job_postings_fact as jpf

inner join company_dim as cd
on cd.company_id = jpf.company_id

where salary_year_avg is not NULL
group by 
    cd.name,
    cd.company_id
having count(jpf.job_title_short)>=10
order by avg(salary_year_avg) DESC

limit 15;

/*
The results show the top 15 companies with the highest average yearly salaries among companies that have at least 10 jobs with salary information.

**Netflix** ranks first with an average yearly salary of **$400,060** across **44 jobs**, making it the highest-paying company in the results by a large margin.

**Eleven Recruiting** ranks second with an average salary of **$320,909** across **22 jobs**, followed by **Algo Capital Group** with an average salary of **$307,188** across **16 jobs**.

Other companies with very high average salaries include **Bedrock Ocean Exploration** at **$275,000**, **Edge & Node** at **$267,000**, and **Engtal** at **$253,077**.

Well-known technology companies also appear in the top 15. **Roblox** has an average yearly salary of **$235,383**, **Asana** averages **$229,864**, **Snap Inc.** averages **$229,581**, and **NVIDIA** averages **$219,712**.

Key takeaways:

* Netflix has the highest average yearly salary at **$400,060**.
* Eleven Recruiting and Algo Capital Group both have average salaries above **$300,000**.
* All companies shown have at least **10 jobs with salary information**, as required.
* Netflix also has a relatively large number of salary-reported jobs, with **44 postings**.
* Genentech has **41 jobs** with an average yearly salary of **$216,755**.
* The results show that companies with high average salaries can still have a meaningful number of job postings, rather than the averages being based on only one or two jobs.

┌───────────────────────────┬───────────────────────┬────────────────┐
│       company_name        │ average_yearly_salary │ number_of_jobs │
│          varchar          │        double         │     int64      │
├───────────────────────────┼───────────────────────┼────────────────┤
│ Netflix                   │              400060.0 │             44 │
│ Eleven Recruiting         │              320909.0 │             22 │
│ Algo Capital Group        │              307188.0 │             16 │
│ Bedrock Ocean Exploration │              275000.0 │             17 │
│ Edge & Node               │              267000.0 │             12 │
│ Engtal                    │              253077.0 │             13 │
│ The Browser Company       │              252273.0 │             22 │
│ Roblox                    │              235383.0 │             29 │
│ MVP Health Care           │              232415.0 │             23 │
│ Asana                     │              229864.0 │             11 │
│ Snap Inc.                 │              229581.0 │             31 │
│ Demandbase                │              222302.0 │             10 │
│ NVIDIA                    │              219712.0 │             29 │
│ Glocomms                  │              217974.0 │             19 │
│ Genentech                 │              216755.0 │             41 │
└───────────────────────────┴───────────────────────┴────────────────┘
*/