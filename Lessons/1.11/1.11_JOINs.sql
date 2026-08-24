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
/*
Find each company and determine how many different skills
 are required across all of its job postings.
company_name | number_of_different_skills
Only show companies that require more than 10 different skills.
Sort from the largest number of skills to the smallest.
*/
select 
cd.name,
count(DISTINCT sd.skills)as number_of_skill
from
  company_dim as cd 
  left join  job_postings_fact as jpf
  on cd.company_id = jpf.company_id
  
  left join skills_job_dim as sjd
  on sjd.job_id = jpf.job_id

  left join skills_dim as sd
  on sd.skill_id = sjd.skill_id
  group by 
    cd.name,
    cd.company_id
  having count(DISTINCT sd.skills)>10
  order by count(DISTINCT sd.skills) DESC 
  LIMIT 20;
  
  /*
The results show which companies require the largest variety of different skills across all of their job postings.

**Emprego** ranks highest with **206 different skills**, followed closely by **beBee Careers** with **202 skills**. **Dice** also has a very high number of unique skills at **184**.

Several large recruiting platforms and employers appear near the top of the list, including **Randstad, CareerBuilder, Insight Global, Hays, IBM, Capgemini, Tata Consultancy Services, Deloitte, and Upwork**.

The high number of different skills suggests that these companies or platforms post jobs across many different technical areas and job roles. As a result, they require a wider range of skills compared with companies that hire for fewer types of positions.

Key takeaways:

* Emprego requires the highest number of different skills with **206**.
* beBee Careers follows with **202 different skills**.
* Dice ranks third with **184 skills**.
* Major companies such as IBM, Capgemini, Tata Consultancy Services, and Deloitte each require more than **150 different skills**.
* Recruiting and job-posting platforms tend to have a high number of unique skills because they contain many different types of job postings.
* Using `COUNT(DISTINCT skills)` ensures that each skill is counted only once for each company, even if the same skill appears in multiple job postings.

  ┌───────────────────────────┬─────────────────┐
│           name            │ number_of_skill │
│          varchar          │      int64      │
├───────────────────────────┼─────────────────┤
│ Emprego                   │             206 │
│ beBee Careers             │             202 │
│ Dice                      │             184 │
│ confidential              │             182 │
│ Jobs via Dice             │             175 │
│ Confidential              │             175 │
│ Confidenziale             │             165 │
│ Randstad                  │             165 │
│ ClickJobs.io              │             165 │
│ CareerBuilder             │             163 │
│ Insight Global            │             161 │
│ Hays                      │             158 │
│ IBM                       │             157 │
│ Capgemini                 │             157 │
│ Tata Consultancy Services │             157 │
│ Deloitte                  │             155 │
│ Knewin                    │             153 │
│ Upwork                    │             151 │
│ ClearanceJobs             │             150 │
│ Michael Page              │             150 │
└───────────────────────────┴─────────────────┘
*/
/*
Find the average yearly salary for each skill.
Requirements:

Only include jobs where salary_year_avg is not NULL.
Only show skills with an average yearly salary greater than $100,000.
Sort from highest average salary to lowest.
Show only the top 10 skills.
*/

SELECT 
    sd.skills,
    ROUND(avg(jpf.salary_year_avg),0)
    as average_yearly_salary
from 
    job_postings_fact as jpf
inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id

inner join skills_dim as sd
on sd.skill_id = sjd.skill_id

where salary_year_avg is not null 
group by
      sd.skills
  having avg(jpf.salary_year_avg)>100000
order by avg(jpf.salary_year_avg) DESC
limit 10;
/*
The results show the top 10 skills with the highest average yearly salaries for jobs that provide salary information.

**Fedora** ranks first with an average yearly salary of **$182,350**, followed by **Mongo** at **$173,411** and **Debian** at **$164,891**.

Several programming and development technologies also appear among the highest-paying skills. **Node** has an average yearly salary of **$161,556**, while **Haskell** and **Rust** average around **$159,943** and **$159,664**.

Other high-paying skills include **APL (A Programming Language)** at **$155,714**, **Golang (Go programming language)** at **$155,483**, **Hugging Face** at **$154,555**, and **Solidity** at **$154,308**.

Key takeaways:

* Fedora has the highest average yearly salary at **$182,350**.
* Mongo ranks second with an average salary of **$173,411**.
* Fedora and Debian show that Linux-related technologies are associated with high-paying jobs.
* Programming languages such as Haskell, Rust, APL, Go, and Solidity are strongly represented.
* Hugging Face highlights the value of **AI (Artificial Intelligence)** and **ML (Machine Learning)** related skills.
* All of the top 10 skills have average yearly salaries above **$154,000**.

┌──────────────┬───────────────────────┐
│    skills    │ average_yearly_salary │
│   varchar    │        double         │
├──────────────┼───────────────────────┤
│ fedora       │              182350.0 │
│ mongo        │              173411.0 │
│ debian       │              164891.0 │
│ node         │              161556.0 │
│ haskell      │              159943.0 │
│ rust         │              159664.0 │
│ apl          │              155714.0 │
│ golang       │              155483.0 │
│ hugging face │              154555.0 │
│ solidity     │              154308.0 │
*/

/*
Find the companies that have the highest number of Data
 Engineer job postings.
 Requirements:
Only count jobs where job_title_short = 'Data Engineer'.
Only show companies that have more than 5 Data Engineer jobs.
Sort from the highest number of jobs to lowest.
Show only the top 10 companies.
*/

SELECT 
    cd.name as company_name,
    count(jpf.job_title_short) as number_of_postings
from 
    job_postings_fact as jpf

left join company_dim as cd
on cd.company_id = jpf.company_id

where jpf.job_title_short ='Data Engineer' 
group by 
    cd.name
having count(jpf.job_title_short)>5
order by count(jpf.job_title_short) DESC
limit 10;
/*
The results show the top 10 companies with the highest number of **Data Engineer** job postings.

**beBee Careers** ranks first with **5,880 Data Engineer postings**, followed by **Listopro** with **3,649** and **Dice** with **2,889**.

Among major employers, **Capital One** has **2,346 postings**, while **Amazon** has **1,989**. **Tata Consultancy Services** also shows strong hiring activity with **1,819 Data Engineer jobs**.

Other companies in the top 10 include **IBM** with **1,339 postings**, **Capgemini** with **1,300**, **Jobs via Dice** with **1,273**, and **Emprego** with **1,214**.

Key takeaways:

* beBee Careers has the highest number of Data Engineer job postings with **5,880**.
* Listopro and Dice also have a very large number of Data Engineer opportunities.
* Capital One and Amazon are among the strongest direct employers in the results.
* Tata Consultancy Services, IBM, and Capgemini show strong demand for Data Engineers.
* Some names, such as Dice, Jobs via Dice, beBee Careers, and Emprego, may represent job platforms or recruiting sources rather than only direct employers.
* All companies shown have more than 5 Data Engineer postings, as required by the query.
┌───────────────────────────┬────────────────────┐
│       company_name        │ number_of_postings │
│          varchar          │       int64        │
├───────────────────────────┼────────────────────┤
│ beBee Careers             │               5880 │
│ Listopro                  │               3649 │
│ Dice                      │               2889 │
│ Capital One               │               2346 │
│ Amazon                    │               1989 │
│ Tata Consultancy Services │               1819 │
│ IBM                       │               1339 │
│ Capgemini                 │               1300 │
│ Jobs via Dice             │               1273 │
│ Emprego                   │               1214 │
└───────────────────────────┴────────────────────┘
*/
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