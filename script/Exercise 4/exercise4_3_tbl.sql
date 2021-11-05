DECLARE
    v_str_ddl  CLOB;
    v_tbl_name VARCHAR2(50) := 'KNET_USERS';
BEGIN
    v_str_ddl := 'CREATE TABLE '
                 || v_tbl_name
                 || chr(10)
                 || '('
                 || chr(10);

    FOR rec IN (
        SELECT
            column_name,
            data_type,
            data_length,
            nullable
        FROM
            user_tab_columns
        WHERE
            table_name = v_tbl_name
    ) LOOP
        IF rec.data_type = 'VARCHAR2' THEN
            v_str_ddl := v_str_ddl
                         || rec.column_name
                         || ' '
                         || rec.data_type
                         || '('
                         || rec.data_length
                         || ') ';
        ELSE
            v_str_ddl := v_str_ddl
                         || rec.column_name
                         || ' '
                         || rec.data_type
                         || ' ';
        END IF;

        IF rec.nullable = 'Y' THEN
            v_str_ddl := v_str_ddl
                         || 'NULL,'
                         || chr(10);
        ELSE
            v_str_ddl := v_str_ddl
                         || 'NOT NULL,'
                         || chr(10);
        END IF;

    END LOOP;

    v_str_ddl := substr(v_str_ddl, 1, length(v_str_ddl) - 2)
                 || chr(10)
                 || ');';

    dbms_output.put_line(v_str_ddl);
END;

/*
Результат выполнения скрипта:

CREATE TABLE KNET_USERS
(
USERS_ID NUMBER NOT NULL,
IS_SUPERUSER NUMBER NOT NULL,
SURNAME VARCHAR2(50) NOT NULL,
NAME VARCHAR2(50) NOT NULL,
PATRONYMIC VARCHAR2(50) NULL,
MAIL VARCHAR2(45) NULL,
USERNAME VARCHAR2(20) NOT NULL,
PASSWORD VARCHAR2(45) NOT NULL,
IS_ACTIVE NUMBER NOT NULL,
LAST_LOGIN DATE NOT NULL
);
*/