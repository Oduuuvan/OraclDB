DECLARE
    v_str_ddl  CLOB;
    v_seq_name VARCHAR2(50) := 'SEQ_USERS';
    TYPE t_seq_rec IS RECORD (
        min_value    NUMBER,
        max_value    NUMBER,
        increment_by NUMBER,
        cache_size   NUMBER
    );
    v_seq_rec  t_seq_rec;
BEGIN
    SELECT
        min_value,
        max_value,
        increment_by,
        cache_size
    INTO v_seq_rec
    FROM
        user_sequences
    WHERE
        sequence_name = v_seq_name;

    v_str_ddl := 'CREATE SEQUENCE '
                 || v_seq_name
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
        v_str_ddl := v_str_ddl
                     || 'CACHE '
                     || v_seq_rec.cache_size
                     || ';';
    ELSE
        v_str_ddl := substr(v_str_ddl, 1, length(v_str_ddl) - 1)
                     || ';';
    END IF;

    dbms_output.put_line(v_str_ddl);
END;
/*
Результат выполнения скрипта:

CREATE SEQUENCE SEQ_USERS
MINVALUE 1
MAXVALUE 9999999999999999999999999999
START WITH 1
INCREMENT BY 1;
*/