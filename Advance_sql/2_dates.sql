SELECT 
   COUNT(job_id) AS job_posted_count,
   EXTRACT(MONTH FROM job_posted_date) AS MONTH
FROM
   job_postings_fact
WHERE
    job_title_short='Data Analyst'
GROUP BY
   MONTH
ORDER BY
   job_posted_count DESC;