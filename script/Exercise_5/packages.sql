CONNECT &username/&password@&db
;
CREATE OR REPLACE PACKAGE pkg_tariff_plan IS
    FUNCTION f_create_row (
        p_plan_name IN VARCHAR2,
        p_speed     IN NUMBER,
        p_price     IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) RETURN NUMBER;
	PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT tariff_plan%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );
    PROCEDURE p_update_row (
        p_tariff_plan_id IN NUMBER,
        p_plan_name      IN VARCHAR2,
        p_speed          IN NUMBER,
        p_price          IN NUMBER,
        p_error_code     OUT NUMBER,
        p_error_msg      OUT VARCHAR2
    );
    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    );
END pkg_tariff_plan;
/
CREATE OR REPLACE PACKAGE BODY pkg_tariff_plan IS
    FUNCTION f_create_row (
        p_plan_name  IN VARCHAR2,
        p_speed      IN NUMBER,
        p_price      IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) RETURN NUMBER IS
        v_id tariff_plan.tariff_plan_id%TYPE;
    BEGIN
        p_error_code := 0;
        INSERT INTO tariff_plan VALUES (
            NULL,
            p_plan_name,
            p_speed,
            p_price
        ) RETURNING tariff_plan_id INTO v_id;
        RETURN v_id;
    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
            RETURN NULL;
    END f_create_row;
	PROCEDURE p_read_row (
        p_id         IN NUMBER,
        p_out_row    OUT tariff_plan%rowtype,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        SELECT
            *
        INTO p_out_row
        FROM
            tariff_plan
        WHERE
            tariff_plan_id = p_id;
    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_read_row;
    PROCEDURE p_update_row (
        p_tariff_plan_id IN NUMBER,
        p_plan_name      IN VARCHAR2,
        p_speed          IN NUMBER,
        p_price          IN NUMBER,
        p_error_code     OUT NUMBER,
        p_error_msg      OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        UPDATE tariff_plan
        SET
            plan_name = p_plan_name,
            speed = p_speed,
            price_per_month = p_price
        WHERE
            tariff_plan_id = p_tariff_plan_id;
    EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_update_row;
    PROCEDURE p_delete_row (
        p_id         IN NUMBER,
        p_error_code OUT NUMBER,
        p_error_msg  OUT VARCHAR2
    ) IS
    BEGIN
        p_error_code := 0;
        DELETE from tariff_plan WHERE tariff_plan_id = p_id;
        EXCEPTION
        WHEN OTHERS THEN
            p_error_code := sqlcode;
            p_error_msg := sqlerrm;
    END p_delete_row;
END pkg_tariff_plan;
/