with tabel1 as(
SELECT
   o.employee_id,
   om.menu_id,
   SUM(om.quantity) as total_quantity
FROM orders o
FULL OUTER JOIN order_menu om ON o.order_id = om.order_id
GROUP BY o.employee_id, om.menu_id
ORDER BY o.employee_id
),

tabel2 as(
SELECT
    t1.employee_id,
    t1.menu_id
FROM tabel1 t1
JOIN 
    (
        SELECT 
            t2.employee_id,
            MAX(t2.total_quantity) qty
        FROM tabel1 t2
        GROUP BY t2.employee_id
    )taux
    ON t1.employee_id = taux.employee_id AND t1.total_quantity = taux.qty)
SELECT 
    e.last_name,
    e.meniu_maxim
FROM(
SELECT
    tab2.employee_id,
    re.last_name,
    CASE
        WHEN COUNT(tab2.menu_id) > 1 THEN 'mai multe meniuri de frecventa maxima servite'
        WHEN COUNT(tab2.menu_id) = 0 THEN 'niciun meniu servit'
        ELSE
            (
                SELECT
                    TO_CHAR(tab3.menu_id)
                    FROM tabel2 tab3
                    WHERE tab2.employee_id = tab3.employee_id
            )
    END as meniu_maxim
FROM tabel2 tab2
RIGHT OUTER JOIN restaurant_employees re ON tab2.employee_id = re.employee_id
WHERE re.job_id = 4 OR re.job_id = 5
GROUP BY tab2.employee_id, re.last_name) e

