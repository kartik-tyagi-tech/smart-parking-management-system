-- ===============================
-- CREATE TABLES + SEQUENCES + TRIGGERS
-- ===============================

-- USERS
CREATE TABLE users (
 user_id NUMBER PRIMARY KEY,
 name VARCHAR2(100),
 contact_no VARCHAR2(15),
 email VARCHAR2(100) UNIQUE,
 password_hash VARCHAR2(255)
);

CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_users_bi
BEFORE INSERT ON users FOR EACH ROW
BEGIN
 IF :NEW.user_id IS NULL THEN
  SELECT users_seq.NEXTVAL INTO :NEW.user_id FROM dual;
 END IF;
END;
/

-- VEHICLES
CREATE TABLE vehicles (
 vehicle_id NUMBER PRIMARY KEY,
 vehicle_no VARCHAR2(20),
 vehicle_type VARCHAR2(20),
 user_id NUMBER,
 CONSTRAINT fk_vehicle_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE SEQUENCE vehicles_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_vehicles_bi
BEFORE INSERT ON vehicles FOR EACH ROW
BEGIN
 IF :NEW.vehicle_id IS NULL THEN
  SELECT vehicles_seq.NEXTVAL INTO :NEW.vehicle_id FROM dual;
 END IF;
END;
/

-- LOCATIONS
CREATE TABLE locations (
 location_id NUMBER PRIMARY KEY,
 location_name VARCHAR2(100),
 address VARCHAR2(400),
 capacity NUMBER
);

CREATE SEQUENCE locations_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_locations_bi
BEFORE INSERT ON locations FOR EACH ROW
BEGIN
 IF :NEW.location_id IS NULL THEN
  SELECT locations_seq.NEXTVAL INTO :NEW.location_id FROM dual;
 END IF;
END;
/

-- PARKING_SLOT
CREATE TABLE parking_slot (
 slot_id NUMBER PRIMARY KEY,
 location_id NUMBER,
 status VARCHAR2(20)
);

CREATE SEQUENCE slots_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_slots_bi
BEFORE INSERT ON parking_slot FOR EACH ROW
BEGIN
 IF :NEW.slot_id IS NULL THEN
  SELECT slots_seq.NEXTVAL INTO :NEW.slot_id FROM dual;
 END IF;
END;
/

ALTER TABLE parking_slot
ADD CONSTRAINT fk_slot_location
FOREIGN KEY (location_id) REFERENCES locations(location_id);

-- BOOKING
CREATE TABLE booking (
 booking_id NUMBER PRIMARY KEY,
 user_id NUMBER,
 slot_id NUMBER,
 booking_time DATE DEFAULT SYSDATE,
 start_time TIMESTAMP,
 end_time TIMESTAMP,
 status VARCHAR2(20),
 CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id),
 CONSTRAINT fk_booking_slot FOREIGN KEY (slot_id) REFERENCES parking_slot(slot_id)
);

CREATE SEQUENCE booking_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_booking_bi
BEFORE INSERT ON booking FOR EACH ROW
BEGIN
 IF :NEW.booking_id IS NULL THEN
  SELECT booking_seq.NEXTVAL INTO :NEW.booking_id FROM dual;
 END IF;
END;
/

-- PAYMENT
CREATE TABLE payment (
 payment_id NUMBER PRIMARY KEY,
 booking_id NUMBER,
 amount NUMBER(10,2),
 payment_mode VARCHAR2(20),
 payment_status VARCHAR2(20),
 CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_payment_bi
BEFORE INSERT ON payment FOR EACH ROW
BEGIN
 IF :NEW.payment_id IS NULL THEN
  SELECT payment_seq.NEXTVAL INTO :NEW.payment_id FROM dual;
 END IF;
END;
/

-- ADMIN
CREATE TABLE admin (
 admin_id NUMBER PRIMARY KEY,
 name VARCHAR2(100),
 email VARCHAR2(100) UNIQUE,
 password_hash VARCHAR2(255),
 role VARCHAR2(20)
);

CREATE SEQUENCE admin_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_admin_bi
BEFORE INSERT ON admin FOR EACH ROW
BEGIN
 IF :NEW.admin_id IS NULL THEN
  SELECT admin_seq.NEXTVAL INTO :NEW.admin_id FROM dual;
 END IF;
END;
/

-- NOTIFICATION
CREATE TABLE notification (
 notification_id NUMBER PRIMARY KEY,
 user_id NUMBER,
 booking_id NUMBER,
 message VARCHAR2(4000),
 datetime DATE DEFAULT SYSDATE,
 CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id),
 CONSTRAINT fk_notif_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE SEQUENCE notif_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_notif_bi
BEFORE INSERT ON notification FOR EACH ROW
BEGIN
 IF :NEW.notification_id IS NULL THEN
  SELECT notif_seq.NEXTVAL INTO :NEW.notification_id FROM dual;
 END IF;
END;
/

-- PRICING
CREATE TABLE pricing (
 pricing_id NUMBER PRIMARY KEY,
 location_id NUMBER,
 vehicle_type VARCHAR2(20),
 rate_per_hour NUMBER(10,2),
 CONSTRAINT fk_pricing_location FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE SEQUENCE pricing_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_pricing_bi
BEFORE INSERT ON pricing FOR EACH ROW
BEGIN
 IF :NEW.pricing_id IS NULL THEN
  SELECT pricing_seq.NEXTVAL INTO :NEW.pricing_id FROM dual;
 END IF;
END;
/

COMMIT;