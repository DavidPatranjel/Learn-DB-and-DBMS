/*Tema1 BD - Patranjel David-George 151*/

/*Exercitiul 1*/
SELECT e.last_name as Nume_angajat, e.department_id as Cod_departament, d.last_name as Nume_coleg
FROM employees e 
JOIN employees d ON e.department_id = d.department_id
WHERE NOT e.last_name = d.last_name;

/*Exercitiul 2*/
SELECT e.employee_id, e.salary, (d.max_salary/e.salary -1)*100
FROM employees e
JOIN jobs d ON e.job_id = d.job_id
WHERE e.salary > (d.min_salary + d.max_salary)/2;

/*Exercitul 3*/
SELECT CONCAT(CHR(ASCII(e.first_name)),CONCAT(' ', e.last_name)) as Nume,
        LENGTH(e.first_name)-LENGTH(REPLACE(LOWER(e.first_name),'a','')) as Litera_a,
        LENGTH(e.first_name)-LENGTH(REPLACE(LOWER(e.first_name),'e','')) as Litera_e,
        LENGTH(e.first_name)-LENGTH(REPLACE(LOWER(e.first_name),'i','')) as Litera_i,
        LENGTH(e.first_name)-LENGTH(REPLACE(LOWER(e.first_name),'o','')) as Litera_o,
        LENGTH(e.first_name)-LENGTH(REPLACE(LOWER(e.first_name),'u','')) as Litera_u
FROM employees e
WHERE (e.hire_date BETWEEN '01-JAN-90' AND '31-DEC-99') AND (TO_CHAR(e.hire_date, 'MM') BETWEEN 7 AND 9);