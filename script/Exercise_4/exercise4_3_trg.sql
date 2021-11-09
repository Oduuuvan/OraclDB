DECLARE
    v_str_ddl        CLOB;
    v_owner          VARCHAR2(50) := 'SCHOOL';
    v_trg_name       VARCHAR2(50) := 'T_A_KNET_USERS';
    v_check_tbl_name VARCHAR2(50);
    v_trg_tbl        VARCHAR2(50);
    v_trg_seq        VARCHAR2(50);
    v_trg_col        VARCHAR2(50);
    v_cut_type       VARCHAR2(50);
BEGIN

-- Проверка на существование подходящей таблицы
    v_trg_tbl := substr(v_trg_name, 5);
    BEGIN
        SELECT
            table_name
        INTO v_check_tbl_name
        FROM
            all_tables
        WHERE
                owner = v_owner
            AND table_name = v_trg_tbl;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20001, 'Не найдено подходящей для триггера таблицы');
    END;

-- Проверка на существование подходящего сиквенса
    BEGIN
        SELECT
            sequence_name
        INTO v_trg_seq
        FROM
            all_sequences
        WHERE
            sequence_name = 'SEQ_' || v_check_tbl_name;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20002, 'Не найдено подходходящего сиквенса');
    END;

-- Проверка на существование подходящей колонки (первичного ключа)
    BEGIN
        SELECT
            cc.column_name
        INTO v_trg_col
        FROM
                 all_cons_columns cc
            JOIN all_constraints c ON c.constraint_name = cc.constraint_name
        WHERE
                c.owner = v_owner
            AND c.table_name = v_check_tbl_name
            AND c.constraint_type = 'P'
        ORDER BY
            cc.position;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20003, 'Не найдено подходящей для триггера колонки (Первичного ключа)');
    END;

    v_str_ddl := 'CREATE OR REPLACE TRIGGER '
                 || v_trg_name
                 || chr(10);
                 -- Присоединениея нужного типа
    v_cut_type := substr(v_trg_name, 3, 1);
    CASE v_cut_type
        WHEN 'B' THEN
            v_str_ddl := v_str_ddl || 'BEFORE INSERT ON ';
        WHEN 'A' THEN
            v_str_ddl := v_str_ddl || 'AFTER INSERT ON ';
    END CASE;

    v_str_ddl := v_str_ddl
                 || v_check_tbl_name
                 || chr(10)
                 || 'FOR EACH ROW'
                 || chr(10)
                 || 'BEGIN'
                 || chr(10)
                 || 'SELECT '
                 || v_trg_seq
                 || '.nextval'
                 || chr(10)
                 || 'INTO :new.'
                 || v_trg_col
                 || chr(10)
                 || 'FROM dual;'
                 || chr(10)
                 || 'END;';

    dbms_output.put_line(v_str_ddl);
END;
/*
Результат выполнения скрипта:

CREATE OR REPLACE TRIGGER T_A_KNET_USERS
AFTER INSERT ON KNET_USERS
FOR EACH ROW
BEGIN
SELECT SEQ_KNET_USERS.nextval
INTO :new.USERS_ID
FROM dual;
END;
*/