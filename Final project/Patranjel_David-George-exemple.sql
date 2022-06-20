/*Cerinta 11*/

/*EX1: Categoria unei competitii este reprezentata de cel mai frecvent tip de proba din acea competitie. 
De ex. Daca competitia X are 10 probe acvatice si 6 artistice, se considera o competitie din categoria acvatica
Sa se afiseze pentru fiecare competitie numele competitiei, categoria din care face parte, si orasul in care se 
desfasoara tipul de proba respectiv, grupate(ordonate) dupa categoria competitiei */

WITH tabel1 AS (
    SELECT
        C.ID_COMPETITIE, C.NUME_COMPETITIE, P.TIP_PROBA,
        ROW_NUMBER() OVER (PARTITION BY C.ID_COMPETITIE, C.NUME_COMPETITIE ORDER BY COUNT(P.TIP_PROBA) DESC, P.TIP_PROBA) nr
    FROM COMPETITIE C
    JOIN RUNDA R ON C.ID_COMPETITIE = R.ID_COMPETITIE
    JOIN PROBA P ON R.ID_RUNDA = P.ID_RUNDA
    GROUP BY C.ID_COMPETITIE,  C.NUME_COMPETITIE, P.TIP_PROBA
    )
 SELECT
     T.NUME_COMPETITIE,
     DECODE(T.TIP_PROBA, 'acvatic', 'categoria acvatica',
         'artistic', 'categoria artistica',
         'aspect', 'categoria de aspect',
         'traseu', 'categoria traseu',
         'viteza', 'categoria viteza',
         'null') as CATEGORIA,
     L.ORAS
 FROM tabel1 T
 JOIN LOCATIE L ON T.TIP_PROBA = L.TIP_PROBA
 WHERE T.nr = 1
ORDER BY CATEGORIA;

/*EX2: Sa se afiseze toti participantii experimentati ce au participat la ultimul
concurs cu cel mult cinci ani inainte de data curenta si care participa la o competitie
cu cel putin doi jurati*/

SELECT
    PE.ID_PARTICIPANT,
    P.NUME_PARTICIPANT,
    P.PRENUME_PARTICIPANT
FROM PARTICIPANT_EXPERIMENTAT PE
JOIN PARTICIPANT P on PE.ID_PARTICIPANT = P.ID_PARTICIPANT
WHERE ROUND(MONTHS_BETWEEN(SYSDATE, PE.ULTIMA_COMPETITIE)) <= 5*12 AND PE.ID_PARTICIPANT IN(
    SELECT
        R.ID_PARTICIPANT
    FROM RELATIE_PART_COMP R
    JOIN COMPETITIE C2 on R.ID_COMPETITIE = C2.ID_COMPETITIE
    WHERE C2.ID_COMPETITIE IN(
        SELECT
            AUX.ID_COMPETITIE
        FROM(
            SELECT
                C3.ID_COMPETITIE,
                COUNT(J.ID_JURAT)
            FROM COMPETITIE C3
            JOIN JURAT J on C3.ID_COMPETITIE = J.ID_COMPETITIE
            GROUP BY C3.ID_COMPETITIE
            HAVING COUNT(J.ID_JURAT) > 1) AUX
        )
    )

/*EX3: Sa se afiseze id-ul, numele si starea vaccinarii cateilor de
talie mica, si numarul de competitii la care participa. Daca numele sau
starea vaccinarii nu exista, va aparea Necunoscut*/

WITH CATEL_TALIE_MICA AS (
SELECT
    C.ID_CATEL,
    C.ID_PARTICIPANT,
    NVL(C.NUME_CATEL,'Necunoscut') as NUME_CATEL,
    CASE
        WHEN C.VACCINAT = 'T' THEN 'YES'
        WHEN C.VACCINAT = 'F' THEN 'NO'
        WHEN C.VACCINAT IS NULL THEN 'Necunoscut'
        ELSE '-'
    END as STARE_VACCINARE
    FROM CATEL C
    WHERE LOWER(C.TALIE) = 'mica'
)

SELECT
    CTM.ID_CATEL,
    CTM.NUME_CATEL,
    CTM.STARE_VACCINARE,
    COUNT(RPC.ID_COMPETITIE) AS NR_COMPETITII
FROM CATEL_TALIE_MICA CTM
JOIN PARTICIPANT P on CTM.ID_PARTICIPANT = P.ID_PARTICIPANT
JOIN RELATIE_PART_COMP RPC on P.ID_PARTICIPANT = RPC.ID_PARTICIPANT
GROUP BY(CTM.ID_CATEL,
    CTM.NUME_CATEL,
    CTM.STARE_VACCINARE)
	
/*EX4: Sa se afiseze probele ce au o durata mai mare decat media duratelor
din tipul de proba respectiv si ale caror runda au loc cel mai devreme dintre toate
rundele ce au loc in acelasi an. Pentru fiecare dintre acestea se vor afisa numele si
id-ul rundei si durata probei*/

SELECT
    R.NUME_RUNDA,
    R.ID_RUNDA,
    P.ID_PROBA,
    P.DURATA_PROBA
FROM PROBA P
JOIN RUNDA R on P.ID_RUNDA = R.ID_RUNDA
WHERE P.DURATA_PROBA >= (
    SELECT
        AVG(P1.DURATA_PROBA)
    FROM PROBA P1
    WHERE P1.TIP_PROBA = P.TIP_PROBA
    ) AND R.DATA_RUNDA IN(
        SELECT
            MIN(R2.DATA_RUNDA)
        FROM RUNDA R2
        WHERE EXTRACT(YEAR FROM R2.DATA_RUNDA) = EXTRACT(YEAR FROM R.DATA_RUNDA)
    )
ORDER BY R.NUME_RUNDA, P.ID_PROBA



/*EX5:Se poate genera un cod unic pentru fiecare runda astfel:
prima litera din numele rundei, urmat de cinci numere, fiecare reprezentand
frecventa vocalelor a,e,i,o,u in numele rundei. Sa se afiseze codul unic pentu
toate rundele desfasurate in lunile de septembrei, octombrie sau noiembrie ale
anului trecut*/

SELECT
    R.NUME_RUNDA,
    CONCAT(CHR(ASCII(R.NUME_RUNDA)),
           CONCAT(LENGTH(R.NUME_RUNDA) - LENGTH(REPLACE(LOWER(R.NUME_RUNDA), 'a', '')),
                  CONCAT(LENGTH(R.NUME_RUNDA) - LENGTH(REPLACE(LOWER(R.NUME_RUNDA), 'e', '')),
                         CONCAT(LENGTH(R.NUME_RUNDA) - LENGTH(REPLACE(LOWER(R.NUME_RUNDA), 'i', '')),
                                CONCAT(LENGTH(R.NUME_RUNDA) - LENGTH(REPLACE(LOWER(R.NUME_RUNDA), 'o', '')),
                                       CONCAT(LENGTH(R.NUME_RUNDA) - LENGTH(REPLACE(LOWER(R.NUME_RUNDA), 'u', '')),''
                                           )
                                    )
                             )
                      )
               )
        ) as COD
FROM RUNDA R
WHERE (EXTRACT(YEAR FROM R.DATA_RUNDA) = EXTRACT(YEAR FROM SYSDATE)-1) AND (TO_CHAR(R.DATA_RUNDA, 'MM') BETWEEN 9 AND 11)
ORDER BY R.NUME_RUNDA;

/*Cerinta 12*/

/*EX1: Sa se mareasca cu 10 nr de exemplare ale acelor forme publicitare ce sunt folosite mai
mult de 3 competitii diferite (si sponsori diferiti)*/

UPDATE PUBLICITATE
SET NR_EXEMPLARE = NR_EXEMPLARE + 10
WHERE ID_PUBLICITATE IN (SELECT AUX.ID_PUBLICITATE
                         FROM (SELECT PS.ID_PUBLICITATE,
                                      COUNT(PS.ID_COMPETITIE)
                               FROM PROMOVEAZA_SPONSOR PS
                               GROUP BY PS.ID_PUBLICITATE
                               HAVING COUNT(PS.ID_COMPETITIE) >= 4) AUX)

/*EX2:Sa se stearga toate echipamentele folosite in cadrul competitiei cu cel mai mic premiu*/

DELETE FROM  RELATIE_ECH_COMP RCH
WHERE RCH.ID_ECHIPAMENT IN(
    SELECT R.ID_ECHIPAMENT
    FROM RELATIE_ECH_COMP R
        JOIN (SELECT *
        FROM COMPETITIE C1
        WHERE C1.PREMIU_COMPETITIE = (
            SELECT MIN(C2.PREMIU_COMPETITIE)
                FROM COMPETITIE C2
        )AND ROWNUM = 1) MP ON MP.ID_COMPETITIE = R.ID_COMPETITIE
    )
DELETE FROM ECHIPAMENT E
WHERE E.ID_ECHIPAMENT IN(
    SELECT R.ID_ECHIPAMENT
    FROM RELATIE_ECH_COMP R
        JOIN (SELECT *
        FROM COMPETITIE C1
        WHERE C1.PREMIU_COMPETITIE = (
            SELECT MIN(C2.PREMIU_COMPETITIE)
                FROM COMPETITIE C2
        )AND ROWNUM = 1) MP ON MP.ID_COMPETITIE = R.ID_COMPETITIE
    )
	
/*EX3:Sa se mareasca cu o ora fiecare proba care are loc intr-un
oras ce incepe cu litera B*/

UPDATE PROBA P
SET P.DURATA_PROBA = P.DURATA_PROBA + 1
WHERE P.TIP_PROBA IN(
    SELECT
        L.TIP_PROBA
    FROM LOCATIE L
    WHERE UPPER(L.ORAS) LIKE 'B%'
    )

/*Cerinta 13*/

CREATE SEQUENCE INCR
    START WITH     110
    INCREMENT BY   1
    NOCACHE
    NOCYCLE
INSERT INTO JURAT
VALUES(INCR.nextval,5, 'Mircea', 'Willson', 21);

/*Cerinta 14*/

CREATE VIEW VIEW_COMPETITIE_JURAT4 AS
(
    SELECT DISTINCT
        C.ID_COMPETITIE,
        C.PREMIU_COMPETITIE,
        J.ID_JURAT,
        J.NUME_JURAT,
        J.PRENUME_JURAT
    FROM COMPETITIE C
    JOIN JURAT J on C.ID_COMPETITIE = J.ID_COMPETITIE
    WHERE C.NR_ZILE_COMPETITIE > 4
)

/*Operatie permisa*/
SELECT * FROM VIEW_COMPETITIE_JURAT4 ORDER BY ID_JURAT

/*Operatie nepermisa*/
DELETE FROM VIEW_COMPETITIE_JURAT4
WHERE ID_JURAT = 102

/*Cerinta 15*/

/*Sa se afiseze eficient juratul cu numele Andreea Zipea*/
CREATE INDEX IX_NUME_JURAT
ON JURAT(PRENUME_JURAT, NUME_JURAT)

SELECT
    J.ID_JURAT,
    J.PRENUME_JURAT,
    J.NUME_JURAT
FROM JURAT J
WHERE LOWER(J.PRENUME_JURAT) = 'andreea' AND LOWER(J.NUME_JURAT) = 'zipea';

DROP INDEX IX_NUME_JURAT

/*Cerinta 16*/

/*OUTER JOIN: 
Sa se afiseze o lista cu rundele competitiilor ce au probele de o durata de mai mult de doua ore si prioritatea lor astfel:
Prioritate A: Au in competitie o runda finala cu o a doua proba aflata afla 
intr-unul din primele doua orase dupa numarul de probe din acel oras 
Prioritate B: Au in competitie o runda finala cu o a doua proba si nu sunt in A
Prioritate C: Au in competitie o runda finala si nu sunt in B
Prioritate D: Nu au in competitie o runda finala si nu sunt in C*/

WITH PROBE_ORASE AS (SELECT P.TIP_PROBA,
                            P.ID_PROBA,
                            P.ID_RUNDA,
                            L.ORAS
                     FROM PROBA P
                              JOIN LOCATIE L on L.TIP_PROBA = P.TIP_PROBA
                     WHERE P.DURATA_PROBA > 2),
    ORASE_PRIORITATE AS(SELECT * FROM LOCATIE L WHERE L.ORAS IN (
                            SELECT ORAS FROM(
                                SELECT
                                    PO.ORAS,
                                    COUNT(*) AS NR_ORD
                                FROM PROBE_ORASE PO
                                GROUP BY PO.ORAS
                                ORDER BY NR_ORD DESC
                                FETCH FIRST 2 ROWS ONLY))),
    PROBA2_PRIORITATE AS(SELECT
                            OP.TIP_PROBA,
                            P.ID_RUNDA,
                            P.ID_PROBA
                        FROM ORASE_PRIORITATE OP
                        FULL OUTER JOIN PROBA P ON OP.TIP_PROBA = P.TIP_PROBA
                        WHERE P.ID_PROBA = 2),
    FINALE_PRIORITATE AS(SELECT
                            R.ID_COMPETITIE,
                            R.NUME_RUNDA,
                            P2.TIP_PROBA,
                            R.ID_RUNDA,
                            P2.ID_PROBA
                        FROM RUNDA R
                        FULL OUTER JOIN PROBA2_PRIORITATE P2 on R.ID_RUNDA = P2.ID_RUNDA
                        WHERE LOWER(R.NUME_RUNDA) LIKE 'finala%'
                        ORDER BY TIP_PROBA, ID_PROBA),
    COMP_PRIORITATE AS( SELECT
                            FP.ID_COMPETITIE,
                            FP.ID_RUNDA,
                            FP.ID_PROBA,
                            FP.TIP_PROBA,
                            C.NUME_COMPETITIE
                        FROM FINALE_PRIORITATE FP
                        FULL OUTER JOIN COMPETITIE C ON C.ID_COMPETITIE = FP.ID_COMPETITIE
    )


SELECT
    CP.NUME_COMPETITIE,
    NVL(TO_CHAR(CP.ID_RUNDA),'No priority round') as RUNDA,
    CASE
        WHEN CP.ID_COMPETITIE IS NULL THEN 'PRIORITATE D'
        WHEN CP.ID_PROBA IS NULL THEN 'PRIORITATE C'
        WHEN CP.TIP_PROBA IS NULL THEN 'PRIORITATE B'
        ELSE 'PRIORITATE A'
    END AS TIP
FROM COMP_PRIORITATE CP
ORDER BY RUNDA

/*DIVISION: Sa se listeze informaţii despre participantii care participa la toate competitiile
ce au drept premiu o suma mai mare de 500000$*/

/*METODA 1*/

SELECT DISTINCT R.ID_PARTICIPANT, P.NUME_PARTICIPANT, P.PRENUME_PARTICIPANT
FROM RELATIE_PART_COMP R
JOIN PARTICIPANT P on R.ID_PARTICIPANT = P.ID_PARTICIPANT
WHERE NOT EXISTS(SELECT C1.PREMIU_COMPETITIE
       FROM COMPETITIE C1
       WHERE C1.PREMIU_COMPETITIE >= 500000
       AND NOT EXISTS(SELECT R1.ID_PARTICIPANT
                     FROM RELATIE_PART_COMP R1
                     WHERE R1.ID_PARTICIPANT = R.ID_PARTICIPANT
                     AND R1.ID_COMPETITIE = C1.ID_COMPETITIE));
					 
/*METODA 2*/

WITH IDS AS(SELECT
                R.ID_PARTICIPANT
            FROM RELATIE_PART_COMP R
            JOIN COMPETITIE C ON R.ID_COMPETITIE = C.ID_COMPETITIE
            join PARTICIPANT P on P.ID_PARTICIPANT = R.ID_PARTICIPANT
            WHERE C.ID_COMPETITIE IN(SELECT
                                        C.ID_COMPETITIE
                                    FROM COMPETITIE C
                                    WHERE C.PREMIU_COMPETITIE >= 500000)
            GROUP BY R.ID_PARTICIPANT
            HAVING COUNT(C.ID_COMPETITIE) =(SELECT
                                                COUNT(C.ID_COMPETITIE)
                                            FROM COMPETITIE C
                                            WHERE C.PREMIU_COMPETITIE >= 500000))

SELECT
    P.ID_PARTICIPANT, P.NUME_PARTICIPANT, P.PRENUME_PARTICIPANT
FROM PARTICIPANT P
JOIN IDS S ON S.ID_PARTICIPANT = P.ID_PARTICIPANT

/*Cerinta 17*/
/*Etapa 1*/
SELECT
    C2.RASA, NVL(C2.NUME_CATEL, 'NESPECIFICAT'), P.NUME_PARTICIPANT
FROM CATEL C2
JOIN PARTICIPANT P on C2.ID_PARTICIPANT = P.ID_PARTICIPANT
WHERE P.VARSTA_PARTICIPANT IN(
    SELECT P1.VARSTA_PARTICIPANT
    FROM PARTICIPANT P1
    WHERE P.ID_PARTICIPANT = P1.ID_PARTICIPANT AND P1.VARSTA_PARTICIPANT <= 23 AND P.TIP_PARTICIPANT IN(
        SELECT P2.TIP_PARTICIPANT
        FROM PARTICIPANT P2
        WHERE P.ID_PARTICIPANT = P2.ID_PARTICIPANT AND UPPER(P2.TIP_PARTICIPANT) = 'NOU'
        )
    )
	
/*Etapa 2*/
SELECT
    C2.RASA, NVL(C2.NUME_CATEL, 'NESPECIFICAT'), P.NUME_PARTICIPANT
FROM CATEL C2
JOIN PARTICIPANT P on C2.ID_PARTICIPANT = P.ID_PARTICIPANT
WHERE P.VARSTA_PARTICIPANT <= 23 AND UPPER(P.TIP_PARTICIPANT) = 'NOU'

/*Etapa 3*/
SELECT
    C2.RASA, NVL(C2.NUME_CATEL, 'NESPECIFICAT'), P.NUME_PARTICIPANT
FROM(SELECT NUME_PARTICIPANT, ID_PARTICIPANT
     FROM PARTICIPANT
     WHERE VARSTA_PARTICIPANT <= 23 AND UPPER(TIP_PARTICIPANT) = 'NOU')P
JOIN(SELECT NUME_CATEL, RASA, ID_PARTICIPANT
     FROM CATEL)C2 ON C2.ID_PARTICIPANT=P.ID_PARTICIPANT