CREATE OR REPLACE FUNCTION f_get_ddl (
    p_owner IN VARCHAR2,
    p_name  IN VARCHAR2,
    p_type  IN VARCHAR2 := NULL
) RETURN CLOB IS

    ex_param_null EXCEPTION;
    ex_undef_type EXCEPTION;
    v_obj_type VARCHAR2(50);

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

    FUNCTION f_get_ddl_ind RETURN CLOB IS
        v_ind_tbl VARCHAR2(50);
        v_ddl     CLOB;
    BEGIN
        SELECT
            table_name
        INTO v_ind_tbl
        FROM
            all_ind_columns
        WHERE
                index_name = upper(p_name)
            AND index_owner = upper(p_owner)
        GROUP BY
            table_name;

        v_ddl := 'CREATE INDEX '
                 || upper(p_name)
                 || ' ON '
                 || v_ind_tbl
                 || '(';

        FOR rec IN (
            SELECT
                column_name,
                descend
            FROM
                all_ind_columns
            WHERE
                    table_name = v_ind_tbl
                AND index_name = upper(p_name)
                AND index_owner = upper(p_owner)
        ) LOOP
            v_ddl := v_ddl
                     || rec.column_name
                     || ' '
                     || rec.descend
                     || ', ';
        END LOOP;

        v_ddl := substr(v_ddl, 1, length(v_ddl) - 2)
                 || ');';

        RETURN v_ddl;
    END f_get_ddl_ind;

    FUNCTION f_get_ddl_seq RETURN CLOB IS

        TYPE t_seq_rec IS RECORD (
            min_value    NUMBER,
            max_value    NUMBER,
            increment_by NUMBER,
            cache_size   NUMBER
        );
        v_seq_rec t_seq_rec;
        v_ddl     CLOB;
    BEGIN
        SELECT
            min_value,
            max_value,
            increment_by,
            cache_size
        INTO v_seq_rec
        FROM
            all_sequences
        WHERE
                sequence_name = upper(p_name)
            AND sequence_owner = upper(p_owner);

        v_ddl := 'CREATE SEQUENCE '
                 || upper(p_name)
                 || chr(10)
                 || 'MINVALUE '
                 || v_seq_rec.min_value
                 || chr(10)
                 || 'MAXVALUE '
                 || v_seq_rec.max_value
                 || chr(10)
                 || 'START WITH '
                 || v_seq_rec.min_value
                 || chr(10)
                 || 'INCREMENT BY '
                 || v_seq_rec.increment_by
                 || chr(10);

        IF v_seq_rec.cache_size = 1 THEN
            v_ddl := v_ddl
                     || 'CACHE '
                     || v_seq_rec.cache_size
                     || ';';
        ELSE
            v_ddl := substr(v_ddl, 1, length(v_ddl) - 1)
                     || ';';
        END IF;

        RETURN v_ddl;
    END f_get_ddl_seq;

    FUNCTION f_get_ddl_trg_or_pkg RETURN CLOB IS
        v_ddl CLOB;
    BEGIN
        v_ddl := 'CREATE OR REPLACE ';
        FOR rec IN (
            SELECT
                text
            FROM
                all_source
            WHERE
                    name = upper(p_name)
                AND type = v_obj_type
                AND owner = upper(p_owner)
            ORDER BY
                line
        ) LOOP
            v_ddl := v_ddl || rec.text;
        END LOOP;

        RETURN v_ddl;
    END f_get_ddl_trg_or_pkg;

BEGIN
-- Проверка наличия пользователя
    IF p_owner IS NULL OR p_name IS NULL THEN
        RAISE ex_param_null;
    END IF;
-- Проверка на наличие объекта в базе
    SELECT
        object_type
    INTO v_obj_type
    FROM
        all_objects
    WHERE
            owner = upper(p_owner)
        AND object_name = upper(p_name)
        AND object_type = upper(nvl(p_type, object_type));

    CASE v_obj_type
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
            RETURN f_get_ddl_trg_or_pkg;
-- Генерация DDL пакета            
        WHEN 'PACKAGE' THEN
            RETURN f_get_ddl_trg_or_pkg;
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