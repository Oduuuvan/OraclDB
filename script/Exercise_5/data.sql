CONNECT &username/&password@&db
INSERT INTO tariff_plan (
    plan_name,
    speed,
    price_per_month
) VALUES (
    'Домашний',
    100.00,
    600.00
)
;
INSERT INTO tariff_plan (
    plan_name,
    speed,
    price_per_month
) VALUES (
    'Сотовый',
    20.00,
    300.00
)
;
INSERT INTO tariff_plan (
    plan_name,
    speed,
    price_per_month
) VALUES (
    'Безлимит',
    100.00,
    800.00
)
;
INSERT INTO services (
    description,
    price_per_month
) VALUES (
    'ТВ',
    200.00
)
;
INSERT INTO services (
    description,
    price_per_month
) VALUES (
    'Домашний телефон',
    100.00
)
;
INSERT INTO services (
    description,
    price_per_month
) VALUES (
    'Бесплатные СМС',
    150.00
)
;
INSERT INTO subscriber (
    fio,
    adress,
    personal_account,
    tariff_plan_id
) VALUES (
    'Сат Влад Ал',
    'пр.Пупкина д.15',
    '456456',
    1
)
;
INSERT INTO subscriber (
    fio,
    adress,
    personal_account,
    tariff_plan_id
) VALUES (
    'Май Окс Ал',
    'пр.Витязь д.70',
    '654848',
    2
)
;
INSERT INTO subscriber (
    fio,
    adress,
    personal_account,
    tariff_plan_id
) VALUES (
    'Тах Эл Тар',
    'ул.Кропоткина д.3',
    '584654',
    3
)
;
INSERT INTO subscriber (
    fio,
    adress,
    personal_account,
    tariff_plan_id
) VALUES (
    'Ткач Рома Вик',
    'ул.Рабочая д.21',
    '487121',
    1
)
;
INSERT INTO connected_services (
    start_time,
    end_time,
    subscriber_id,
    services_id
) VALUES (
    TO_DATE('2021-01-14', 'yyyy-mm-dd'),
    TO_DATE('2021-04-14', 'yyyy-mm-dd'),
    1,
    1
)
;
INSERT INTO connected_services (
    start_time,
    end_time,
    subscriber_id,
    services_id
) VALUES (
    TO_DATE('2021-01-14', 'yyyy-mm-dd'),
    TO_DATE('2022-01-14', 'yyyy-mm-dd'),
    2,
    1
)
;
INSERT INTO connected_services (
    start_time,
    end_time,
    subscriber_id,
    services_id
) VALUES (
    TO_DATE('2021-01-14', 'yyyy-mm-dd'),
    TO_DATE('2021-02-14', 'yyyy-mm-dd'),
    3,
    3
)
;