--Разработать набор триггеров для генерации ПК

--Создание триггера автоинкримента users_id
CREATE OR REPLACE TRIGGER t_b_users
BEFORE INSERT ON knet_users
FOR EACH ROW

BEGIN
  SELECT SEQ_USERS.nextval
  INTO   :new.users_id
  FROM   dual;
END;

--Создание триггера автоинкримента cabinet_id
CREATE OR REPLACE TRIGGER t_b_cabinet
BEFORE INSERT ON ksch_cabinet
FOR EACH ROW

BEGIN
  SELECT SEQ_CABINET.nextval
  INTO   :new.cabinet_id
  FROM   dual;
END;

--Создание триггера автоинкримента class_id
CREATE OR REPLACE TRIGGER t_b_class
BEFORE INSERT ON ksch_class
FOR EACH ROW

BEGIN
  SELECT SEQ_CLASS.nextval
  INTO   :new.class_id
  FROM   dual;
END;

--Создание триггера автоинкримента journal_entry_id
CREATE OR REPLACE TRIGGER t_b_journal_entry
BEFORE INSERT ON ksch_journal_entry
FOR EACH ROW

BEGIN
  SELECT SEQ_JOURNAL_ENTRY.nextval
  INTO   :new.journal_entry_id
  FROM   dual;
END;

--Создание триггера автоинкримента lesson_id
CREATE OR REPLACE TRIGGER t_b_lesson
BEFORE INSERT ON ksch_lesson
FOR EACH ROW

BEGIN
  SELECT SEQ_LESSON.nextval
  INTO   :new.lesson_id
  FROM   dual;
END;

--Создание триггера автоинкримента lesson_time_id
CREATE OR REPLACE TRIGGER t_b_lesson_time
BEFORE INSERT ON ksch_lesson_time
FOR EACH ROW

BEGIN
  SELECT SEQ_LESSON_TIME.nextval
  INTO   :new.lesson_time_id
  FROM   dual;
END;

--Создание триггера автоинкримента school_id
CREATE OR REPLACE TRIGGER t_b_school
BEFORE INSERT ON ksch_school
FOR EACH ROW

BEGIN
  SELECT SEQ_SCHOOL.nextval
  INTO   :new.school_id
  FROM   dual;
END;

--Создание триггера автоинкримента school_subject_id
CREATE OR REPLACE TRIGGER t_b_school_subject
BEFORE INSERT ON ksch_school_subject
FOR EACH ROW

BEGIN
  SELECT SEQ_SCHOOL_SUBJECT.nextval
  INTO   :new.school_subject_id
  FROM   dual;
END;

--Создание триггера автоинкримента student_id
CREATE OR REPLACE TRIGGER t_b_student
BEFORE INSERT ON ksch_student
FOR EACH ROW

BEGIN
  SELECT SEQ_STUDENT.nextval
  INTO   :new.student_id
  FROM   dual;
END;

--Создание триггера автоинкримента teacher_id
CREATE OR REPLACE TRIGGER t_b_teacher
BEFORE INSERT ON ksch_teacher
FOR EACH ROW

BEGIN
  SELECT SEQ_TEACHER.nextval
  INTO   :new.teacher_id
  FROM   dual;
END;

--Создание триггера автоинкримента teacher_subject_id
CREATE OR REPLACE TRIGGER t_b_teacher_subject
BEFORE INSERT ON kmtm_teacher_subject
FOR EACH ROW

BEGIN
  SELECT SEQ_TEACHER_SUBJECT.nextval
  INTO   :new.teacher_subject_id
  FROM   dual;
END;

--Создание триггера автоинкримента session_id
CREATE OR REPLACE TRIGGER t_b_session
BEFORE INSERT ON knet_session
FOR EACH ROW

BEGIN
  SELECT SEQ_SESSION.nextval
  INTO   :new.session_id
  FROM   dual;
END;


