/*Разработать набор процедур в рамках пакета для формирования наполнения таблиц. 
На каждую таблицу - свой пакет (PKG_%tablename%). 
Процедуры должны: обрабатывать исключения (в т.ч. и пользовательские),
возвращать код (0 - все хорошо, не 0 - произошла ошибка) и сообщение об ошибке,
для операции вставки возвращать значение первичного ключа, полученного при помощи триггера
параметры в процедурах пакета называть как p_..имя.поля
функции пакета называть f_...
процедуры пакета называть p_...
отформатировать пакет красиво, а не как "курица лапой"*/

-------------------------------------------------------------------
-------------------------------------------------------------------
--Спецификация пакета pkg_users
create or replace NONEDITIONABLE PACKAGE pkg_users IS
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

-------------------------------------------------------------------
--Тело пакета pkg_users
create or replace NONEDITIONABLE PACKAGE BODY pkg_users IS
    --Реализаация функции вставки
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
    ) RETURN NUMBER IS
        v_id knet_users.users_id%TYPE;
    BEGIN
        p_error_code := 0;
        INSERT INTO knet_users VALUES (
            NULL,
            p_is_superuser,
            p_surname,
            p_name,
            p_patronymic,
            p_mail,
            p_username,
            p_password,
            p_is_active,
            p_last_login
        ) RETURNING users_id INTO v_id;

        RETURN v_id;
    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
            RETURN NULL;
    END f_create_row;
    
    --Реализация процедуры чтения
    PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT knet_users%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        SELECT
            *
        INTO p_out_row
        FROM
            knet_users
        WHERE
            users_id = p_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_read_row;
    
    --Реализация процедуры обновления
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
    ) IS
    BEGIN
        p_error_code := 0;
        UPDATE knet_users
        SET
            is_superuser = p_is_superuser,
            surname = p_surname,
            name = p_name,
            patronymic = p_patronymic,
            mail = p_mail,
            username = p_username,
            password = p_password,
            is_active = p_is_active,
            last_login = p_last_login
        WHERE
            users_id = p_users_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_update_row;
    
    --Реализация процедуры удаления
    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        DELETE from knet_users WHERE users_id = p_id;
        EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_delete_row;

END pkg_users;


-------------------------------------------------------------------
-------------------------------------------------------------------
--Спецификация пакета pkg_student
CREATE OR REPLACE NONEDITIONABLE PACKAGE pkg_student IS
    FUNCTION f_create_row (
        p_parent_mail            IN VARCHAR2,
        p_additional_information IN VARCHAR2,
        p_users_id               IN NUMBER,
        p_calss_id               IN NUMBER,
        p_error_code             OUT NUMBER,
        p_error_msg              OUT VARCHAR2
    ) RETURN NUMBER;

    PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT ksch_student%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );

    PROCEDURE p_update_row (
        p_student_id             IN NUMBER,
        p_parent_mail            IN VARCHAR2,
        p_additional_information IN VARCHAR2,
        p_users_id               IN NUMBER,
        p_class_id               IN NUMBER,
        p_error_code             OUT NUMBER,
        p_error_msg              OUT VARCHAR2
    );

    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );
    
    TYPE t_student_row IS RECORD (
        user_id    knet_users.users_id%TYPE,
        fio        VARCHAR2(1000),
        class_name VARCHAR2(5)
    );
    TYPE t_student_table IS
        TABLE OF t_student_row;
    FUNCTION f_get_students_of_teacher (
        p_teacher_id IN ksch_teacher.teacher_id%TYPE
    ) RETURN t_student_table
        PIPELINED;

END pkg_student;

-------------------------------------------------------------------
--Тело пакета pkg_student
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY pkg_student IS
    --Реализаация функции вставки
    FUNCTION f_create_row (
        p_parent_mail            IN VARCHAR2,
        p_additional_information IN VARCHAR2,
        p_users_id               IN NUMBER,
        p_calss_id               IN NUMBER,
        p_error_code             OUT NUMBER,
        p_error_msg              OUT VARCHAR2
    ) RETURN NUMBER IS
        v_id ksch_student.student_id%TYPE;
    BEGIN
        p_error_code := 0;
        INSERT INTO ksch_student VALUES (
            NULL,
            p_parent_mail,
            p_additional_information,
            p_users_id,
            p_calss_id
        ) RETURNING student_id INTO v_id;

        RETURN v_id;
    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
            RETURN NULL;
    END f_create_row;

    --Реализация процедуры чтения
    PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT ksch_student%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        SELECT
            *
        INTO p_out_row
        FROM
            ksch_student
        WHERE
            student_id = p_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_read_row;
    
    --Реализация процедуры обновления
    PROCEDURE p_update_row (
        p_student_id             IN NUMBER,
        p_parent_mail            IN VARCHAR2,
        p_additional_information IN VARCHAR2,
        p_users_id               IN NUMBER,
        p_class_id               IN NUMBER,
        p_error_code             OUT NUMBER,
        p_error_msg              OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        UPDATE ksch_student
        SET
            parent_mail = p_parent_mail,
            additional_information = p_additional_information,
            users_id = p_users_id,
            class_id = p_class_id
        WHERE
            student_id = p_student_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_update_row;

    --Реализация процедуры удаления
    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        DELETE FROM ksch_student
        WHERE
            student_id = p_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_delete_row;
    
    --Реализация функции для 3 пункта задания
    FUNCTION f_get_students_of_teacher (
        p_teacher_id IN ksch_teacher.teacher_id%TYPE
    ) RETURN t_student_table
        PIPELINED
    IS
    BEGIN
        FOR rec IN (
            SELECT
                users_id,
                fio,
                class_name
            FROM
                v_class_students
            WHERE
                teacher_id = p_teacher_id
        ) LOOP
            PIPE ROW ( rec );
        END LOOP;
    END f_get_students_of_teacher;
END pkg_student;