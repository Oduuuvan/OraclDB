CONNECT &username/&password@&db
CREATE TABLE tariff_plan (
    tariff_plan_id  NUMBER PRIMARY KEY,
    plan_name       VARCHAR2(50 CHAR),
    speed           NUMBER(5, 2),
    price_per_month NUMBER(10, 2)
)
;
CREATE TABLE subscriber (
    subscriber_id    NUMBER PRIMARY KEY,
    fio              VARCHAR2(50 CHAR),
    adress           VARCHAR2(50 CHAR),
    personal_account VARCHAR2(50 CHAR),
    tariff_plan_id   NUMBER,
    FOREIGN KEY ( tariff_plan_id )
        REFERENCES tariff_plan ( tariff_plan_id )
)
;
CREATE TABLE services (
    services_id     NUMBER PRIMARY KEY,
    description     VARCHAR2(50 CHAR),
    price_per_month DECIMAL(10, 2)
)
;
CREATE TABLE connected_services (
    connected_services_id NUMBER PRIMARY KEY,
    start_time            DATE,
    end_time              DATE,
    subscriber_id         NUMBER,
    services_id           NUMBER,
    FOREIGN KEY ( subscriber_id )
        REFERENCES subscriber ( subscriber_id ),
    FOREIGN KEY ( services_id )
        REFERENCES services ( services_id )
)
;
CREATE INDEX ifk_subscriber_tariff_plan ON
    subscriber (
        tariff_plan_id
    )
;   
CREATE INDEX ifk_connected_services_sub ON
    connected_services (
        subscriber_id
    )
;     
CREATE INDEX ifk_connected_services_ser ON
    connected_services (
        services_id
    )
;