DECLARE
    v_str_ddl  CLOB;
    v_ind_name VARCHAR2(50) := 'I_USERS';
    v_ind_tbl  VARCHAR2(50);
BEGIN
    SELECT
        table_name
    INTO v_ind_tbl
    FROM
        user_ind_columns
    WHERE
        index_name = v_ind_name
    GROUP BY
        table_name;

    v_str_ddl := 'CREATE INDEX '
                 || v_ind_name
                 || ' ON '
                 || v_ind_tbl
                 || '(';
    FOR rec IN (
        SELECT
            column_name,
            descend
        FROM
            user_ind_columns
        WHERE
                table_name = v_ind_tbl
            AND index_name = v_ind_name
    ) LOOP
        v_str_ddl := v_str_ddl
                     || rec.column_name
                     || ' '
                     || rec.descend
                     || ', ';
    END LOOP;
    v_str_ddl := substr(v_str_ddl, 1, length(v_str_ddl) - 2)||');';
    dbms_output.put_line(v_str_ddl);
END;
/*
Результат выполнения скрипта:

CREATE INDEX I_USERS ON KNET_USERS(IS_ACTIVE ASC, IS_SUPERUSER ASC);
*/