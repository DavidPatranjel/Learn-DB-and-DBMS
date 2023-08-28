/*ex6 - prima parte*/
VARIABLE rezultat1 VARCHAR2(35)
variable rezultat2 NUMBER(5)
BEGIN
    SELECT department_name, COUNT(*)
    INTO :rezultat1, :rezultat2
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    GROUP BY department_name
    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                        FROM   employees
                        GROUP BY department_id);
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat1);                       
    DBMS_OUTPUT.PUT_LINE('Nr angajati '|| :rezultat2);  
END;
/
PRINT rezultat1;
PRINT rezultat2;

/*ex1 - a doua parte
a)Valoarea variabilei numar în subbloc este: 2
b)Valoarea variabilei mesaj1 în subbloc este: text 2
c)Valoarea variabilei mesaj2 în subbloc este: text 3 adaugat in sub-bloc
d)Valoarea variabilei numar în bloc este: 101
e)Valoarea variabilei mesaj1 în bloc este: text 1 adaugat un blocul principal
f)Valoarea variabilei mesaj2 în bloc este: text 2 adaugat in blocul principal
*/

/*ex2a - a doua parte */
select oct.zi, (select count(*) 
                from rental r
                where TO_DATE(r.book_date, 'dd-MON-yyyy') = TO_DATE(oct.zi, 'yyyy-mm-dd')) as nr
from(select TO_DATE('01-OCT-2022', 'dd-MON-yyyy') + level - 1 as zi
    from  DUAL
    connect by level <= (TO_DATE('01-NOV-2022', 'dd-MON-yyyy') - TO_DATE('01-OCT-2022', 'dd-MON-yyyy'))
) oct

/*ex2b - a doua parte */
create table octombrie_dgp(
    id number(3) not null, 
    zi date
);

alter table octombrie_dgp
add constraint pk_oct_dgp primary key (id);

DECLARE
    contor NUMBER(6) := 0;
    v_data  DATE;
    control date :=  TO_DATE('01-OCT-2022', 'dd-MON-yyyy');
    maxim   NUMBER(2) := EXTRACT(day from last_day(SYSDATE));
BEGIN
    LOOP
        v_data := contor + control;
        INSERT INTO octombrie_dgp
        VALUES (contor,v_data);
        contor := contor + 1;
        EXIT WHEN contor >= maxim;
    END LOOP;
END;
/
commit;


with nr_rents as(select o.zi, count(*) as nr
                    from octombrie_dgp o
                    join rental r on to_date(o.zi, 'dd-MON-yyyy') = to_date(r.book_date, 'dd-MON-yyyy')
                    group by o.zi
                    order by o.zi
)

select oo.zi,
        case
            when n.zi is null then 0
            else n.nr
        end as number_rentals
from octombrie_dgp oo
left outer join nr_rents n on oo.zi = n.zi
order by oo.zi

/*ex3 - a doua parte */
DECLARE
    membru_negasit exception;
    v_nume member.last_name%TYPE:= '&nume';
    v_nr number(5) := 0;
    v_aux member.memberid%TYPE;
BEGIN
    select m.memberid
    into v_aux
    from member m
    where lower(m.last_name) = lower(v_nume);
    
    if sql%rowcount > 1 then raise too_many_rows;
    elsif sql%rowcount = 0 then raise membru_negasit;
    end if;
    
    select count(*)
    into v_nr
    from ( 
        select distinct
            r.memberid, r.titleid
        from rental r
        where r.memberid = v_aux);
    
    DBMS_OUTPUT.PUT_LINE('nr filme = '|| v_nr);  
EXCEPTION
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie returnata');
    when membru_negasit then
        DBMS_OUTPUT.PUT_LINE('Membru negasit');
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii returnate');
    when others then
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;

/*ex4 - a doua parte */
DECLARE
    membru_negasit exception;
    v_nume member.last_name%TYPE:= '&nume';
    v_nr number(5) := 0;
    v_total number(5) := 0;
    v_proc number(5) := 0;
    v_cat varchar2(30) := 'Categoria ';
    v_aux member.memberid%TYPE;
BEGIN
    select m.memberid
    into v_aux
    from member m
    where lower(m.last_name) = lower(v_nume);
    
    if sql%rowcount > 1 then raise too_many_rows;
    elsif sql%rowcount = 0 then raise membru_negasit;
    end if;
    
    select count(*)
    into v_nr
    from ( 
        select distinct
            r.memberid, r.titleid
        from rental r
        where r.memberid = v_aux);
    
    select count(*)
    into v_total
    from title;
    
    v_proc := (v_nr/v_total) * 100;
    if v_proc > 75 then v_cat := v_cat || '1';
    elsif v_proc > 50 then v_cat := v_cat || '2';
    elsif v_proc > 25 then v_cat := v_cat || '3';
    else v_cat := v_cat || '4';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_cat);  
EXCEPTION
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie returnata');
    when membru_negasit then
        DBMS_OUTPUT.PUT_LINE('Nicio linie returnata');
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii returnate');
    when others then
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;



/*ex5 - a doua parte */
create table member_dgp as (select * from member);
alter table member_dgp
add discount number;

commit;

DECLARE
    membru_negasit exception;
    v_nume member.last_name%TYPE:= '&nume';
    v_nr number(5) := 0;
    v_total number(5) := 0;
    v_proc number(5) := 0;
    v_cat number(1) := 0;
    v_aux member.memberid%TYPE;
BEGIN
    select m.memberid
    into v_aux
    from member m
    where lower(m.last_name) = lower(v_nume);
    
    if sql%rowcount > 1 then raise too_many_rows;
    elsif sql%rowcount = 0 then raise membru_negasit;
    end if;
    
    select count(*)
    into v_nr
    from ( 
        select distinct
            r.memberid, r.titleid
        from rental r
        where r.memberid = v_aux);
    
    select count(*)
    into v_total
    from title;
    
    v_proc := (v_nr/v_total) * 100;
    if v_proc > 75 then v_cat :=  10;
    elsif v_proc > 50 then v_cat := 5;
    elsif v_proc > 25 then v_cat := 3;
    else v_cat := 0;
    end if;
    
    update member_dgp
    set discount = v_cat
    where lower(last_name) = lower(v_nume);
    commit;
    DBMS_OUTPUT.PUT_LINE(v_cat);  
EXCEPTION
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie returnata');
    when membru_negasit then
        DBMS_OUTPUT.PUT_LINE('Nicio linie returnata');
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii returnate');
    when others then
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;

