DECLARE
    v_str_ddl  CLOB;
    v_pkg_name VARCHAR2(50) := 'PKG_USERS';
BEGIN
    v_str_ddl := 'CREATE OR REPLACE ';
    FOR rec IN (
        SELECT
            *
        FROM
            user_source
        WHERE
                name = v_pkg_name
            AND type = 'PACKAGE'
        ORDER BY
            line
    ) LOOP
        v_str_ddl := v_str_ddl || rec.text;
    END LOOP;

    dbms_output.put_line(v_str_ddl);
END;
/*
Результат выполнения скрипта:

CREATE OR REPLACE PACKAGE pkg_users IS
    FUNCTION f_create_row (
        p_is_superuser IN NUMBER,
        p_surname      IN VARCHAR2,
        p_name         IN VARCHAR2,
        p_patronymic   IN VARCHAR2,
        p_mail         IN VARCHAR2,
        p_username     IN VARCHAR2,
        p_password     IN VARCHAR2,
        p_is_active    IN NUMBER,
        p_last_login   IN DATE,
        p_error_code   OUT NUMBER,
        p_error_msg    OUT VARCHAR2
    ) RETURN NUMBER;

    PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT knet_users%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );

    PROCEDURE p_update_row (
        p_users_id     IN NUMBER,
        p_is_superuser IN NUMBER,
        p_surname      IN VARCHAR2,
        p_name         IN VARCHAR2,
        p_patronymic   IN VARCHAR2,
        p_mail         IN VARCHAR2,
        p_username     IN VARCHAR2,
        p_password     IN VARCHAR2,
        p_is_active    IN NUMBER,
        p_last_login   IN DATE,
        p_error_code   OUT NUMBER,
        p_error_msg    OUT VARCHAR2
    );

    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );

END pkg_users;
*/