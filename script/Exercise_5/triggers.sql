CONNECT &username/&password@&db
;
CREATE OR REPLACE TRIGGER t_b_tariff_plan
BEFORE INSERT ON tariff_plan
FOR EACH ROW
BEGIN
  SELECT seq_tariff_plan.nextval
  INTO   :new.tariff_plan_id
  FROM   dual;
END;
/
CREATE OR REPLACE TRIGGER t_b_subscriber
BEFORE INSERT ON subscriber
FOR EACH ROW
BEGIN
  SELECT seq_subscriber.nextval
  INTO   :new.subscriber_id
  FROM   dual;
END;
/
CREATE OR REPLACE TRIGGER t_b_services
BEFORE INSERT ON services
FOR EACH ROW
BEGIN
  SELECT seq_services.nextval
  INTO   :new.services_id
  FROM   dual;
END;
/
CREATE OR REPLACE TRIGGER t_b_connected_services
BEFORE INSERT ON connected_services
FOR EACH ROW
BEGIN
  SELECT seq_connected_services.nextval
  INTO   :new.connected_services_id
  FROM   dual;
END;
/