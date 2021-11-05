DECLARE
    v_str_ddl  CLOB;
    v_trg_name VARCHAR2(50) := 'T_B_CABINET';
BEGIN
    v_str_ddl := 'CREATE OR REPLACE ';
    FOR rec IN (
        SELECT
            *
        FROM
            user_source
        WHERE
                name = v_trg_name
            AND type = 'TRIGGER'
        ORDER BY
            line
    ) LOOP
        v_str_ddl := v_str_ddl || rec.text;
    END LOOP;

    dbms_output.put_line(v_str_ddl);
END;
/*
Результат выполнения скрипта:

CREATE OR REPLACE TRIGGER t_b_cabinet
BEFORE INSERT ON ksch_cabinet
FOR EACH ROW

BEGIN
  SELECT SEQ_CABINET.nextval
  INTO   :new.cabinet_id
  FROM   dual;
END;
*/