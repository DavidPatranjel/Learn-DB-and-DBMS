select * from dual;

/* CREARE TABEL PULBICITATE*/
create table publicitate
(
    id_publicitate  number(5)            not null
        constraint PUBLICITATE_PK
            primary key,
    tip_publicitate varchar2(30)         not null,
    nr_exemplare    number(3) default 20 not null
)
/

create unique index PUBLICITATE_ID_PUBLICITATE_UINDEX
    on publicitate (id_publicitate)
/


/* CREARE TABEL SPONSOR*/

create table sponsor
(
    id_sponsor    number(5)    not null
        constraint SPONSOR_PK
            primary key,
    nume_firma    varchar2(50) not null,
    oras_firma    varchar2(50) not null,
    manager_firma varchar2(40) not null
)
/

create unique index SPONSOR_ID_SPONSOR_UINDEX
    on sponsor (id_sponsor)
/


/* CREARE TABEL LOCATIE*/

create table locatie
(
    tip_proba varchar2(10) not null
        constraint LOCATIE_PK
            primary key,
    oras      varchar2(20) not null,
    strada    varchar2(20)
)
/

create unique index LOCATIE_TIP_PROBA_UINDEX
    on locatie (tip_proba)
/

/* CREARE TABEL PARTICIPANT*/

create table participant
(
    id_participant      number(5)    not null
        constraint PARTICIPANT_PK
            primary key,
    nume_participant    varchar2(20) not null,
    prenume_participant varchar2(30) not null,
    varsta_participant  number(2)    not null
)
alter table PARTICIPANT
    add tip_participant varchar2(20) not null
/
alter table PARTICIPANT rename column NUME_PARTICIPANT to aux
/
alter table PARTICIPANT rename column PRENUME_PARTICIPANT to NUME_PARTICIPANT
/
alter table PARTICIPANT rename column AUX to PRENUME_PARTICIPANT
/
alter table PARTICIPANT
    modify PRENUME_PARTICIPANT VARCHAR2(40)
/
/

create unique index PARTICIPANT_ID_PARTICIPANT_UINDEX
    on participant (id_participant)
/


/* CREARE TABEL PARTICIPANT NOU*/

create table participant_nou
(
    id_participant   number(5)  not null
        constraint PARTICIPANT_NOU_PK
            primary key,
    competitie_unica varchar2(1) not null
)
/

create unique index PARTICIPANT_NOU_ID_PARTICIPANT_UINDEX
    on participant_nou (id_participant)
/

ALTER TABLE participant_nou
ADD ( CONSTRAINT part_nou_part_fk
        	 FOREIGN KEY (id_participant)
          	  REFERENCES participant(id_participant)
    ) ;

/* CREARE TABEL PARTICIPANT EXPERIMENTAT*/

create table participant_experimentat
(
    id_participant    number(5) not null
        constraint PARTICIPANT_EXPERIMENTAT_PK
            primary key,
    ultima_competitie date      not null
)
/

create unique index PARTICIPANT_EXPERIMENTAT_ID_PARTICIPANT_UINDEX
    on participant_experimentat (id_participant)
/

ALTER TABLE participant_experimentat
ADD ( CONSTRAINT part_exp_part_fk
        	 FOREIGN KEY (id_participant)
          	  REFERENCES participant(id_participant)
    ) ;


/* CREARE TABEL CATEL*/

create table catel
(
    id_catel       number(5)    not null
        constraint CATEL_PK
            primary key,
    id_participant number(5)    not null,
    rasa           varchar2(30) not null,
    nume_catel     varchar2(20),
    varsta_catel   number(2),
    talie          varchar2(5)  not null,
    greutate       number(3, 2) not null,
    vaccinat       varchar2(1)
)

alter table CATEL
    modify RASA varchar2(50)
/
alter table CATEL
    modify GREUTATE number(5,2)
/
/

create unique index CATEL_ID_CATEL_UINDEX
    on catel (id_catel)
/

/* CREARE TABEL COMPETITIE*/

create table competitie
(
    id_competitie      number(5)    not null
        constraint COMPETITIE_PK
            primary key,
    nume_competitie    varchar2(20) not null,
    nr_zile_competitie number(3)    not null,
    premiu_competitie  number(10)   not null
)

/
alter table COMPETITIE
    modify NUME_COMPETITIE varchar2(60)
/
create unique index COMPETITIE_ID_COMPETITIE_UINDEX
    on competitie (id_competitie)
/

/* CREARE TABEL RUNDA*/

create table runda
(
    id_runda      number(5)    not null
        constraint RUNDA_PK
            primary key,
    id_competitie number(5)    not null,
    nume_runda    varchar2(30) not null,
    data_runda    date         not null
)
/

create unique index RUNDA_ID_RUNDA_UINDEX
    on runda (id_runda)
/
ALTER TABLE runda
ADD ( CONSTRAINT competitie_runda_fk
        	 FOREIGN KEY (id_competitie)
          	  REFERENCES competitie(id_competitie)
    ) ;

/* CREARE TABEL PROBA*/

create table proba
(
    id_proba     number(5)    not null,
    id_runda     number(5),
    tip_proba    varchar2(10) not null,
    durata_proba number(3)    not null
)
/

create unique index PROBA_ID_RUNDA_UINDEX
    on proba (id_runda)
DROP INDEX PROBA_ID_RUNDA_UINDEX;
/

ALTER TABLE proba
ADD ( CONSTRAINT proba_pk
       		 PRIMARY KEY (id_proba, id_runda)
    ) ;
ALTER TABLE proba
ADD ( CONSTRAINT runda_proba_fk
        	 FOREIGN KEY (id_runda)
          	  REFERENCES runda(id_runda)
    ) ;
ALTER TABLE proba
ADD ( CONSTRAINT locatie_proba_fk
        	 FOREIGN KEY (tip_proba)
          	  REFERENCES locatie(tip_proba)
    ) ;
/* CREARE TABEL JURAT*/

create table jurat
(
    id_jurat         number(5)    not null
        constraint JURAT_PK
            primary key,
    id_competitie    number(5)    not null,
    nume_jurat       varchar2(20) not null,
    prenume_jurat    varchar2(30) not null,
    experianta_jurat number(2)
)
/

create unique index JURAT_ID_JURAT_UINDEX
    on jurat (id_jurat)
/

ALTER TABLE jurat
ADD ( CONSTRAINT jurat_competitie_fk
        	 FOREIGN KEY (id_competitie)
          	  REFERENCES competitie(id_competitie)
    ) ;

alter table JURAT rename column NUME_JURAT to aux
/
alter table JURAT rename column PRENUME_JURAT to NUME_JURAT
/
alter table JURAT rename column AUX to PRENUME_JURAT
/
alter table JURAT
    modify PRENUME_JURAT VARCHAR2(40)
/

/* CREARE TABEL SPONSOR*/

create table sponsor
(
    id_sponsor    number(5)    not null
        constraint SPONSOR_PK
            primary key,
    nume_firma    varchar2(50) not null,
    oras_firma    varchar2(50) not null,
    manager_firma varchar2(40) not null
)
/

create unique index SPONSOR_ID_SPONSOR_UINDEX
    on sponsor (id_sponsor)
/

alter table SPONSOR
    drop column MANAGER_FIRMA
/

alter table SPONSOR
    add nume_manager varchar2(20) not null
/

alter table SPONSOR
    add prenume_manager varchar2(30) not null
/

alter table SPONSOR rename column NUME_MANAGER to aux
/
alter table SPONSOR rename column PRENUME_MANAGER to NUME_MANAGER
/
alter table SPONSOR rename column AUX to PRENUME_MANAGER
/
alter table SPONSOR
    modify PRENUME_MANAGER VARCHAR2(40)
/
/* CREARE TABEL RELATIE_PART_COMP*/

create table relatie_part_comp
(
    id_relatie_pc number(5) not null
        constraint RELATIE_PART_COMP_PK
            primary key,
    id_participant number(5) not null,
    id_competitie  number(5) not null
)
/

create unique index RELATIE_PART_COMP_ID_RELATIE_PC_UINDEX
    on relatie_part_comp (id_relatie_pc)
/

ALTER TABLE relatie_part_comp
ADD ( CONSTRAINT relatie_part_comp1_fk
        	 FOREIGN KEY (id_competitie)
          	  REFERENCES competitie(id_competitie)
    ) ;


ALTER TABLE relatie_part_comp
ADD ( CONSTRAINT relatie_part_comp2_fk
        	 FOREIGN KEY (id_participant)
          	  REFERENCES participant(id_participant)
    ) ;


/* CREARE TABEL ECHIPAMENT*/

create table echipament
(
    id_echipament       number(5)    not null
        constraint ECHIPAMENT_PK
            primary key,
    nume_echipament     varchar2(30) not null,
    material            varchar2(20),
    greutate_echipament number(4)
)
/

create unique index ECHIPAMENT_ID_ECHIPAMENT_UINDEX
    on echipament (id_echipament)
/

/* CREARE TABEL RELATIE_ECH_COMP*/

create table relatie_ech_comp
(
    id_relatie_ec number(5) not null
        constraint RELATIE_ECH_COMP_PK
            primary key,
    id_echipament number(5) not null,
    id_competitie number(5) not null
)
/

create unique index RELATIE_ECH_COMP_ID_RELATIE_EC_UINDEX
    on relatie_ech_comp (id_relatie_ec)
/

ALTER TABLE relatie_ech_comp
ADD ( CONSTRAINT relatie_ech_comp1_fk
        	 FOREIGN KEY (id_echipament)
          	  REFERENCES echipament(id_echipament)
    ) ;


ALTER TABLE relatie_ech_comp
ADD ( CONSTRAINT relatie_ech_comp2_fk
        	 FOREIGN KEY (id_competitie)
          	  REFERENCES competitie(id_competitie)
    ) ;

/* CREARE TABEL PROMOVEAZA_SPONSOR*/

create table promoveaza_sponsor
(
    id_relatie_pcs number(5) not null
        constraint PROMOVEAZA_SPONSOR_PK
            primary key,
    id_publicitate number(5) not null,
    id_competitie  number(5) not null,
    id_sponsor     number(5) not null
)
/

create unique index PROMOVEAZA_SPONSOR_ID_RELATIE_PCS_UINDEX
    on promoveaza_sponsor (id_relatie_pcs)
/

ALTER TABLE promoveaza_sponsor
ADD ( CONSTRAINT promoveaza_sponsor1_fk
        	 FOREIGN KEY (id_competitie)
          	  REFERENCES competitie(id_competitie)
    ) ;


ALTER TABLE promoveaza_sponsor
ADD ( CONSTRAINT promoveaza_sponsor2_fk
        	 FOREIGN KEY (id_sponsor)
          	  REFERENCES sponsor(id_sponsor)
    ) ;
ALTER TABLE promoveaza_sponsor
ADD ( CONSTRAINT promoveaza_sponsor3_fk
        	 FOREIGN KEY (id_publicitate)
          	  REFERENCES publicitate(id_publicitate)
    ) ;

/* ALTER PE COLOANA */

ALTER TABLE PARTICIPANT
ADD ( CONSTRAINT participant_varsta_min
        	 CHECK(VARSTA_PARTICIPANT >= 18)
    ) ;

ALTER TABLE CATEL
ADD(
    CONSTRAINT catel_varsta_min
    CHECK ( VARSTA_CATEL >= 2)
    );

ALTER TABLE COMPETITIE
ADD(
    CONSTRAINT premiu_vals
    CHECK ( PREMIU_COMPETITIE between 10000 and 1000000)
    );
	
/* INSERT VALUES */
INSERT INTO PARTICIPANT VALUES
(1001, 'Mihai', 'Popescu', 20, 'nou');
INSERT INTO PARTICIPANT VALUES
(1002, 'Alexandru', 'Francis', 48, 'experimentat');
INSERT INTO PARTICIPANT VALUES
(1003, 'Ana-Maria', 'Mihaita', 38, 'experimentat');
INSERT INTO PARTICIPANT VALUES
(1004, 'Alexandra', 'Petricescu', 24, 'nou');
INSERT INTO PARTICIPANT VALUES
(1005, 'Mircea', 'Ivanovici', 50, 'experimentat');
INSERT INTO PARTICIPANT VALUES
(1006, 'Elena', 'Atanasiu', 23, 'nou');

INSERT INTO PARTICIPANT_EXPERIMENTAT VALUES
(1002, TO_DATE('21-SEP-2015', 'dd-MON-yyyy'));
INSERT INTO PARTICIPANT_EXPERIMENTAT VALUES
(1003, TO_DATE('15-OCT-2017', 'dd-MON-yyyy'));
INSERT INTO PARTICIPANT_EXPERIMENTAT VALUES
(1005, TO_DATE('11-JAN-2019', 'dd-MON-yyyy'));

INSERT INTO PARTICIPANT_NOU VALUES
(1001, 'T');
INSERT INTO PARTICIPANT_NOU VALUES
(1004, 'T');
INSERT INTO PARTICIPANT_NOU VALUES
(1006, 'F');

INSERT INTO CATEL VALUES
(10011, 1001, 'Bison', 'Pecky', 7, 'mica', 8, 'T');
INSERT INTO CATEL VALUES
(10012, 1001, 'Golden Retriever', 'Ruffus', 5, 'mare', 28.35, 'T');
INSERT INTO CATEL VALUES
(10021, 1002, 'Ciobanesc German', 'Albert', 7, 'mare', 31.2, 'F');
INSERT INTO CATEL VALUES
(10031, 1003, 'Bison', NULL, 14, 'medie', 31.1, 'T');
INSERT INTO CATEL VALUES
(10041, 1004, 'Golden Retriever', 'Pecky', 4, 'medie', 25.75, NULL);
INSERT INTO CATEL VALUES
(10051, 1005, 'Bulldog Englez', NULL , NULL, 'mica', 8.3, 'T');
INSERT INTO CATEL VALUES
(10061, 1006, 'Pudel', 'Pecky', 7, 'mica', 7.22, NULL);
INSERT INTO CATEL VALUES
(10062, 1006, 'Chihuahua', 'Lilly', 3, 'mica', 5.36, 'F');

INSERT INTO LOCATIE VALUES
('acvatic', 'Constanta', 'Bulevardul Mamaia');
INSERT INTO LOCATIE VALUES
('aspect', 'Brasov', 'Cetatii');
INSERT INTO LOCATIE VALUES
('viteza', 'Bucuresti', 'Bulevardul Marasti');
INSERT INTO LOCATIE VALUES
('artistic', 'Galati', 'Tecuci');
INSERT INTO LOCATIE VALUES
('traseu', 'Bucuresti', 'Iuliu Maniu');

INSERT INTO ECHIPAMENT VALUES
(101, 'Rampa 1m', 'Plastic PLA', 7);
INSERT INTO ECHIPAMENT VALUES
(102, 'Tunel 10m', 'Plasa', 1);
INSERT INTO ECHIPAMENT VALUES
(103, 'Trepte', 'Plastic ABS', 5);
INSERT INTO ECHIPAMENT VALUES
(104, 'Rampa 2m', 'Plastic HIPS', 15);
INSERT INTO ECHIPAMENT VALUES
(105, 'Gard 0.5m', 'Titan', 1);

INSERT INTO COMPETITIE VALUES
(1, 'Cel mai bun catel', 7, 500000);
INSERT INTO COMPETITIE VALUES
(2, 'Catelul romaniei', 3, 400000);
INSERT INTO COMPETITIE VALUES
(3, 'Miss and Mr dog', 1, 200000);
INSERT INTO COMPETITIE VALUES
(4, 'Cel mai frumos catel', 7, 600000);
INSERT INTO COMPETITIE VALUES
(5, 'Winner circle', 10, 800000);

INSERT INTO RELATIE_ECH_COMP VALUES
(1, 101, 2);
INSERT INTO RELATIE_ECH_COMP VALUES
(2, 101, 4);
INSERT INTO RELATIE_ECH_COMP VALUES
(3, 102, 1);
INSERT INTO RELATIE_ECH_COMP VALUES
(4, 102, 3);
INSERT INTO RELATIE_ECH_COMP VALUES
(5, 102, 5);
INSERT INTO RELATIE_ECH_COMP VALUES
(6, 103, 3);
INSERT INTO RELATIE_ECH_COMP VALUES
(7, 103, 5);
INSERT INTO RELATIE_ECH_COMP VALUES
(8, 104, 1);
INSERT INTO RELATIE_ECH_COMP VALUES
(9, 104, 2);
INSERT INTO RELATIE_ECH_COMP VALUES
(10, 105, 5);
INSERT INTO RELATIE_ECH_COMP VALUES
(11, 105, 4);
INSERT INTO RELATIE_ECH_COMP VALUES
(12, 105, 1);

INSERT INTO RUNDA VALUES
(500, 1, 'Semifinala CMBC', TO_DATE('03-MAY-2020', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(501, 1, 'Finala CMBC', TO_DATE('10-MAY-2020', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(502, 2, 'Preselectii CR', TO_DATE('20-FEB-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(503, 2, 'Finala CR', TO_DATE('22-FEB-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(504, 3, 'Finala MMD', TO_DATE('15-NOV-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(505, 4, 'Preselectii CMFC', TO_DATE('10-MAY-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(506, 4, 'Finala CMFC', TO_DATE('16-MAY-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(507, 5, 'Preselectii WC', TO_DATE('12-OCT-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(508, 5, 'Semifinala WC', TO_DATE('19-OCT-2021', 'dd-MON-yyyy'));
INSERT INTO RUNDA VALUES
(509, 5, 'Finala WC', TO_DATE('21-OCT-2021', 'dd-MON-yyyy'));

INSERT INTO PROBA VALUES
(1, 500, 'acvatic', 2);
INSERT INTO PROBA VALUES
(1, 501, 'traseu', 4);
INSERT INTO PROBA VALUES
(2, 501, 'viteza', 2);
INSERT INTO PROBA VALUES
(1, 502, 'viteza', 1);
INSERT INTO PROBA VALUES
(1, 503, 'traseu', 3);
INSERT INTO PROBA VALUES
(1, 504, 'aspect', 4);
INSERT INTO PROBA VALUES
(2, 504, 'artistic', 4);
INSERT INTO PROBA VALUES
(1, 505, 'aspect', 2);
INSERT INTO PROBA VALUES
(2, 505, 'artistic', 2);
INSERT INTO PROBA VALUES
(1, 506, 'aspect', 3);
INSERT INTO PROBA VALUES
(1, 507, 'acvatic', 5);
INSERT INTO PROBA VALUES
(1, 508, 'viteza', 4);
INSERT INTO PROBA VALUES
(2, 508, 'traseu', 3);
INSERT INTO PROBA VALUES
(1, 509, 'acvatic', 3);
INSERT INTO PROBA VALUES
(2, 500, 'acvatic', 3);
INSERT INTO PROBA VALUES
(3, 501, 'traseu', 2);
INSERT INTO PROBA VALUES
(3, 504, 'artistic', 1);
INSERT INTO PROBA VALUES
(3, 508, 'viteza', 2);
INSERT INTO PROBA VALUES
(2, 509, 'acvatic', 1);

INSERT INTO JURAT VALUES
(101, 1, 'Marius', 'Spingler', 20);
INSERT INTO JURAT VALUES
(102, 1, 'Marius', 'Anton', NULL);
INSERT INTO JURAT VALUES
(103, 2, 'Alin-Andrei', 'Coman', 25);
INSERT INTO JURAT VALUES
(104, 2, 'Andreea', 'Zipea', 15);
INSERT INTO JURAT VALUES
(105, 3, 'Denisa', 'Popa', 36);
INSERT INTO JURAT VALUES
(106, 4, 'Matei', 'Sarescu', 35);
INSERT INTO JURAT VALUES
(107, 5, 'Andrei', 'Albescu', NULL);
INSERT INTO JURAT VALUES
(108, 5, 'Cristian', 'Anderson', 33);
INSERT INTO JURAT VALUES
(109, 5, 'Mara', 'Tatanescu', 50);

INSERT INTO SPONSOR VALUES
(601, 'Sloop', 'Bucuresti', 'Alex-Mihai', 'Ravi');
INSERT INTO SPONSOR VALUES
(602, 'Royal Canin', 'Bucuresti', 'Rich', 'Beverley');
INSERT INTO SPONSOR VALUES
(603, 'Royal Canin', 'Cluj', 'Hanna', 'Anis');
INSERT INTO SPONSOR VALUES
(604, 'Help-Vet', 'Constanta', 'Philip', 'Bella-Rose');
INSERT INTO SPONSOR VALUES
(605, 'Bosch', 'Brasov', 'Anamaria', 'Petrescu');

INSERT INTO PUBLICITATE VALUES
(10, 'Poster A2', 50);
INSERT INTO PUBLICITATE VALUES
(11, 'Rollup', 3);
INSERT INTO PUBLICITATE VALUES
(12, 'Baner', default);
INSERT INTO PUBLICITATE VALUES
(13, 'Flyere', 200);
INSERT INTO PUBLICITATE VALUES
(14, 'Tricouri', 150);

INSERT INTO RELATIE_PART_COMP VALUES
(1, 1001, 1);
INSERT INTO RELATIE_PART_COMP VALUES
(2, 1002, 1);
INSERT INTO RELATIE_PART_COMP VALUES
(3, 1005, 1);
INSERT INTO RELATIE_PART_COMP VALUES
(4, 1001, 2);
INSERT INTO RELATIE_PART_COMP VALUES
(5, 1002, 2);
INSERT INTO RELATIE_PART_COMP VALUES
(6, 1004, 2);
INSERT INTO RELATIE_PART_COMP VALUES
(7, 1006, 2);
INSERT INTO RELATIE_PART_COMP VALUES
(8, 1001, 3);
INSERT INTO RELATIE_PART_COMP VALUES
(9, 1003, 3);
INSERT INTO RELATIE_PART_COMP VALUES
(10, 1006,3);
INSERT INTO RELATIE_PART_COMP VALUES
(11, 1001 ,4);
INSERT INTO RELATIE_PART_COMP VALUES
(12, 1005 ,4);
INSERT INTO RELATIE_PART_COMP VALUES
(13, 1006, 4);
INSERT INTO RELATIE_PART_COMP VALUES
(14, 1002,5);
INSERT INTO RELATIE_PART_COMP VALUES
(15, 1004,5);
INSERT INTO RELATIE_PART_COMP VALUES
(16, 1005 ,5);

INSERT INTO PROMOVEAZA_SPONSOR VALUES
(1, 10, 1, 601);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(2, 10, 1, 602);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(3, 10, 1, 603);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(4, 10, 2, 601);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(5, 11, 4, 603);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(6, 11, 4,  605);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(7, 11, 5, 603);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(8, 11, 5, 604);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(9, 11, 1, 603);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(10, 12, 4, 602);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(11, 12, 4, 604);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(12, 12, 5, 602);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(13, 13, 3, 601);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(14, 13, 5, 601);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(15, 14, 1, 602);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(16, 14, 4, 602);
INSERT INTO PROMOVEAZA_SPONSOR VALUES
(17, 14, 4, 604);
