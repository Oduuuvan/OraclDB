DECLARE
    v_str_ddl        CLOB;
    v_owner          VARCHAR2(50) := 'SCHOOL';
    v_pkg_name       VARCHAR2(50) := 'PKG_KSCH_CABINET';
    -----------------------------
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
    ------------------------
    v_pkg_tbl        VARCHAR2(50);
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
    v_pkg_tbl := substr(v_pkg_name, 5);
    BEGIN
        SELECT
            table_name
        INTO v_check_tbl_name
        FROM
            all_tables
        WHERE
                owner = v_owner
            AND table_name = v_pkg_tbl;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20001, '�� ������� ���������� ��� ������ �������');
    END;

-- ���������� ������� � ������� ������� � �� ����� ������
    i := 1;
    FOR c IN (
        SELECT
            column_name,
            data_type
        FROM
            all_tab_cols
        WHERE
                table_name = v_check_tbl_name
            AND owner = v_owner
    ) LOOP
        va_col_name(i) := c.column_name;
        va_col_type(i) := c.data_type;
        i := i + 1;
    END LOOP;
-- ����� ��� ������� create
    v_create_head := 'FUNCTION f_create_row (';
    BEGIN
        SELECT
            cc.column_name
        INTO v_pk_col
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
            raise_application_error(-20003, '�� ������� ���������� ��� �������� ������� (���������� �����)');
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
    
-- ����� ��� ������� read
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

-- ����� ��� ������� update
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

-- ����� ��� ������� delete
    v_delete_head := 'PROCEDURE p_delete_row ( '
                     || chr(10)
                     || 'p_id IN NUMBER,'
                     || chr(10)
                     || 'p_error_code OUT NUMBER,'
                     || chr(10)
                     || 'p_error_msg  OUT VARCHAR2'
                     || chr(10)
                     || ')';

-- DDL ������������
    v_ddl_spec := 'CREATE OR REPLACE PACKAGE '
                  || v_pkg_name
                  || ' IS'
                  || chr(10)
                  || v_create_head
                  || ';'
                  || chr(10)
                  || v_read_head
                  || ';'
                  || chr(10)
                  || v_update_head
                  || ';'
                  || chr(10)
                  || v_delete_head
                  || ';'
                  || chr(10)
                  || 'END '
                  || v_pkg_name
                  || ';'
                  || chr(10)
                  || '/'
                  || chr(10);
    
-- ���� ��� ������� create    
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
    
-- ���� ��� ������� read 
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

-- ���� ��� ������� update
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

-- ���� ��� ������� delete
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

-- DDL ����
    v_ddl_body := 'CREATE OR REPLACE PACKAGE BODY '
                  || v_pkg_name
                  || ' IS'
                  || chr(10)
                  || v_ddl_create
                  || v_ddl_read
                  || v_ddl_update
                  || v_ddl_delete
                  || 'END '
                  || v_pkg_name
                  || ';';
-- DDL ������
    v_str_ddl := v_ddl_spec || v_ddl_body;
    dbms_output.put_line(v_str_ddl);
END;
/*
��������� ���������� �������:    

CREATE OR REPLACE PACKAGE PKG_KSCH_CABINET IS
FUNCTION f_create_row (
P_CABINET_NUMBER IN NUMBER,
P_CAMPUS IN VARCHAR2,
P_SCHOOL_ID IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
) RETURN NUMBER;
PROCEDURE p_read_row (
p_id IN NUMBER,
p_out_row OUT KSCH_CABINET%rowtype,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
);
PROCEDURE p_update_row (
P_CABINET_ID IN NUMBER,
P_CABINET_NUMBER IN NUMBER,
P_CAMPUS IN VARCHAR2,
P_SCHOOL_ID IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
);
PROCEDURE p_delete_row ( 
p_id IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg  OUT VARCHAR2
);
END PKG_KSCH_CABINET;
/
CREATE OR REPLACE PACKAGE BODY PKG_KSCH_CABINET IS
FUNCTION f_create_row (
P_CABINET_NUMBER IN NUMBER,
P_CAMPUS IN VARCHAR2,
P_SCHOOL_ID IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
) RETURN NUMBER IS
v_id KSCH_CABINET.CABINET_ID%type;
BEGIN
p_error_code := 0;
INSERT INTO KSCH_CABINET (CABINET_NUMBER,CAMPUS,SCHOOL_ID)
VALUES (P_CABINET_NUMBER,P_CAMPUS,P_SCHOOL_ID)
RETURNING CABINET_ID INTO v_id;
RETURN v_id;
EXCEPTION
WHEN OTHERS THEN
p_error_code := sqlcode;
p_error_msg := sqlerrm;
RETURN NULL;
END f_create_row;
PROCEDURE p_read_row (
p_id IN NUMBER,
p_out_row OUT KSCH_CABINET%rowtype,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
) IS
BEGIN
p_error_code := 0;
SELECT * INTO p_out_row FROM KSCH_CABINET WHERE CABINET_ID = p_id;
EXCEPTION
WHEN OTHERS THEN
p_error_code := sqlcode;
p_error_msg := sqlerrm;
END p_read_row;
PROCEDURE p_update_row (
P_CABINET_ID IN NUMBER,
P_CABINET_NUMBER IN NUMBER,
P_CAMPUS IN VARCHAR2,
P_SCHOOL_ID IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg OUT VARCHAR2
) IS
BEGIN
p_error_code := 0;
UPDATE KSCH_CABINET SET 
CABINET_ID = P_CABINET_ID,
CABINET_NUMBER = P_CABINET_NUMBER,
CAMPUS = P_CAMPUS,
SCHOOL_ID = P_SCHOOL_ID
WHERE CABINET_ID = P_CABINET_ID;
EXCEPTION
WHEN OTHERS THEN
p_error_code := sqlcode;
p_error_msg := sqlerrm;
END p_update_row;
PROCEDURE p_delete_row ( 
p_id IN NUMBER,
p_error_code OUT NUMBER,
p_error_msg  OUT VARCHAR2
) IS
BEGIN
p_error_code := 0;
DELETE FROM KSCH_CABINET WHERE CABINET_ID = p_id;
EXCEPTION
WHEN OTHERS THEN
p_error_code := sqlcode;
p_error_msg := sqlerrm;
END p_delete_row;
END PKG_KSCH_CABINET;
   
*/