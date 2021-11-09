CREATE OR REPLACE FUNCTION f_get_ddl (
    p_owner IN VARCHAR2,
    p_name  IN VARCHAR2,
    p_type  IN VARCHAR2 := NULL
) RETURN CLOB IS

    ex_param_null EXCEPTION;
    ex_undef_type EXCEPTION;
    v_obj_type VARCHAR2(50);
--------------------------------------------------------
    FUNCTION f_get_ddl_tbl RETURN CLOB IS
        v_ddl CLOB;
    BEGIN
        v_ddl := 'CREATE TABLE '
                 || upper(p_name)
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
                all_tab_columns
            WHERE
                    table_name = upper(p_name)
                AND owner = upper(p_owner)
        ) LOOP
            IF instr(rec.data_type, 'CHAR') != 0 THEN
                v_ddl := v_ddl
                         || rec.column_name
                         || ' '
                         || rec.data_type
                         || '('
                         || rec.data_length
                         || ') ';
            ELSE
                v_ddl := v_ddl
                         || rec.column_name
                         || ' '
                         || rec.data_type
                         || ' ';
            END IF;

            IF rec.nullable = 'Y' THEN
                v_ddl := v_ddl
                         || 'NULL,'
                         || chr(10);
            ELSE
                v_ddl := v_ddl
                         || 'NOT NULL,'
                         || chr(10);
            END IF;

        END LOOP;

        v_ddl := substr(v_ddl, 1, length(v_ddl) - 2)
                 || chr(10)
                 || ');';

        RETURN v_ddl;
    END f_get_ddl_tbl;
--------------------------------------------------------
    FUNCTION f_get_ddl_ind RETURN CLOB IS

        v_ddl       CLOB;
        v_name_wo_i VARCHAR2(50);
        v_cut_tbl   VARCHAR2(50);
        v_cut_col   VARCHAR2(50);
        v_ind_tbl   VARCHAR2(50);
        v_ind_col   VARCHAR2(50);
        ex_no_tbl EXCEPTION;
    BEGIN
        v_name_wo_i := substr(p_name, 3);
        FOR i IN (
            SELECT
                regexp_substr(v_name_wo_i, '[^_]+', 1, level) AS data
            FROM
                dual
            CONNECT BY
                regexp_substr(v_name_wo_i, '[^_]+', 1, level) IS NOT NULL
        ) LOOP
            BEGIN
                v_cut_tbl := v_cut_tbl || i.data;
                SELECT
                    table_name
                INTO v_ind_tbl
                FROM
                    all_tables
                WHERE
                        table_name = v_cut_tbl
                    AND owner = p_owner;

            EXCEPTION
                WHEN no_data_found THEN
                    v_cut_tbl := v_cut_tbl || '_';
            END;
        END LOOP;

        IF v_ind_tbl IS NULL THEN
            RAISE ex_no_tbl;
        END IF;
        v_cut_col := substr(v_name_wo_i, length(v_ind_tbl) + 2);
        SELECT
            column_name
        INTO v_ind_col
        FROM
            all_tab_columns
        WHERE
                table_name = v_ind_tbl
            AND column_name = v_cut_col
            AND owner = p_owner;

        v_ddl := 'CREATE INDEX '
                 || p_name
                 || ' ON '
                 || v_ind_tbl
                 || '('
                 || v_ind_col
                 || ');';

        RETURN v_ddl;
    EXCEPTION
        WHEN ex_no_tbl THEN
            raise_application_error(-20005, 'Не найдено таблицы с введеным именем');
        WHEN no_data_found THEN
            raise_application_error(-20006, 'Не найдено колонки с введеным именем, она может быть в другой таблице');
    END f_get_ddl_ind;
--------------------------------------------------------
    FUNCTION f_get_ddl_seq RETURN CLOB IS
        v_ddl            CLOB;
        v_check_seq_name VARCHAR2(50);
        ex_name_exist EXCEPTION;
    BEGIN
        SELECT
            sequence_name
        INTO v_check_seq_name
        FROM
            all_sequences
        WHERE
                sequence_owner = p_owner
            AND sequence_name = p_name;

        RAISE ex_name_exist;
    EXCEPTION
        WHEN no_data_found THEN
            v_ddl := v_ddl
                     || 'CREATE SEQUENCE '
                     || p_name
                     || chr(10)
                     || 'MINVALUE 1'
                     || chr(10)
                     || 'START WITH 1'
                     || chr(10)
                     || 'INCREMENT BY 1'
                     || chr(10)
                     || 'NOCACHE;';

            RETURN v_ddl;
        WHEN ex_name_exist THEN
            raise_application_error(-20007, 'Введенное имя '
                                            || v_check_seq_name
                                            || ' уже занято');
    END f_get_ddl_seq;
--------------------------------------------------------
    FUNCTION f_get_ddl_trg RETURN CLOB IS

        v_ddl            CLOB;
        v_check_tbl_name VARCHAR2(50);
        v_trg_tbl        VARCHAR2(50);
        v_trg_seq        VARCHAR2(50);
        v_trg_col        VARCHAR2(50);
        v_cut_type       VARCHAR2(50);
    BEGIN
        v_trg_tbl := substr(p_name, 5);
        BEGIN
            SELECT
                table_name
            INTO v_check_tbl_name
            FROM
                all_tables
            WHERE
                    owner = p_owner
                AND table_name = v_trg_tbl;

        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error(-20008, 'Не найдено подходящей для триггера таблицы');
        END;

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
                raise_application_error(-20009, 'Не найдено подходходящего сиквенса');
        END;

        BEGIN
            SELECT
                cc.column_name
            INTO v_trg_col
            FROM
                     all_cons_columns cc
                JOIN all_constraints c ON c.constraint_name = cc.constraint_name
            WHERE
                    c.owner = p_owner
                AND c.table_name = v_check_tbl_name
                AND c.constraint_type = 'P'
            ORDER BY
                cc.position;

        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error(-20010, 'Не найдено подходящей для триггера колонки (Первичного ключа)');
        END;

        v_ddl := 'CREATE OR REPLACE TRIGGER '
                 || p_name
                 || chr(10);
        v_cut_type := substr(p_name, 3, 1);
        CASE v_cut_type
            WHEN 'B' THEN
                v_ddl := v_ddl || 'BEFORE INSERT ON ';
            WHEN 'A' THEN
                v_ddl := v_ddl || 'AFTER INSERT ON ';
        END CASE;

        v_ddl := v_ddl
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

        RETURN v_ddl;
    END f_get_ddl_trg;
--------------------------------------------------------
    FUNCTION f_get_ddl_pkg RETURN CLOB IS

        v_ddl            CLOB;
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
        v_pkg_tbl := substr(p_name, 5);
        BEGIN
            SELECT
                table_name
            INTO v_check_tbl_name
            FROM
                all_tables
            WHERE
                    owner = p_owner
                AND table_name = v_pkg_tbl;

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
                all_tab_cols
            WHERE
                    table_name = v_check_tbl_name
                AND owner = p_owner
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
                     all_cons_columns cc
                JOIN all_constraints c ON c.constraint_name = cc.constraint_name
            WHERE
                    c.owner = p_owner
                AND c.table_name = v_check_tbl_name
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

        v_ddl_spec := 'CREATE OR REPLACE PACKAGE '
                      || p_name
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
                      || p_name
                      || ';'
                      || chr(10)
                      || '/'
                      || chr(10);

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

        v_ddl_body := 'CREATE OR REPLACE PACKAGE BODY '
                      || p_name
                      || ' IS'
                      || chr(10)
                      || v_ddl_create
                      || v_ddl_read
                      || v_ddl_update
                      || v_ddl_delete
                      || 'END '
                      || p_name
                      || ';';

        v_ddl := v_ddl_spec || v_ddl_body;
        RETURN v_ddl;
    END f_get_ddl_pkg;

BEGIN
-- Проверка наличия пользователя
    IF p_owner IS NULL OR p_name IS NULL THEN
        RAISE ex_param_null;
    END IF;
    CASE p_type
-- Генерация DDL таблицы    
        WHEN 'TABLE' THEN
            RETURN f_get_ddl_tbl;
-- Генерация DDL индекса
        WHEN 'INDEX' THEN
            RETURN f_get_ddl_ind;
-- Генерация DDL секвинса
        WHEN 'SEQUENCE' THEN
            RETURN f_get_ddl_seq;
-- Генерация DDL триггера
        WHEN 'TRIGGER' THEN
            RETURN f_get_ddl_trg;
-- Генерация DDL пакета            
        WHEN 'PACKAGE' THEN
            RETURN f_get_ddl_pkg;
        ELSE
            RAISE ex_undef_type;
    END CASE;

EXCEPTION
    WHEN ex_param_null THEN
        raise_application_error(-20001, 'Обязательные параметры (p_owner, p_name) не должны быть NULL');
    WHEN no_data_found THEN
        raise_application_error(-20002, 'Объект '
                                        || p_type
                                        || ' '
                                        || p_owner
                                        || '.'
                                        || p_name
                                        || ' не найден');
    WHEN too_many_rows THEN
        raise_application_error(-20003, 'Найдено несколько объектов '
                                        || p_owner
                                        || '.'
                                        || p_name
                                        || ', необходимо добавить параметр p_type');
    WHEN ex_undef_type THEN
        raise_application_error(-20004, 'Нет реализации для типа ' || v_obj_type);
    WHEN OTHERS THEN
        RAISE;
END f_get_ddl;