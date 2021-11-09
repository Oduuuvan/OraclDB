--������� �������
CREATE TABLE tmp_table
(
    tmp_table_id NUMBER NOT NULL,
    tmp_column VARCHAR2(25 BYTE)
);

--�������� � ��� ��������� ����
ALTER TABLE tmp_table
    ADD CONSTRAINT pk_tmp_table PRIMARY KEY(tmp_table_id);

--������������� �������
ALTER TABLE tmp_table
    RENAME COLUMN tmp_column TO tmp_col;

--������� ������� ��������������
ALTER TABLE tmp_table
    SET UNUSED COLUMN tmp_col;

--������� ���������������� �������
ALTER TABLE tmp_table
    DROP UNUSED COLUMNS;

--������� ������ �� �������
TRUNCATE TABLE tmp_table;

--�������� sequence ��� ������
CREATE SEQUENCE seq_teacher_subject
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_session
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;
    
CREATE SEQUENCE seq_users
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_cabinet
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;
    
CREATE SEQUENCE seq_class
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_journal_entry
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_lesson
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_lesson_time
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;
    
CREATE SEQUENCE seq_school
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_school_subject
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_student
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE seq_teacher
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;
    
--DML-������� ��� ��������� ���������������� ���������� ���� ������
--���������� KNET_USERS
INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 1, '�������', '���������', '�������������', 'email@exaple.com', 'vsatilin', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '�������', '����', '��������', 'email@exaple.com', 'jrijkova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '����', '��������', 'email@exaple.com', 'oivanov', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '�����', '���������', '���������������', 'email@exaple.com', 'abarov', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '�����', '����������', 'email@exaple.com', 'aguseva', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '�������', '����������', 'email@exaple.com', 'vchikova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '��������', '��������', '���������', 'email@exaple.com', 'vyarmolina', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '��������', '������', '������������', 'email@exaple.com', 'kgasanova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '�����', '����', '�������������', 'email@exaple.com', 'akovach', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '�������', '������', '����������', 'email@exaple.com', 'mudarcev', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '�����', '���������', 'email@exaple.com', 'mudarcev', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '�������', '������', '���������', 'email@exaple.com', 'lgayanova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '���������', '��������', 'email@exaple.com', 'amalova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '���������', '����', '�������������', 'email@exaple.com', 'jsviridova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));        

INSERT INTO knet_users(users_id, is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (seq_users.NEXTVAL, 0, '������', '����', '��������', 'email@exaple.com', 'jsviridova', '123', 0, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));        

--���������� KSCH_SCHOOL
INSERT INTO ksch_school(school_id, address, school_name, mail, phone) 
    VALUES (seq_school.NEXTVAL, '��.������� �.10', '����� �1', 'school@example.com', '89993151020');

INSERT INTO ksch_school(school_id, address, school_name, mail, phone) 
    VALUES (seq_school.NEXTVAL, '���.������������ �.121', '��������', 'school1@example.com', '89373151020');

INSERT INTO ksch_school(school_id, address, school_name, mail, phone) 
    VALUES (seq_school.NEXTVAL, '��.�������', '����� �2', 'school2@example.com', '89613151020');
    
--���������� KSCH_CABINET
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 1, '���', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 2, '���', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 3, '���', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 4, '���', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 5, '���', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 1, '�������', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 2, '�������', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 3, '�������', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 1, '�', 1);
INSERT INTO ksch_cabinet(cabinet_id, cabinet_number, campus, school_id) VALUES (seq_cabinet.NEXTVAL, 1, '�', 1);

--���������� KSCH_TEACHER
INSERT INTO ksch_teacher(teacher_id, work_experience, education, users_id, school_id) 
    VALUES(seq_teacher.NEXTVAL, '5 ��� �����', '������ ������������� (�����)', 4, 1);

INSERT INTO ksch_teacher(teacher_id, work_experience, education, users_id, school_id) 
    VALUES(seq_teacher.NEXTVAL, '3 ���� �����', '������ ������������� (�����)', 5, 1);

INSERT INTO ksch_teacher(teacher_id, work_experience, education, users_id, school_id) 
    VALUES(seq_teacher.NEXTVAL, '6 ��� �����', '������� ����������� (�����)', 6, 1);

INSERT INTO ksch_teacher(teacher_id, work_experience, education, users_id, school_id) 
    VALUES(seq_teacher.NEXTVAL, '6 ��� �����', '������� ����������� (�����)', 21, 1);

INSERT INTO ksch_teacher(teacher_id, work_experience, education, users_id, school_id) 
    VALUES(seq_teacher.NEXTVAL, '15 ��� �����', '������ ������������� (�����)', 22, 1);

--���������� KSCH_CLASS
INSERT INTO ksch_class(class_id, start_year, end_year, name, year_of_study, teacher_id, school_id) 
    VALUES(seq_class.NEXTVAL, TO_DATE('2011', 'yyyy'), TO_DATE('2022', 'yyyy'), '�', 10, 1, 1);

INSERT INTO ksch_class(class_id, start_year, end_year, name, year_of_study, teacher_id, school_id) 
    VALUES(seq_class.NEXTVAL, TO_DATE('2011', 'yyyy'), TO_DATE('2022', 'yyyy'), '�', 10, 2, 1);
    
INSERT INTO ksch_class(class_id, start_year, end_year, name, year_of_study, teacher_id, school_id) 
    VALUES(seq_class.NEXTVAL, TO_DATE('2015', 'yyyy'), TO_DATE('2026', 'yyyy'), '�', 6, 3, 1);

--���������� KSCH_STUDENT
INSERT INTO ksch_student(student_id, parent_mail, additional_information, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', '����� ������ � ������', 7, 4);
    
INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 8, 4);
    
INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 9, 4);

INSERT INTO ksch_student(student_id, parent_mail, additional_information, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', '����� �������, ����� �������������', 10, 4);

INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 11, 4);

INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 12, 4);
    
INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 13, 4);

INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 14, 5);
    
INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 15, 5);
    
INSERT INTO ksch_student(student_id, parent_mail, users_id, class_id) 
    VALUES(seq_student.NEXTVAL, 'parent_mail@example.com', 16, 5);
    
--���������� KSCH_SCHOOL_SUBJECT
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '�������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '���������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '�������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '�������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '��������������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '��������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '�����');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '���������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '���������� ��������');
INSERT INTO ksch_school_subject(school_subject_id, name) VALUES(seq_school_subject.NEXTVAL, '����������');

--���������� KMTM_TEACHER_SUBJECT
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 1, 1);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 1, 2);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 2, 3);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 2, 11);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 3, 4);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 3, 5);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 21, 6);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 21, 7);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 22, 8);
INSERT INTO kmtm_teacher_subject(teacher_subject_id, teacher_id, school_subject_id) VALUES(seq_teacher_subject.NEXTVAL, 22, 10);

--���������� KSCH_LESSON_TIME
INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('8:30','hh24:mi'), TO_DATE('9:10','hh24:mi'));

INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('9:20','hh24:mi'), TO_DATE('10:00','hh24:mi'));

INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('10:20','hh24:mi'), TO_DATE('11:00','hh24:mi'));

INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('11:20','hh24:mi'), TO_DATE('12:00','hh24:mi'));

INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('12:10','hh24:mi'), TO_DATE('12:50','hh24:mi'));

INSERT INTO ksch_lesson_time(lesson_time_id, start_time, end_time) 
    VALUES(seq_lesson_time.NEXTVAL, TO_DATE('13:00','hh24:mi'), TO_DATE('13:40','hh24:mi'));
    
--������� ���� � ����� ����� � ������� KSCH_LESSON
ALTER TABLE ksch_lesson ADD lesson_date DATE;
COMMENT ON COLUMN ksch_lesson.lesson_date IS
    '���� ���������� �����';

--���������� KSCH_LESSON
INSERT INTO ksch_lesson(lesson_id, homework, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, '�10', TO_DATE('25.10.21','dd.mm.yy'), 4, 1, 1, 1, 1);

INSERT INTO ksch_lesson(lesson_id, homework, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, '������ � �����', TO_DATE('25.10.21','dd.mm.yy'), 4, 1, 1, 2, 2);
    
INSERT INTO ksch_lesson(lesson_id, homework, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, '���.6', TO_DATE('25.10.21','dd.mm.yy'), 4, 2, 2, 3, 3);

INSERT INTO ksch_lesson(lesson_id, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, TO_DATE('25.10.21','dd.mm.yy'), 4, 3, 4, 4, 4);
    
INSERT INTO ksch_lesson(lesson_id, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, TO_DATE('25.10.21','dd.mm.yy'), 4, 21, 3, 7, 5);

INSERT INTO ksch_lesson(lesson_id, lesson_date, class_id, teacher_id, cabinet_id, school_subject_id, lesson_time_id) 
    VALUES(seq_lesson.NEXTVAL, TO_DATE('25.10.21','dd.mm.yy'), 4, 22, 9, 10, 6);
    
--���������� KSCH_JOURNAL_ENTRY
INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 4, 5, 1, 2, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 3, 3, 1, 3, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 5, 1, 4, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 2, 1, 5, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 0, 6, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 5, 1, 7, 1);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 5, 5, 1, 2, 2);

INSERT INTO ksch_journal_entry(journal_entry_id, mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 5, 3, 1, 8, 2);

INSERT INTO ksch_journal_entry(journal_entry_id, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 0, 9, 2);

INSERT INTO ksch_journal_entry(journal_entry_id, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 0, 10, 2);

INSERT INTO ksch_journal_entry(journal_entry_id, attendance, student_id, lesson_id) 
    VALUES(seq_journal_entry.NEXTVAL, 0, 11, 2);
    
--���������� KNET_SESSION
INSERT INTO knet_session(session_id, session_data, expire_time) 
    VALUES(seq_session.NEXTVAL, '1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));
    
INSERT INTO knet_session(session_id, session_data, expire_time) 
    VALUES(seq_session.NEXTVAL, '1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_session(session_id, session_data, expire_time) 
    VALUES(seq_session.NEXTVAL, '1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_session(session_id, session_data, expire_time) 
    VALUES(seq_session.NEXTVAL, '1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));

INSERT INTO knet_session(session_id, session_data, expire_time) 
    VALUES(seq_session.NEXTVAL, '1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));