DECLARE
    v_str_ddl    CLOB;
    v_owner      VARCHAR2(50) := 'SCHOOL';
    v_seq_name   VARCHAR2(50) := 'SEQ_KNET_USERS';
    v_check_seq_name VARCHAR2(50);
    ex_name_exist EXCEPTION;
BEGIN
    SELECT
        sequence_name
    INTO v_check_seq_name
    FROM
        all_sequences
    WHERE
        sequence_owner = v_owner
        AND sequence_name = v_seq_name;

    RAISE ex_name_exist;
EXCEPTION
    WHEN no_data_found THEN
        v_str_ddl := v_str_ddl
                     || 'CREATE SEQUENCE '
                     || v_seq_name
                     || chr(10)
                     || 'MINVALUE 1'
                     || chr(10)
                     || 'START WITH 1'
                     || chr(10)
                     || 'INCREMENT BY 1'
                     || chr(10)
                     || 'NOCACHE;';

        dbms_output.put_line(v_str_ddl);
    WHEN ex_name_exist THEN
        raise_application_error(-20001, 'Введенное имя '||v_check_seq_name||' уже занято');
END;
/*
Результат выполнения скрипта:

CREATE SEQUENCE SEQ_KNET_USERS
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;
*/