DECLARE
    v_ddl CLOB;

    FUNCTION f_wrap_get_ddl (
        p_owner IN VARCHAR2,
        p_name  IN VARCHAR2,
        p_type  IN VARCHAR2 := NULL
    ) RETURN CLOB IS
    BEGIN
        RETURN f_get_ddl(p_owner, p_name, p_type);
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RETURN NULL;
    END f_wrap_get_ddl;

BEGIN
    v_ddl := f_wrap_get_ddl('school', 'knet_users', 'table');
    dbms_output.put_line('������ ��� �������'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    v_ddl := f_wrap_get_ddl('school', 'knet_users');
    dbms_output.put_line('������ ��� ������� ��� �������� ����'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    v_ddl := f_wrap_get_ddl('school', 'f_get_ddl', 'index');
    dbms_output.put_line('������ ��� �������'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    v_ddl := f_wrap_get_ddl('school', 'seq_class', 'sequence');
    dbms_output.put_line('������ ��� ��������'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    v_ddl := f_wrap_get_ddl('school', 't_b_users', 'trigger');
    dbms_output.put_line('������ ��� ��������'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    v_ddl := f_wrap_get_ddl('school', 'pkg_users', 'package');
    dbms_output.put_line('������ ��� ������'
                         || chr(10)
                         || v_ddl
                         || chr(10));

    dbms_output.put_line('�������� ����������: ������������ �������� = null');
    v_ddl := f_wrap_get_ddl(NULL, 'pkg_users', 'package');
    dbms_output.put_line('�������� ����������: ����������� ������');
    v_ddl := f_wrap_get_ddl('school', 'chtoto', 'table');
    dbms_output.put_line('�������� ����������: ��������� �������� � ����������� �������');
    v_ddl := f_wrap_get_ddl('school', 'f_get_ddl');
    dbms_output.put_line('�������� ����������: ��� ��� ���������� � �������');
    v_ddl := f_wrap_get_ddl('school', 'v_class_students', 'view');
END;