-- CTE: Count skills used in remote Data Analyst job postings
WITH remote_job_skills AS (
    SELECT
        sj.skill_id,          -- ID of the skill
        COUNT(*) AS skill_count   -- number of postings requiring this skill
    FROM skills_job_dim AS sj
    INNER JOIN job_postings_fact AS jp 
        ON jp.job_id = sj.job_id
    WHERE 
        jp.job_work_from_home = TRUE        -- remote jobs only
        AND jp.job_title_short = 'Data Analyst'  -- restrict to Data Analyst roles
    GROUP BY sj.skill_id
)

-- Join skill counts with skill names
SELECT
    sd.skill_id,
    sd.skills AS skill_name,   -- actual skill text
    rjs.skill_count
FROM remote_job_skills AS rjs
INNER JOIN skills_dim AS sd 
    ON sd.skill_id = rjs.skill_id
ORDER BY 
    rjs.skill_count DESC
LIMIT 5;   -- top 5 skills
