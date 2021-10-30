--�������� ������ ������� �������� ������ pkg_users.f_create_row
DECLARE
    v_ins_id   knet_users.users_id%TYPE;
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    v_ins_id := pkg_users.f_create_row(0, '������', '����', '������������', 'email@exaple.com',
                                      'akleina', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'),
                                      v_out_code, v_out_msg);

    IF v_out_code = 0 THEN
        dbms_output.put_line('id = ' || v_ins_id);
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;

--�������� ������ ������ ���������� ������ pkg_users.p_read_row
DECLARE
    v_out_msg  VARCHAR2(1000);
    v_out_code NUMBER;
    v_out_row  knet_users%rowtype;
BEGIN
    pkg_users.p_read_row(4, v_out_row, v_out_code, v_out_msg);
    IF v_out_code = 0 THEN
        dbms_output.put_line('id = '
                             || v_out_row.users_id
                             || '   '
                             || v_out_row.surname
                             || ' '
                             || v_out_row.name
                             || ' '
                             || v_out_row.patronymic);

    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;

--�������� ������ ���������� ���������� ������ pkg_users.p_update_row
DECLARE
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    pkg_users.p_update_row(4, 1, '�������', '���������', '�������������',
                          'email@exaple.com', 'vsatilin', '321', 0, TO_DATE('22.10.2021 12:00:00',
                           'dd.mm.yyyy hh24:mi:ss'), v_out_code, v_out_msg);

    IF v_out_code = 0 THEN
        dbms_output.put_line('Success update');
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;

--�������� ������ �������� ���������� ������ pkg_users.p_delete_row
DECLARE
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    pkg_users.p_delete_row(31, v_out_code, v_out_msg);
    IF v_out_code = 0 THEN
        dbms_output.put_line('Success delete');
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;


-------------------------------------------------------------------
-------------------------------------------------------------------
--�������� ������ ������� �������� ������ pkg_student.f_create_row
DECLARE
    v_ins_id   knet_users.users_id%TYPE;
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    v_ins_id := pkg_student.f_create_row(NULL, NULL, 32, 6, v_out_code,
                                        v_out_msg);

    IF v_out_code = 0 THEN
        dbms_output.put_line('id = ' || v_ins_id);
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;

--�������� ������ ������ ���������� ������ pkg_student.p_read_row
DECLARE
    v_out_msg  VARCHAR2(1000);
    v_out_code NUMBER;
    v_out_row  ksch_student%rowtype;
BEGIN
    pkg_student.p_read_row(4, v_out_row, v_out_code, v_out_msg);
    IF v_out_code = 0 THEN
        dbms_output.put_line('id = '
                             || v_out_row.student_id||' '||v_out_row.parent_mail);

    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;
	
END;

--�������� ������ ���������� ���������� ������ pkg_student.p_update_row
DECLARE
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    pkg_student.p_update_row(3, null, '���-��', 8, 4, v_out_code, v_out_msg);

    IF v_out_code = 0 THEN
        dbms_output.put_line('Success update');
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;

--�������� ������ �������� ���������� ������ pkg_student.p_delete_row
DECLARE
    v_out_code NUMBER;
    v_out_msg  VARCHAR2(1000);
BEGIN
    pkg_student.p_delete_row(13, v_out_code, v_out_msg);
    IF v_out_code = 0 THEN
        dbms_output.put_line('Success delete');
        COMMIT;
    ELSE
        dbms_output.put_line('ERROR: '
                             || v_out_code
                             || ' '
                             || v_out_msg);
    END IF;

END;