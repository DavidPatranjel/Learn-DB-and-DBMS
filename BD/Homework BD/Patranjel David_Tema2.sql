/*Exercitiul 22*/
SELECT e.last_name,
        e.department_id,
        e.salary
FROM employees e
WHERE e.commission_pct IS NULL AND e.manager_id IN
    (SELECT d.employee_id
    FROM employees d
    WHERE NOT(d.commission_pct IS NULL))
	
/*Exercitiul 23*/
SELECT e.last_name,
        e.department_id,
        e.salary,
        e.job_id
FROM employees e
WHERE (e.salary,e.commission_pct) IN
    (SELECT d.salary,
            d.commission_pct
    FROM employees d
    JOIN departments c ON d.department_id = c.department_id
    WHERE c.location_id IN
        (SELECT b.location_id
        FROM locations b
        WHERE LOWER(b.city) = 'oxford'
        )
    )

/*Exercitiul 24*/

SELECT e.last_name,
        e.department_id,
        e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location_id IN
    (SELECT c.location_id
    FROM locations c
    WHERE LOWER(c.city) = 'toronto'
    )