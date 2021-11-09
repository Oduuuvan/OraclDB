/*� ������ ������ ���� ����������� �������, ������� ������� � �������� ������ 
������ �� "������ �������������", � ������������ � ����������� �����������*/

--�������� �������������
CREATE OR REPLACE VIEW v_class_students AS
    SELECT
        u.users_id,
        u.surname
        || ' '
        || u.name
        || ' '
        || u.patronymic  AS fio,
        c.year_of_study
        || ' '
        || c.name        AS class_name,
        t.teacher_id,
        ut.surname
        || ' '
        || ut.name
        || ' '
        || ut.patronymic AS fio_teacher
    FROM
             ksch_teacher t
        JOIN ksch_class   c ON t.teacher_id = c.teacher_id
        JOIN ksch_student s ON c.class_id = s.class_id
        JOIN knet_users   u ON s.users_id = u.users_id
        JOIN knet_users   ut ON t.users_id = ut.users_id;
        
--���������� ���������� ������� ��������� � ������ pkg_student (��. ���� 'exercise_3_2.sql' ������ 328)

--�������� ������ ���������� �������
--������ ������ ������� ���� ��������(id �������, ��� � �����) ��� ������� � teacher_id = 1 
SELECT
    *
FROM
    pkg_student.f_get_students_of_teacher ( 1 );