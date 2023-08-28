/*Exercitiul 1*/
SELECT
    e.employee_id,
    e.job_id,
    TO_CHAR(e.hire_date,'YYYY'),
    TO_CHAR(e.hire_date, 'MONTH')
FROM restaurant_employees e
ORDER BY e.hire_date ASC


/*Exercitiul 2*/
SELECT
    e.country_name,
    CASE 
        WHEN COUNT(c.employee_id) = 0 THEN 'nu sunt angajati' 
        ELSE TO_CHAR(COUNT(c.employee_id))
    END
FROM countries_employees e
LEFT OUTER JOIN location_employees d on d.country_id=e.country_id
LEFT OUTER JOIN restaurant_employees c on c.location_id=d.location_id
GROUP BY e.country_name

/*Exercitiul 3*/
SELECT
    d.department_name,
    AVG(e.salary)
FROM restaurant_departments d
JOIN restaurant_jobs c ON c.department_id = d.department_id
JOIN restaurant_employees e ON e.job_id = c.job_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 
    (
        SELECT
            AVG(e.salary)
        FROM restaurant_employees e
    )

/*Exercitiul 4*/
SELECT
    m.menu_id,
    m.menu_name,
    CASE
        WHEN sum(n.quantity) >=
            (SELECT SUM(d.quantity)/3
             FROM order_menu d
            )THEN 'FOARTE POPULAR'
        WHEN sum(n.quantity) >=
            (SELECT SUM(d.quantity)/5
             FROM order_menu d
            )THEN 'POPULAR'
        ELSE 'NU ESTE POPULAR'
    END
FROM menus m
JOIN order_menu n ON n.menu_id = m.menu_id
GROUP BY m.menu_id, m.menu_name