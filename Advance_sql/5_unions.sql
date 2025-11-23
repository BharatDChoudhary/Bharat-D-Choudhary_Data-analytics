SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs
