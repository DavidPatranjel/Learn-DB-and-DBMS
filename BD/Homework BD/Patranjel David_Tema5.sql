/*Exercitiul 1*/
with last_job_date as(
    SELECT
        j.employee_id,
        MAX(j.end_date) as end_date1
    FROM job_history j
    GROUP BY j.employee_id
),
last_job as(
    SELECT
        j.employee_id,
        j.job_id,
        (jb.min_salary + jb.max_salary)/2 as avg_salary
    FROM job_history j
    JOIN last_job_date l on l.employee_id = j.employee_id
    JOIN jobs jb on j.job_id = jb.job_id
    WHERE l.end_date1 = j.end_date
),
old_new_job as(
    SELECT
        e.last_name,
        e.employee_id,
        e.job_id as actual_job,
        (jb.min_salary+jb.max_salary)/2 as avg_actual_salary,
        lj.job_id as old_job,
        lj.avg_salary as avg_old_salary    
    FROM employees e
    LEFT JOIN last_job lj on e.employee_id = lj.employee_id
    JOIN jobs jb on e.job_id = jb.job_id
)
SELECT
    o.last_name,
    CASE
        WHEN o.old_job IS NULL THEN 'nu a avut alt job'
        WHEN o.avg_actual_salary > o.avg_old_salary THEN 'promovat'
        WHEN o.avg_actual_salary = o.avg_old_salary THEN 'a pastrat nivelul'
        WHEN o.avg_actual_salary < o.avg_old_salary THEN 'penalizat'
    END AS upgrade_job
FROM old_new_job o
ORDER BY upgrade_job DESC

/*Exercitiul 2*/
with manager_city as(
    SELECT
        e.employee_id,
        e.last_name,
        e.first_name,
        e.job_id,
        l.city
    FROM employees e
    JOIN departments d on d.department_id = e.department_id
    JOIN locations l on l.location_id = d.location_id
    WHERE e.manager_id IS NULL
),
manager_employee_city as(
    SELECT 
        e.employee_id,
        e.last_name,
        e.first_name,
        l.city
    FROM employees e
    JOIN departments d on d.department_id = e.department_id
    JOIN locations l on l.location_id = d.location_id
    JOIN manager_city mc on mc.city = l.city
    WHERE NOT e.employee_id = mc.employee_id
),
subord as(
    SELECT
        e1.manager_id as employee_id,
        COUNT(*) as subord
    FROM employees e1
    GROUP BY e1.manager_id
    HAVING COUNT(*) > 2
)

SELECT
    m.last_name,
    m.first_name,
    s.subord
FROM manager_employee_city m
JOIN subord s ON s.employee_id = m.employee_id