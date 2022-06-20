/*Exercitiul 1*/
WITH minim AS(
SELECT * FROM(
SELECT
    s.cod_magazin,
    s.pret
FROM stoc s
WHERE s.cod_produs IN(
    SELECT
        p.id_produs
    FROM produs p
    WHERE LOWER(p.denumire) = 'nexus 7'
    )
ORDER BY s.pret)
WHERE ROWNUM = 1)

SELECT 
    m.denumire
FROM magazin m
JOIN minim mm ON mm.cod_magazin = m.id_magazin
/*Exercitiul 2*/
WITH ratings AS(
SELECT
    p.id_produs,
    p.denumire,
    s.cod_magazin,
    s.pret/p.user_rating as rating
FROM produs p
JOIN stoc s on p.id_produs = s.cod_produs
ORDER BY rating DESC
)

SELECT 
    id_produs,
    denumire,
    rating
FROM(
SELECT 
    *
FROM ratings r
WHERE r.cod_magazin IN(
SELECT 
    m.id_magazin
FROM magazin m
WHERE LOWER(m.denumire) LIKE 'emag'
)
)
WHERE ROWNUM = 1

/*Exercitiul 3*/
SELECT 
    c.id_categorie,
    c.denumire,
    prod.id_produs,
    prod.denumire
FROM producator pd
JOIN produs prod ON prod.cod_producator = pd.id_producator
JOIN categorie c on c.id_categorie = prod.cod_categorie
WHERE pd.service IS NOT NULL
ORDER BY c.denumire