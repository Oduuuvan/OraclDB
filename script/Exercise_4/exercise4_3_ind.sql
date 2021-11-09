DECLARE
    v_str_ddl   CLOB;
    v_ind_name  VARCHAR2(50) := 'I_KNET_USERS_IS_ACTIVE';
    v_owner     VARCHAR2(50) := 'SCHOOL';
    v_name_wo_i VARCHAR2(50);
    v_cut_tbl   VARCHAR2(50);
    v_cut_col   VARCHAR2(50);
    v_ind_tbl   VARCHAR2(50);
    v_ind_col   VARCHAR2(50);
    ex_no_tbl EXCEPTION;
BEGIN
    v_name_wo_i := substr(v_ind_name, 3);
    
--Поиск таблицы по названию индекса
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
                AND owner = v_owner;

        EXCEPTION
            WHEN no_data_found THEN
                v_cut_tbl := v_cut_tbl || '_';
        END;
    END LOOP;

    IF v_ind_tbl IS NULL THEN
        RAISE ex_no_tbl;
    END IF;
--Поиск колонки по названию индекса
    v_cut_col := substr(v_name_wo_i, length(v_ind_tbl) + 2);
    SELECT
        column_name
    INTO v_ind_col
    FROM
        all_tab_columns
    WHERE
            table_name = v_ind_tbl
        AND column_name = v_cut_col
        AND owner = v_owner;

    v_str_ddl := 'CREATE INDEX '
                 || v_ind_name
                 || ' ON '
                 || v_ind_tbl
                 || '('
                 || v_ind_col
                 || ');';

    dbms_output.put_line(v_str_ddl);
EXCEPTION
    WHEN ex_no_tbl THEN
        raise_application_error(-20001, 'Не найдено таблицы с введеным именем');
    WHEN no_data_found THEN
        raise_application_error(-20002, 'Не найдено колонки с введеным именем, она может быть в другой таблице');
END;
/*
Результат выполнения скрипта:

CREATE INDEX I_KNET_USERS_IS_ACTIVE ON KNET_USERS(IS_ACTIVE);
*/