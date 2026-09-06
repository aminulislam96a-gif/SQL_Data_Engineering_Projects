SELECT
    jpf.job_id,
    jpf.job_title_short,
    ARRAY_AGG(sd.skills) AS array_of_skills,
    cd.name AS company_name
from job_postings_fact as jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
LEFT JOIN skills_job_dim AS sjd 
ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim sd 
ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

SELECT
    sjd.skill_id,
    sd.skills
FROM skills_dim AS sd
RIGHT JOIN skills_job_dim as sjd 
ON sjd. skill_id = sd.skill_id;