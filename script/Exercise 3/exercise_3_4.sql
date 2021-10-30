--Объявить явный курсор и в цикле вывести значение столбцов таблицы

DECLARE
    CURSOR cur_students IS
    SELECT
        *
    FROM
        v_class_students;

    v_rec cur_students%rowtype;
BEGIN
    OPEN cur_students;
	
    LOOP
        FETCH cur_students INTO v_rec;
        EXIT WHEN cur_students%notfound;
        dbms_output.put_line(v_rec.users_id
                             || ' '
                             || v_rec.fio);
    END LOOP;

    CLOSE cur_students;
END;