CONNECT &username/&password@&db
SET serveroutput ON
SPOOL out.txt
CREATE OR REPLACE FUNCTION f_get_crud_ddl (
    p_tbl_name VARCHAR2
) RETURN CLOB IS
    v_str_ddl        CLOB;
    v_create_head    CLOB;
    v_read_head      CLOB;
    v_update_head    CLOB;
    v_delete_head    CLOB;
    v_ddl_create     CLOB;
    v_ddl_read       CLOB;
    v_ddl_update     CLOB;
    v_ddl_delete     CLOB;
    v_ddl_spec       CLOB;
    v_ddl_body       CLOB;
    v_check_tbl_name VARCHAR2(50);
    TYPE t_arr_col_name IS
        TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE t_arr_col_type IS
        TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    va_col_name      t_arr_col_name;
    va_col_type      t_arr_col_type;
    i                BINARY_INTEGER;
    v_pk_col         VARCHAR2(50);
    v_ex_str         CLOB := 'EXCEPTION'
                     || chr(10)
                     || 'WHEN OTHERS THEN'
                     || chr(10)
                     || 'p_error_code := sqlcode;'
                     || chr(10)
                     || 'p_error_msg := sqlerrm;';
BEGIN
    BEGIN
        SELECT
            table_name
        INTO v_check_tbl_name
        FROM
            user_tables
        WHERE
            table_name = p_tbl_name;
    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20001, 'Не найдено подходящей для пакета таблицы');
    END;
    i := 1;
    FOR c IN (
        SELECT
            column_name,
            data_type
        FROM
            user_tab_cols
        WHERE
                table_name = v_check_tbl_name
    ) LOOP
        va_col_name(i) := c.column_name;
        va_col_type(i) := c.data_type;
        i := i + 1;
    END LOOP;
    v_create_head := 'FUNCTION f_create_row (';
    BEGIN
        SELECT
            cc.column_name
        INTO v_pk_col
        FROM
                 user_cons_columns cc
            JOIN user_constraints c ON c.constraint_name = cc.constraint_name
        WHERE
            c.table_name = v_check_tbl_name
            AND c.constraint_type = 'P'
        ORDER BY
            cc.position;
    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20003, 'Не найдено подходящей для триггера колонки (Первичного ключа)');
    END;
    FOR c IN va_col_name.first..va_col_name.last LOOP
        IF va_col_name(c) = v_pk_col THEN
            CONTINUE;
        END IF;
        v_create_head := v_create_head
                         || chr(10)
                         || 'P_'
                         || va_col_name(c)
                         || ' IN '
                         || va_col_type(c)
                         || ',';
    END LOOP;
    v_create_head := v_create_head
                     || chr(10)
                     || 'p_error_code OUT NUMBER,'
                     || chr(10)
                     || 'p_error_msg OUT VARCHAR2'
                     || chr(10)
                     || ') RETURN NUMBER';
    v_read_head := 'PROCEDURE p_read_row ('
                   || chr(10)
                   || 'p_id IN NUMBER,'
                   || chr(10)
                   || 'p_out_row OUT '
                   || v_check_tbl_name
                   || '%rowtype,'
                   || chr(10)
                   || 'p_error_code OUT NUMBER,'
                   || chr(10)
                   || 'p_error_msg OUT VARCHAR2'
                   || chr(10)
                   || ')';
    v_update_head := 'PROCEDURE p_update_row (';
    FOR c IN va_col_name.first..va_col_name.last LOOP
        v_update_head := v_update_head
                         || chr(10)
                         || 'P_'
                         || va_col_name(c)
                         || ' IN '
                         || va_col_type(c)
                         || ',';
    END LOOP;
    v_update_head := v_update_head
                     || chr(10)
                     || 'p_error_code OUT NUMBER,'
                     || chr(10)
                     || 'p_error_msg OUT VARCHAR2'
                     || chr(10)
                     || ')';
    v_delete_head := 'PROCEDURE p_delete_row ( '
                     || chr(10)
                     || 'p_id IN NUMBER,'
                     || chr(10)
                     || 'p_error_code OUT NUMBER,'
                     || chr(10)
                     || 'p_error_msg  OUT VARCHAR2'
                     || chr(10)
                     || ')';   
    v_ddl_create := v_create_head
                    || ' IS'
                    || chr(10)
                    || 'v_id '
                    || v_check_tbl_name
                    || '.'
                    || v_pk_col
                    || '%type;'
                    || chr(10)
                    || 'BEGIN'
                    || chr(10)
                    || 'p_error_code := 0;'
                    || chr(10)
                    || 'INSERT INTO '
                    || v_check_tbl_name
                    || ' (';
    FOR c IN va_col_name.first..va_col_name.last LOOP
        IF va_col_name(c) = v_pk_col THEN
            CONTINUE;
        END IF;
        IF c = va_col_name.last THEN
            v_ddl_create := v_ddl_create
                            || va_col_name(c)
                            || ')';
            EXIT;
        END IF;
        v_ddl_create := v_ddl_create
                        || va_col_name(c)
                        || ',';
    END LOOP;
    v_ddl_create := v_ddl_create
                    || chr(10)
                    || 'VALUES (';
    FOR c IN va_col_name.first..va_col_name.last LOOP
        IF va_col_name(c) = v_pk_col THEN
            CONTINUE;
        END IF;
        IF c = va_col_name.last THEN
            v_ddl_create := v_ddl_create
                            || 'P_'
                            || va_col_name(c)
                            || ')';
            EXIT;
        END IF;
        v_ddl_create := v_ddl_create
                        || 'P_'
                        || va_col_name(c)
                        || ',';
    END LOOP;
    v_ddl_create := v_ddl_create
                    || chr(10)
                    || 'RETURNING '
                    || v_pk_col
                    || ' INTO v_id;'
                    || chr(10)
                    || 'RETURN v_id;'
                    || chr(10)
                    || v_ex_str
                    || chr(10)
                    || 'RETURN NULL;'
                    || chr(10)
                    || 'END f_create_row;'
                    || chr(10);
    v_ddl_read := v_read_head
                  || ' IS'
                  || chr(10)
                  || 'BEGIN'
                  || chr(10)
                  || 'p_error_code := 0;'
                  || chr(10)
                  || 'SELECT * INTO p_out_row FROM '
                  || v_check_tbl_name
                  || ' WHERE '
                  || v_pk_col
                  || ' = p_id;'
                  || chr(10)
                  || v_ex_str
                  || chr(10)
                  || 'END p_read_row;'
                  || chr(10);
    v_ddl_update := v_update_head
                    || ' IS'
                    || chr(10)
                    || 'BEGIN'
                    || chr(10)
                    || 'p_error_code := 0;'
                    || chr(10)
                    || 'UPDATE '
                    || v_check_tbl_name
                    || ' SET ';
    FOR c IN va_col_name.first..va_col_name.last LOOP
        IF c = va_col_name.last THEN
            v_ddl_update := v_ddl_update
                            || chr(10)
                            || va_col_name(c)
                            || ' = P_'
                            || va_col_name(c)
                            || chr(10);
            EXIT;
        END IF;
        v_ddl_update := v_ddl_update
                        || chr(10)
                        || va_col_name(c)
                        || ' = P_'
                        || va_col_name(c)
                        || ',';

    END LOOP;
    v_ddl_update := v_ddl_update
                    || 'WHERE '
                    || v_pk_col
                    || ' = P_'
                    || v_pk_col
                    || ';'
                    || chr(10)
                    || v_ex_str
                    || chr(10)
                    || 'END p_update_row;'
                    || chr(10);
    v_ddl_delete := v_delete_head
                    || ' IS'
                    || chr(10)
                    || 'BEGIN'
                    || chr(10)
                    || 'p_error_code := 0;'
                    || chr(10)
                    || 'DELETE FROM '
                    || v_check_tbl_name
                    || ' WHERE '
                    || v_pk_col
                    || ' = p_id;'
                    || chr(10)
                    || v_ex_str
                    || chr(10)
                    || 'END p_delete_row;'
                    || chr(10);
    v_str_ddl := v_ddl_create
                 || chr(10)
                 || v_ddl_read
                 || chr(10)
                 || v_ddl_update
                 || chr(10)
                 || v_ddl_delete;
    RETURN v_str_ddl;
END f_get_crud_ddl;
/
DECLARE
    v_ddl CLOB;
BEGIN
    FOR c IN (
        SELECT
            table_name
        FROM
            user_tables
    ) LOOP
        v_ddl := f_get_crud_ddl(c.table_name);
        dbms_output.put_line(v_ddl);
    END LOOP;
END;
/
SPOOL off