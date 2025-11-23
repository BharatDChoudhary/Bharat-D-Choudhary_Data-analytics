# Introduction
📊 Dive into the data job market ! Focusing on data analyst roles, this project explores 💰 top-paying
jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [Project_sql folder](/Project_sql/)

# Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from [SQL Course] (https:// lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-t for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

🚀 Data Analyst Job Market Analysis 2023: Unlocking High-Value Skills This project investigates the 2023 data analyst job market, focusing on salary potential, in-demand technical skills, and identifying the most optimal skills for career growth.

**💰 1. Top Earning Potential Top Salaries:** The highest-paying remote Data Analyst roles show a massive salary potential, spanning from $184,000 to $650,000 annually.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Diverse Opportunities: High salaries aren't exclusive to one sector; companies like SmartAsset, Meta, and AT&T are all featured, showcasing broad industry demand.

Role Variety: The top-paying positions have diverse titles, from "Data Analyst" to "Director of Analytics," reflecting varied responsibility levels.



**🛠️ 2. Skills Driving Top Salaries:** To command the highest salaries, proficiency in the following skills is key (based on the top 10 paying jobs):

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```


| Skill | Demand Count (Out of 10) |
| :--- | :--- |
| **SQL** | **8** |
| **Python** | **7** |
| **Tableau** | **6** |
| R | Varies |
| Snowflake | Varies |
| Pandas | Varies |
| Excel | Varies |




**📈 3. Overall In-Demand Skills:** This highlights the foundational and technical skills most frequently requested across all Data Analyst job postings:

```sql
SELECT 
   skills,
   COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

Foundational Core: SQL and Excel are consistently fundamental requirements for data processing and manipulation.

Technical Essentials: Python, Tableau, and Power BI are essential for programming, data storytelling, and decision support.



**💎 4. Highest-Paying Skills:** Not all skills are paid equally. The highest salaries are linked to expertise in advanced, specialized technologies:

```sql
SELECT 
   skills,
   ROUND (AVG(salary_year_avg), 0) AS avg_salary

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
   avg_salary DESC
LIMIT 25
```

Big Data & ML: Skills like PySpark, Couchbase, DataRobot, Pandas, and NumPy command top salaries, reflecting the high value placed on processing big data and predictive modeling.

DevOps & Deployment: Knowledge of tools like GitLab, Kubernetes, and Airflow indicates a lucrative crossover with data engineering and automation.

Cloud Platforms: Expertise in Elasticsearch, Databricks, and GCP underscores the premium placed on proficiency in cloud-based analytics environments.



**✅ 5. The Most Optimal Skills to Learn (High Demand + High Salary)**

By combining demand and salary data, this identifies the most strategic areas for skill development:

```sql
WITH skills_demand AS (
    SELECT 
       skills_dim.skill_id,
       skills_dim.skills,
       COUNT (skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND (AVG(salary_year_avg), 0) AS avg_salary

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY
     avg_salary DESC,
     demand_count DESC
limit 25
```

| Skill Focus | Key Tools/Languages | Average Salary (Approx.) | Strategic Value |
| :--- | :--- | :--- | :--- |
| **Programming** | Python (Demand: 236), R (Demand: 148) | ~$100,499 - $101,397 | High demand, fundamental for complex analysis. |
| **Cloud/Big Data** | Snowflake, Azure, AWS, BigQuery | ~$99,760 - $103,425 | High-value, future-proof skills for cloud-based platforms. |
| **BI/Visualization** | Tableau (Demand: 230), Looker (Demand: 49) | ~$99,288 - $103,795 | Critical for transforming data into actionable business insights. |
| **Database Tech** | Oracle, SQL Server, NoSQL | ~$97,786 - $104,534 | Enduring need for robust data management and retrieval. |

# What I Learned
Throughout this adventure, I’ve turbocharged my SQL toolkit with some serious firepower:

- **🧩Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table manoeuvres.

- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.

- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusion
*This project enhanced my SQL skills and provided valuable insights into the data analyst job market.The findings from the analysis serve as a guide to prioritizing skill development and search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills.This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.*